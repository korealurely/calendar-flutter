import 'package:flutter/material.dart';
import 'package:flutter_calendar/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:flutter_calendar/provider/shift_config_provider.dart';
import 'package:flutter/services.dart';

class ShiftConfigEditBottomSheet extends ConsumerStatefulWidget {
  final ShiftConfig? config;
  const ShiftConfigEditBottomSheet({super.key, this.config});

  @override
  ConsumerState<ShiftConfigEditBottomSheet> createState() => _ShiftConfigEditBottomSheetState();
}

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
    _selectedColorValue = widget.config?.colorValue ?? 0xFF2196F3;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _showColorPicker() {
    Color pickedColor = Color(_selectedColorValue);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // 🚀 【优化 1】：取色弹窗底色全自动感应暗黑
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          AppLocalizations.of(context)!.setShiftColor,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold,fontSize: 16),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickedColor,
            onColorChanged: (color) => pickedColor = color,
            // 🚀 【优化 2】：让 ColorPicker 内部的文本和编辑框也能看清
            pickerAreaBorderRadius: BorderRadius.circular(12),
            colorPickerWidth: 300,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, elevation: 0),
            child:  Text(AppLocalizations.of(context)!.confirm, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () {
              setState(() {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 20, left: 20, right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        // 🚀 【优化 3】：弹窗大背景全自动换装（白天白，黑夜深灰卡片色）
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)
                ),
              ),
            ),
            Text(
              _isEditMode ? AppLocalizations.of(context)!.editShift : AppLocalizations.of(context)!.addShift,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color // 🚀 【优化 4】：标题色同步
              ),
            ),
            const SizedBox(height: 20),

            // 🚀 【优化 5】：输入框加入暗黑模式样式修正
            TextField(
              maxLength: 4,
              controller: _nameController,
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.shiftNameHint,
                labelStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black45),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _labelController,
              maxLength: 2,
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.shiftLabelHint,
                labelStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black45),
                border: const OutlineInputBorder(),
                counterText: "",
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
                    ),
                    onPressed: () async {
                      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        setState(() {
                          _startTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                    icon: Icon(Icons.access_time, size: 14, color: isDark ? Colors.white60 : Colors.black54),
                    label: Text(_startTime ?? AppLocalizations.of(context)!.startShift, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(AppLocalizations.of(context)!.to, style: TextStyle(color: isDark ? Colors.white60 : Colors.black54))
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
                    ),
                    onPressed: () async {
                      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        setState(() {
                          _endTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                    icon: Icon(Icons.access_time, size: 14, color: isDark ? Colors.white60 : Colors.black54),
                    label: Text(_endTime ?? AppLocalizations.of(context)!.endWork, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.customColor, style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 14)),
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
                      boxShadow: [
                        BoxShadow(
                            color: isDark ? Colors.black38 : Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2)
                        )
                      ],
                    ),
                    child: const Icon(Icons.colorize, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                Text(AppLocalizations.of(context)!.setColor, style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13))
              ],
            ),
            const SizedBox(height: 32),

            if(_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),

            Row(
              children: [
                if (_isEditMode)
                  TextButton.icon(
                    onPressed: () async {
                      await ref.read(shiftConfigViewModelProvider.notifier).deleteConfigById(widget.config!.id);
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline, color: Color(0xFFFF5252)),
                    label:  Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Color(0xFFFF5252), fontWeight: FontWeight.bold)),
                  ),
                const Spacer(),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey)),
                ),
                const SizedBox(width: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    if (_nameController.text.isEmpty || _labelController.text.isEmpty) {
                      HapticFeedback.vibrate();
                      setState(() {
                        _errorMessage = "⚠️ ${AppLocalizations.of(context)!.shiftErrMsg}";
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
                  child:  Text(AppLocalizations.of(context)!.confirm, style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}