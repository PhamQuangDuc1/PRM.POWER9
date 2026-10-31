import 'package:flutter/material.dart';

Future<bool> showLeaveSessionDialog(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rời phiên thư giãn?'),
        content: const Text(
          'Phiên này chưa được ghi nhận. Bỏ phiên sẽ không tạo bản ghi hoàn thành.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Ở lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Bỏ phiên'),
          ),
        ],
      ),
    ) ??
    false;
