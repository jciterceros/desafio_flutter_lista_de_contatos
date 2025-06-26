import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/contato.dart';
import '../utils/validation_utils.dart';

class ContatoCard extends StatelessWidget {
  final Contato contato;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onShare;

  const ContatoCard({
    super.key,
    required this.contato,
    required this.onEdit,
    required this.onDelete,
    required this.onCall,
    required this.onWhatsApp,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Foto do contato
            _buildProfileImage(),
            const SizedBox(width: 16.0),

            // Informações do contato
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contato.nome,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (contato.telefone != null && contato.telefone!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        ValidationUtils.formatTelefone(contato.telefone!),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  if (contato.diaNascimento != null &&
                      contato.mesNascimento != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.cake, size: 16.0, color: Colors.grey[600]),
                          const SizedBox(width: 4.0),
                          Text(
                            '${contato.diaNascimento}/${contato.mesNascimento.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (contato.fazAniversarioHoje) ...[
                            const SizedBox(width: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Text(
                                '🎂',
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Menu de ações
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                  case 'call':
                    onCall();
                    break;
                  case 'whatsapp':
                    onWhatsApp();
                    break;
                  case 'share':
                    onShare();
                    break;
                }
              },
              itemBuilder:
                  (context) => [
                    if (contato.telefone != null &&
                        contato.telefone!.isNotEmpty) ...[
                      PopupMenuItem(
                        value: 'call',
                        child: Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.green),
                            const SizedBox(width: 8.0),
                            Text('APP_ICO_LIGAR'.tr()),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'whatsapp',
                        child: Row(
                          children: [
                            const Icon(Icons.message, color: Colors.green),
                            const SizedBox(width: 8.0),
                            Text('APP_TXT_FALAR_ZAP'.tr()),
                          ],
                        ),
                      ),
                    ],
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, color: Colors.blue),
                          const SizedBox(width: 8.0),
                          Text('APP_ICO_EDITAR'.tr()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          const Icon(Icons.share, color: Colors.orange),
                          const SizedBox(width: 8.0),
                          const Text('Compartilhar'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          const SizedBox(width: 8.0),
                          Text('APP_ICO_EXCLUIR'.tr()),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color.fromARGB(255, 44, 59, 47),
          width: 2.0,
        ),
      ),
      child: ClipOval(
        child:
            contato.fotoUrl != null && contato.fotoUrl!.isNotEmpty
                ? Image.network(
                  contato.fotoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/person.png', fit: BoxFit.cover);
                  },
                )
                : Image.asset('assets/person.png', fit: BoxFit.cover),
      ),
    );
  }
}
