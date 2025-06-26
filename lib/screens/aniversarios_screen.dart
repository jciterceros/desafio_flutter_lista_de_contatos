import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../models/contato.dart';
import '../services/api_service.dart';
import '../widgets/contato_card.dart';

class AniversariosScreen extends StatefulWidget {
  const AniversariosScreen({super.key});

  @override
  State<AniversariosScreen> createState() => _AniversariosScreenState();
}

class _AniversariosScreenState extends State<AniversariosScreen> {
  final ApiService _apiService = ApiService();
  List<Contato> _aniversariantes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _apiService.initialize();
    _carregarAniversariantes();
  }

  Future<void> _carregarAniversariantes() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final contatos = await _apiService.getContatos();
      final hoje = DateTime.now();

      final aniversariantes =
          contatos.where((contato) {
            return contato.diaNascimento == hoje.day &&
                contato.mesNascimento == hoje.month;
          }).toList();

      setState(() {
        _aniversariantes = aniversariantes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _mostrarErro('Erro ao carregar aniversariantes: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('APP_ICO_ANIV'.tr())),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _aniversariantes.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                onRefresh: _carregarAniversariantes,
                child: Column(
                  children: [
                    // Header com mensagem de parabéns
                    _buildHeader(),

                    // Lista de aniversariantes
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _aniversariantes.length,
                        itemBuilder: (context, index) {
                          final contato = _aniversariantes[index];
                          return ContatoCard(
                            contato: contato,
                            onEdit: () {
                              // Navegar para edição
                            },
                            onDelete: () {
                              // Excluir contato
                            },
                            onCall: () {
                              // Ligar para contato
                            },
                            onWhatsApp: () {
                              // Abrir WhatsApp
                            },
                            onShare: () {
                              // Compartilhar contato
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color.fromARGB(255, 44, 59, 47),
            Color.fromARGB(255, 44, 59, 47),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.cake, size: 48, color: Colors.white),
          const SizedBox(height: 16),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'APP_TXT_FELIZ_ANIVER'.tr(),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 1,
          ),
          const SizedBox(height: 8),
          Text(
            '${_aniversariantes.length} ${_aniversariantes.length == 1 ? 'contato' : 'contatos'} faz${_aniversariantes.length == 1 ? '' : 'em'} aniversário hoje!',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cake_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'APP_TXT_SEM_DADOS_ANIVER'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _carregarAniversariantes,
            icon: const Icon(Icons.refresh),
            label: const Text('Atualizar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 44, 59, 47),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
