import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_calendar/data/calendar_weight.dart';
import 'package:flutter_calendar/repository/weight_repository.dart';
// 🌟 引入你的 MQTT 管理类
import 'mqtt_manager.dart';

class BleManager {
  BleManager._privateConstructor() {
    // 🌟 【核心看门狗】在构造函数里初始化全局的独立清洗监听流
    _initReportStreamWatcher();
  }
  static final BleManager instance = BleManager._privateConstructor();

  final StreamController<CalendarWeight?> _scaleStateController = StreamController<CalendarWeight?>.broadcast();
  final StreamController<bool> _isScanningController = StreamController<bool>.broadcast();

  Stream<CalendarWeight?> get scaleState => _scaleStateController.stream;
  Stream<bool> get isScanning => _isScanningController.stream;

  bool _currentIsScanning = false;
  CalendarWeight? _currentScaleSata;

  Timer? _timeoutTimer;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _reportSubscription; // 🌟 专门用于持久维护上报监听的订阅

  DateTime currentDate = DateTime.now();

  // 🎯 【新增】：用来持有你的体重仓库引用
  WeightRepository? _weightRepository;

  // 🎯 【新增】：提供一个初始化注入的方法，在 App 启动或者页面初始化时调用一次
  void initRepository(WeightRepository repository) {
    _weightRepository = repository;
  }

  /// 🌟 【数据清洗核心核心】完全复刻你在 Compose ViewModel 里的那一套逻辑
  void _initReportStreamWatcher() {
    _reportSubscription = _scaleStateController.stream
    // 1. 过滤 null（对应 Kotlin .filterNotNull()）
        .where((data) => data != null)
        .cast<CalendarWeight>()
    // 2. 核心过滤器：只留“稳定且有阻抗”或“正在测量（阻抗为0）”的状态（对应 Kotlin .filter）
        .where((data) => (data.isStable && data.impedance > 0) || data.impedance == 0)
    // 3. 关键去重机制：Dart 的返回 true 代表【相同就拦截】（对应 Kotlin .distinctUntilChanged）
        .distinct((old, current) =>
    old.isStable == current.isStable && old.impedance == current.impedance
    )
    // 4. 流量放行，执行单次安全上报（对应 Kotlin .collect）
        .listen((cleanData) async{
      if (cleanData.isStable && cleanData.impedance > 0) {
        print("🚀【BleManager 独立看门狗机制】检测到一轮全新的有效测量，触发 MQTT 物理单次上报！");
        // 完美触发你的 MQTT 发送！
        //MqttManager.instance.publishWeight(cleanData.weight, cleanData.impedance);

        // 🎯 核心调用：通过你的 Isar 实例直接写入
        // 假设你的单例叫 IsarService.instance.isar，或者你有一个全局的 isar 实例
        if(_weightRepository != null){
          await _weightRepository!.saveDayWeight(cleanData);
        }
      }
    });
  }



  Future<void> startScan() async {
    print("startScan 开启扫描");


    // 核心安全锁：确保 iOS 蓝牙状态已经初始化完毕并处于开启状态
    // wait: true 会在状态为 unknown 或 resetting 时强行等待，直到它变成 on
    // timeout: 3 会在 3 秒后超时，防止死锁
    try {
      await FlutterBluePlus.adapterState
          .where((val) => val == BluetoothAdapterState.on)
          .first
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      print("蓝牙未准备就绪或未开启: $e");
      // 可以在这里提示用户：“请检查蓝牙是否开启”
      return;
    }

    // 状态百分百确定是 On 了，再安全调用底层扫描
    try {
      if (_currentIsScanning) await stopScan();
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 30));
    } catch (e) {
      print("扫描失败: $e");
    }

    _updateScanningState(true);

    _resetTimeoutTimer();

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        final String deviceName = result.advertisementData.advName;

        // 1. 安全提取 181b 广播
        final serviceEntries = result.advertisementData.serviceData.entries.where(
                (element) => element.key.toString().toLowerCase().contains('181b')
        );
        if (serviceEntries.isEmpty) continue;
        final List<int> bytes = serviceEntries.first.value;

        // 2. 华米/小米体脂秤 2 核心协议解析
        if (deviceName == "MIBFS" && bytes.length >= 13) {
          final int status = bytes[1];
          // 修正：用标准的 0x20 掩码检测体重是否锁定稳定
          final bool isStable = (status & 0x20) != 0;

          final int iLo = bytes[9] & 0xFF;
          final int iHi = bytes[10] & 0xFF;
          final int rawImpedance = (iHi << 8) | iLo;
          final int impedance = (rawImpedance > 5000 || rawImpedance <= 0) ? 0 : rawImpedance;

          final int wLo = bytes[11] & 0xFF;
          final int wHi = bytes[12] & 0xFF;
          final double weight = ((wHi << 8) | wLo) / 200.0;

          final int targetDateId = currentDate.year * 10000 + currentDate.month * 100 + currentDate.day;

          final newData = CalendarWeight()
          ..dateId = targetDateId
          ..weight  =  weight
          ..  impedance = impedance
          ..  isStable = isStable;


          // 3. 只有当数值真正发生波动变动时，才重置倒计时（防止同一个广播包高频重置导致无法超时关闭）
          if (newData.weight != _currentScaleSata?.weight || newData.impedance != _currentScaleSata?.impedance) {
            _resetTimeoutTimer();
          }

          // 4. 【高频疯狂发射】只管往流里灌。上面的 initReportStreamWatcher 会像筛子一样把它洗干净
          _currentScaleSata = newData;
          _scaleStateController.add(newData);
        }
      }
    });
  }

  void _resetTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 30), () {
      if (_currentIsScanning) stopScan();
    });
  }

  Future<void> stopScan() async {
    print("stopScan 停止扫描");
    _timeoutTimer?.cancel();
    _scanSubscription?.cancel();
    await FlutterBluePlus.stopScan();

    _updateScanningState(false);
    _currentScaleSata = null;
    _scaleStateController.add(null);
  }

  void _updateScanningState(bool scanning) {
    _currentIsScanning = scanning;
    _isScanningController.add(scanning);
  }

  // 提供一个释放全局流订阅的入口，虽然单例几乎不需要销毁
  void dispose() {
    _reportSubscription?.cancel();
    _scaleStateController.close();
    _isScanningController.close();
  }
}