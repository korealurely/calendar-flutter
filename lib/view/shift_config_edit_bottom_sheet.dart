import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:flutter_calendar/provider/shift_config_provider.dart';
import 'package:flutter/services.dart';

// ✅ 有text输入的控件时，单独创建StatefulWidget，老哥这波在第五层！
class ShiftConfigEditBottomSheet extends ConsumerStatefulWidget {
  final ShiftConfig? config;
  const ShiftConfigEditBottomSheet({super.key, this.config});

  @override
  ConsumerState<ShiftConfigEditBottomSheet> createState() => _ShiftConfigEditBottomSheetState();
}

// 💡 遵循 Flutter 命名规范，将 State 类加上 State 后缀
class _ShiftConfigEditBottomSheetState extends ConsumerState<ShiftConfigEditBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  String? _startTime;
  String? _endTime;
  late int _selectedColorValue;
  bool get _isEditMode => widget.config != null;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.config?.name ?? "";
    _labelController.text = widget.config?.label ?? "";
    _startTime = widget.config?.startTime ?? "09:00";
    _endTime = widget.config?.endTime ?? "18:00";
    _selectedColorValue = widget.config?.colorValue ?? 0xFF2196F3; // 默认蓝
  }

  @override
  void dispose() {
    _nameController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _showColorPicker() {
    Color pickedColor = Color(_selectedColorValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("选择班次颜色"),
        content: SingleChildScrollView(
          // 💡 提示：ColorPicker 较重，如果觉得大，可以换成 MaterialPicker()
          child: ColorPicker(
            pickerColor: pickedColor,
            onColorChanged: (color) => pickedColor = color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("取消"),
          ),
          ElevatedButton(
            child: const Text("选定"),
            onPressed: () {
              setState(() {
                // 🛠️ 修正：用 .value 获取 int 颜色值更标准稳健
                _selectedColorValue = pickedColor.toARGB32();
              });
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20, left: 20, right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text(
              _isEditMode ? "修改班次" : "添加班次",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🛠️ 补全：之前老哥漏掉了班次名称的输入框
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '班次名称（如: 早班）', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _labelController,
              maxLength: 2,
              decoration: const InputDecoration(labelText: '日历格子标签（如: 早）', border: OutlineInputBorder(), counterText: ""),
            ),
            const SizedBox(height: 16),

            // 🛠️ 修正：把时间选择的 Row 独立闭合出来，不要把下面的颜色组件装进去
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        setState(() {
                          _startTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time, size: 14), // 稍微放大到14，更清晰
                    label: Text(_startTime ?? "上班时间"),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("至")),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        setState(() {
                          _endTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time, size: 14),
                    label: Text(_endTime ?? "下班时间"),
                  ),
                ),
              ],
            ), // 👈 完美闭合横向 Row

            // 🛠️ 修正：以下垂直排布的组件安全回归到外层的 Column 中
            const SizedBox(height: 20),
            const Text("专属颜色", style: TextStyle(color: Colors.black54, fontSize: 14)),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: _showColorPicker,
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: Color(_selectedColorValue),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                      ],
                    ),
                    child: const Icon(Icons.colorize, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                const Text("点击设定颜色", style: TextStyle(color: Colors.black38, fontSize: 13))
              ],
            ),
            const SizedBox(height: 32),

            if(_errorMessage != null)
              Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                    _errorMessage!,
                  style: const TextStyle(color: Colors.redAccent,fontSize: 13,fontWeight: FontWeight.bold),
                ),
              ),
            // 🎯 底部按钮确认区
            Row(
              children: [
                if (_isEditMode)
                  TextButton.icon(
                    onPressed: () async {
                      await ref.read(shiftConfigViewModelProvider.notifier).deleteConfigById(widget.config!.id);
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    label: const Text("删除", style: TextStyle(color: Colors.redAccent)),
                  ),
                const Spacer(),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("取消", style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (_nameController.text.isEmpty || _labelController.text.isEmpty) {
                      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("请完整填写班次名称和标签")));
                      HapticFeedback.vibrate();
                      setState(() {
                        _errorMessage = "⚠️ 请完整填写班次名称和标签！";
                      });
                      return;
                    }
                    final viewModel = ref.read(shiftConfigViewModelProvider.notifier);
                    if (_isEditMode) {
                      await viewModel.changeShiftConfig(
                        id: widget.config!.id,
                        name: _nameController.text,
                        label: _labelController.text,
                        startTime: _startTime ?? "09:00",
                        endTime: _endTime ?? "18:00",
                        colorValue: _selectedColorValue,
                      );
                    } else {
                      // 💡 这里的 id: 0 请确保你的底层 repository 支持 0 作为新增占位符
                      await viewModel.changeShiftConfig(
                        id: 0,
                        name: _nameController.text,
                        label: _labelController.text,
                        startTime: _startTime ?? "09:00",
                        endTime: _endTime ?? "18:00",
                        colorValue: _selectedColorValue,
                      );
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text("确认提交"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}