import 'dart:async';
import 'dart:convert'; //json序列化
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

class MqttManager {
  MqttManager._privateConstructor();

  static final MqttManager instance = MqttManager._privateConstructor();

  MqttServerClient? _client;

  final StreamController<bool> _isMqttConnectedController =
      StreamController<bool>.broadcast();

  Stream<bool> get isMqttConnected => _isMqttConnectedController.stream;
  bool _currentConnected = false;

  final StreamController<String> _isWeightMsgSendController =
      StreamController<String>.broadcast();

  Stream<String> get isWeightMsgSend => _isWeightMsgSendController.stream;

  Future<void> connect(String brokeIp) async {
    final String clientId = const Uuid().v4();
    _client = MqttServerClient(brokeIp, clientId);
    _client!.port = 1883;
    _client!.logging(on: false); //关闭详细日志
    _client!.keepAlivePeriod = 20;

    _client!.onConnected = () {
      print("MQTT 连接成功，当前服务器 ：$brokeIp");
      _currentConnected = true;
      _isMqttConnectedController.add(true);

      //连接成功后直接订阅
      _subscribeToTopic("dream/scale/result");
    };

    _client!.onDisconnected = () {
      print("MQTT连接断开");
      _currentConnected = false;
      _isMqttConnectedController.add(false);
    };

    //配置连接报文
    final connMessage =
        MqttConnectMessage().withClientIdentifier(clientId).startClean();
    _client!.connectionMessage = connMessage;

    try {
      print("开始连接 MQTT服务器...");
      await _client!.connect();
    } catch (e) {
      print("MQTT启动异常 $e");
      _currentConnected = false;
      _isMqttConnectedController.add(false);
      _client!.disconnect();
    }
  }

//内部订阅逻辑

void _subscribeToTopic(String topic){
    _client!.subscribe(topic, MqttQos.atMostOnce);
    
    //监听消息并解析
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c){
      final MqttPublishMessage recMsg = c[0].payload as MqttPublishMessage;
      final String jsonString = utf8.decode(recMsg.payload.message);
      print("收到订阅主题[${c[0].topic}]的消息: $jsonString'");
    });
}

//发送体重数据
Future<void> publishWeight(double weight,int impedance) async{
    if(_client == null || !_currentConnected){
      print("数据发送失败：MQTT未连接");
      _isWeightMsgSendController.add("数据发送失败：未连接服务器");
      return;
    }

    final Map<String,dynamic> payloadMap = {
      "weight":weight,
      "impedance":impedance,
      "timestamp":DateTime.now().millisecondsSinceEpoch,
    };
    final String payload = jsonEncode(payloadMap);
    try{
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(payload);

      _client!.publishMessage("dream/scale/data", MqttQos.atMostOnce, builder.payload!,);
      print("数据发送成功");
      _isWeightMsgSendController.add("数据发送成功");
    }catch(e){
      print("数据发送失败 $e");
      _isWeightMsgSendController.add("数据发送失败");
    }
}

void dispose(){
    _isMqttConnectedController.close();
    _isWeightMsgSendController.close();
}
}
