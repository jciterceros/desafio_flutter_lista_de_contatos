import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/contato.dart';
import '../services/api_service.dart';
import '../widgets/contato_card.dart';
import '../widgets/ordenacao_dialog.dart';
import 'contato_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Contato> _contatos = [];
  List<Contato> _contatosFiltrados = [];
  bool _isLoading = true;
  String _ordenacao = 'A-Z';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService.initialize();
    _carregarContatos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarContatos() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final contatos = await _apiService.getContatos();
      setState(() {
        _contatos = contatos;
        _aplicarFiltros();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _mostrarErro('Erro ao carregar contatos: $e');
    }
  }

  void _aplicarFiltros() {
    String termoBusca = _searchController.text.toLowerCase();

    _contatosFiltrados =
        _contatos.where((contato) {
          return contato.nome.toLowerCase().contains(termoBusca) ||
              (contato.telefone?.contains(termoBusca) ?? false);
        }).toList();

    _ordenarContatos();
  }

  void _ordenarContatos() {
    if (_ordenacao == 'A-Z') {
      _contatosFiltrados.sort((a, b) => a.nome.compareTo(b.nome));
    } else {
      _contatosFiltrados.sort((a, b) => b.nome.compareTo(a.nome));
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  Future<void> _mostrarDialogOrdenacao() async {
    final resultado = await showDialog<String>(
      context: context,
      builder: (context) => const OrdenacaoDialog(),
    );

    if (resultado != null) {
      setState(() {
        _ordenacao = resultado;
        _aplicarFiltros();
      });
    }
  }

  Future<void> _editarContato(Contato contato) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContatoFormScreen(contato: contato),
      ),
    );

    if (resultado == true) {
      _carregarContatos();
    }
  }

  Future<void> _excluirContato(Contato contato) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('APP_ALERT_TITULO_EXCLUIR'.tr()),
            content: Text('APP_ALERT_MENSAGEM_EXCLUIR'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('APP_ALERT_BOTAO_NAO'.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('APP_ALERT_BOTAO_SIM'.tr()),
              ),
            ],
          ),
    );

    if (confirmar == true) {
      try {
        await _apiService.deleteContato(contato.objectId!);
        _carregarContatos();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contato excluído com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        _mostrarErro('Erro ao excluir contato: $e');
      }
    }
  }

  Future<void> _ligarParaContato(Contato contato) async {
    if (contato.telefone == null || contato.telefone!.isEmpty) {
      _mostrarErro('Telefone não disponível');
      return;
    }

    final telefone = contato.telefone!.replaceAll(RegExp(r'[^\d]'), '');
    final url = 'tel:$telefone';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _mostrarErro('Não foi possível fazer a ligação');
    }
  }

  Future<void> _abrirWhatsApp(Contato contato) async {
    if (contato.telefone == null || contato.telefone!.isEmpty) {
      _mostrarErro('Telefone não disponível');
      return;
    }

    final telefone = contato.telefone!.replaceAll(RegExp(r'[^\d]'), '');
    final url = 'https://wa.me/55$telefone';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _mostrarErro('Não foi possível abrir o WhatsApp');
    }
  }

  void _compartilharContato(Contato contato) {
    String texto = '${contato.nome}';
    if (contato.telefone != null && contato.telefone!.isNotEmpty) {
      texto += '\nTelefone: ${contato.telefone}';
    }

    Share.share(texto, subject: 'Contato: ${contato.nome}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APP_TITLE'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _mostrarDialogOrdenacao,
            tooltip: 'APP_TXT_ORDEM_LABEL'.tr(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar contatos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _aplicarFiltros();
                });
              },
            ),
          ),

          // Lista de contatos
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _contatosFiltrados.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                      onRefresh: _carregarContatos,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _contatosFiltrados.length,
                        itemBuilder: (context, index) {
                          final contato = _contatosFiltrados[index];
                          return ContatoCard(
                            contato: contato,
                            onEdit: () => _editarContato(contato),
                            onDelete: () => _excluirContato(contato),
                            onCall: () => _ligarParaContato(contato),
                            onWhatsApp: () => _abrirWhatsApp(contato),
                            onShare: () => _compartilharContato(contato),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContatoFormScreen()),
          );

          if (resultado == true) {
            _carregarContatos();
          }
        },
        backgroundColor: const Color.fromARGB(255, 44, 59, 47),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'APP_SEM_DADOS_CONTATOS'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
