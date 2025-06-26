import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:brasil_fields/brasil_fields.dart';
import '../models/contato.dart';
import '../services/api_service.dart';
import '../utils/image_utils.dart';
import '../utils/validation_utils.dart';

class ContatoFormScreen extends StatefulWidget {
  final Contato? contato;

  const ContatoFormScreen({super.key, this.contato});

  @override
  State<ContatoFormScreen> createState() => _ContatoFormScreenState();
}

class _ContatoFormScreenState extends State<ContatoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _diaController = TextEditingController();
  final _mesController = TextEditingController();

  final ApiService _apiService = ApiService();
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _apiService.initialize();
    _loadContatoData();

    // Adicionar listeners para detectar mudanças
    _nomeController.addListener(_onFieldChanged);
    _telefoneController.addListener(_onFieldChanged);
    _diaController.addListener(_onFieldChanged);
    _mesController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _diaController.dispose();
    _mesController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  void _loadContatoData() {
    if (widget.contato != null) {
      _nomeController.text = widget.contato!.nome;
      _telefoneController.text = widget.contato!.telefone ?? '';
      _diaController.text = widget.contato!.diaNascimento?.toString() ?? '';
      _mesController.text = widget.contato!.mesNascimento?.toString() ?? '';
      _uploadedImageUrl = widget.contato!.fotoUrl;
      setState(() {
        _hasChanges = false;
      });
    }
  }

  Future<void> _selectImage() async {
    final image = await ImageUtils.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _hasChanges = true;
      });
    }
  }

  Future<void> _cropImage() async {
    if (_selectedImage != null) {
      final croppedImage = await ImageUtils.cropImage(_selectedImage!);
      if (croppedImage != null) {
        setState(() {
          _selectedImage = croppedImage;
        });
      }
    }
  }

  Future<void> _saveContato() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImage == null && _uploadedImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('APP_MSG_VALID_FOTO'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? fotoUrl = _uploadedImageUrl;

      // Upload da nova imagem se selecionada
      if (_selectedImage != null) {
        fotoUrl = await _apiService.uploadImage(_selectedImage!);
      }

      final contato = Contato(
        objectId: widget.contato?.objectId,
        nome: _nomeController.text.trim(),
        telefone:
            _telefoneController.text.trim().isEmpty
                ? null
                : _telefoneController.text.trim(),
        diaNascimento:
            _diaController.text.isEmpty ? null : int.parse(_diaController.text),
        mesNascimento:
            _mesController.text.isEmpty ? null : int.parse(_mesController.text),
        fotoUrl: fotoUrl,
      );

      if (widget.contato == null) {
        // Criar novo contato
        await _apiService.createContato(contato);
      } else {
        // Atualizar contato existente
        await _apiService.updateContato(contato);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.contato == null
                  ? 'Contato criado com sucesso!'
                  : 'Contato atualizado com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar contato: $e'),
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
    return PopScope(
      canPop: !_hasChanges,
      onPopInvoked: (didPop) async {
        if (_hasChanges && !didPop) {
          final result = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('APP_ALERT_TITULO_PENDENTE'.tr()),
                  content: Text('APP_ALERT_MENSAGEM_PENDENTE'.tr()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('APP_ALERT_BOTAO_CANCELAR'.tr()),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
          );

          if (result == true && mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.contato == null
                ? 'API_TITULO_FORM_CONTATO'.tr()
                : 'Editar Contato',
          ),
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
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Seção da foto
                _buildPhotoSection(),
                const SizedBox(height: 24.0),

                // Campo nome
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'APP_TXT_NOME'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: ValidationUtils.validateNome,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16.0),

                // Campo telefone
                TextFormField(
                  controller: _telefoneController,
                  decoration: InputDecoration(
                    labelText: 'APP_TXT_TELEFONE'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  // TODO: verificar a mascara [TelefoneInputFormatter()]
                  inputFormatters: [],
                  validator: ValidationUtils.validateTelefone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16.0),

                // Campos de data de nascimento
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _diaController,
                        decoration: InputDecoration(
                          labelText: 'APP_TXT_DIA_NASCIMENTO'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        validator: ValidationUtils.validateDiaNascimento,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _mesController,
                        decoration: InputDecoration(
                          labelText: 'APP_TXT_MES_NASCIMENTO'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          prefixIcon: const Icon(Icons.calendar_month),
                        ),
                        validator: ValidationUtils.validateMesNascimento,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),

                // Botão salvar
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveContato,
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
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      children: [
        // Foto atual/selecionada
        GestureDetector(
          onTap: _selectImage,
          child: Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 44, 59, 47),
                width: 3.0,
              ),
            ),
            child: ClipOval(
              child:
                  _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : _uploadedImageUrl != null
                      ? Image.network(
                        _uploadedImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/person.png',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                      : Image.asset('assets/person.png', fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 16.0),

        // Botões de ação da foto
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _selectImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Selecionar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 44, 59, 47),
                foregroundColor: Colors.white,
              ),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(width: 8.0),
              ElevatedButton.icon(
                onPressed: _cropImage,
                icon: const Icon(Icons.crop),
                label: const Text('Recortar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
