import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpcoesScreen extends StatefulWidget {
  const OpcoesScreen({super.key});

  @override
  State<OpcoesScreen> createState() => _OpcoesScreenState();
}

class _OpcoesScreenState extends State<OpcoesScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  bool _exibirContador = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _carregarConfiguracoes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _nomeController.text = prefs.getString('nome_usuario') ?? '';
        _emailController.text = prefs.getString('email_usuario') ?? '';
        _exibirContador = prefs.getBool('exibir_contador') ?? true;
      });
    } catch (e) {
      debugPrint('Erro ao carregar configurações: $e');
    }
  }

  Future<void> _salvarConfiguracoes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nome_usuario', _nomeController.text.trim());
      await prefs.setString('email_usuario', _emailController.text.trim());
      await prefs.setBool('exibir_contador', _exibirContador);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configurações salvas com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar configurações: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APP_ICO_OPCS'.tr()),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seção de informações do usuário
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
                      'Informações do Usuário',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color.fromARGB(255, 44, 59, 47),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'APP_LABEL_NOME_USUARIO'.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'APP_LABEL_EMAIL_USUARIO'.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Seção de configurações do app
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
                      'Configurações do App',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color.fromARGB(255, 44, 59, 47),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    SwitchListTile(
                      title: Text('APP_LABEL_EXIBIR_CONTADOR'.tr()),
                      subtitle: const Text('Mostrar contador de contatos'),
                      value: _exibirContador,
                      onChanged: (value) {
                        setState(() {
                          _exibirContador = value;
                        });
                      },
                      activeColor: const Color.fromARGB(255, 44, 59, 47),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text('APP_LABEL_IDIOMA_PT'.tr()),
                      subtitle: Text(
                        context.locale.languageCode == 'pt'
                            ? 'Português (Brasil)'
                            : 'English (US)',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _mostrarDialogIdioma();
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Botão salvar
            ElevatedButton(
              onPressed: _isLoading ? null : _salvarConfiguracoes,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'APP_BOTAO_SALVAR'.tr(),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogIdioma() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Selecionar Idioma'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Text('🇧🇷'),
                  title: const Text('Português (Brasil)'),
                  onTap: () {
                    context.setLocale(const Locale('pt', 'BR'));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Text('🇺🇸'),
                  title: const Text('English (US)'),
                  onTap: () {
                    context.setLocale(const Locale('en', 'US'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
    );
  }
}
