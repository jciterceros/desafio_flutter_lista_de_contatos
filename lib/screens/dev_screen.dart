import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('APP_ICO_DEV'.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header com logo
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 44, 59, 47),
                      const Color.fromARGB(255, 44, 59, 47),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.people, size: 64, color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      'APP_TEXT_BEM_VEINDO'.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lista de Contatos Flutter',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Informações do projeto
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre o Projeto',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color.fromARGB(255, 44, 59, 47),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    _buildInfoItem(
                      icon: Icons.code,
                      title: 'Tecnologias',
                      subtitle: 'Flutter, Dart, Back4App, REST API',
                    ),

                    _buildInfoItem(
                      icon: Icons.apps,
                      title: 'Funcionalidades',
                      subtitle:
                          'CRUD de contatos, upload de imagens, aniversários, internacionalização',
                    ),

                    _buildInfoItem(
                      icon: Icons.storage,
                      title: 'Backend',
                      subtitle: 'Back4App (Parse Server)',
                    ),

                    _buildInfoItem(
                      icon: Icons.language,
                      title: 'Idiomas',
                      subtitle: 'Português (BR) e Inglês (US)',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Links e ações
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Links Úteis',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color.fromARGB(255, 44, 59, 47),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    ListTile(
                      leading: const Icon(Icons.link, color: Colors.blue),
                      title: const Text('GitHub do Projeto'),
                      subtitle: const Text('Ver código fonte'),
                      trailing: const Icon(Icons.open_in_new),
                      onTap:
                          () => _launchUrl(
                            'https://github.com/jciterceros/desafio_flutter_lista_de_contatos',
                          ),
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons.description,
                        color: Colors.green,
                      ),
                      title: const Text('Documentação Flutter'),
                      subtitle: const Text('docs.flutter.dev'),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () => _launchUrl('https://docs.flutter.dev'),
                    ),

                    ListTile(
                      leading: const Icon(Icons.cloud, color: Colors.orange),
                      title: const Text('Back4App'),
                      subtitle: const Text('backend-as-a-service'),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () => _launchUrl('https://back4app.com'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Ações
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ações',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color.fromARGB(255, 44, 59, 47),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    ListTile(
                      leading: const Icon(Icons.share, color: Colors.purple),
                      title: const Text('Compartilhar App'),
                      subtitle: const Text('Indicar para amigos'),
                      onTap: () {
                        Share.share(
                          'Confira este app de lista de contatos feito com Flutter! '
                          'https://github.com/jciterceros/desafio_flutter_lista_de_contatos',
                          subject: 'Lista de Contatos Flutter',
                        );
                      },
                    ),

                    ListTile(
                      leading: const Icon(Icons.star, color: Colors.amber),
                      title: const Text('Avaliar App'),
                      subtitle: const Text('Deixe sua avaliação'),
                      onTap: () {
                        // Implementar avaliação na loja
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Funcionalidade de avaliação em desenvolvimento',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Versão do app
            Center(
              child: Text(
                'Versão 1.0.0',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 44, 59, 47), size: 24),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
