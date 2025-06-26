import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class OrdenacaoDialog extends StatelessWidget {
  const OrdenacaoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('APP_TXT_ORDEM_LABEL'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.sort_by_alpha),
            title: Text('APP_TXT_ORDEM_VALOR_1'.tr()),
            onTap: () => Navigator.pop(context, 'A-Z'),
          ),
          ListTile(
            leading: const Icon(Icons.sort_by_alpha_outlined),
            title: Text('APP_TXT_ORDEM_VALOR_2'.tr()),
            onTap: () => Navigator.pop(context, 'Z-A'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
