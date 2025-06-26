import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  // Selecionar imagem da galeria
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
      return null;
    }
  }

  // Selecionar imagem da câmera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao capturar imagem: $e');
      return null;
    }
  }

  // Recortar imagem
  static Future<File?> cropImage(File imageFile) async {
    // Desabilitar cropper na web
    if (kIsWeb) {
      debugPrint('Image cropper não suportado na web');
      return imageFile;
    }

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar Imagem',
            toolbarColor: const Color(0xFFBC764A),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Recortar Imagem'),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao recortar imagem: $e');
      return null;
    }
  }

  // Salvar imagem na galeria (funcionalidade desabilitada)
  static Future<bool> saveImageToGallery(File imageFile) async {
    // Funcionalidade desabilitada para compatibilidade com ambientes modernos
    debugPrint('Funcionalidade de salvar na galeria desabilitada');
    return false;
  }

  // Salvar imagem localmente
  static Future<File?> saveImageLocally(File imageFile, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final savedFile = File('${directory.path}/$fileName');

      await savedFile.writeAsBytes(await imageFile.readAsBytes());
      return savedFile;
    } catch (e) {
      debugPrint('Erro ao salvar imagem localmente: $e');
      return null;
    }
  }

  // Obter imagem de perfil padrão
  static String getDefaultProfileImage() {
    return 'assets/person.png';
  }

  // Validar se o arquivo é uma imagem válida
  static bool isValidImageFile(File file) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
    final extension = file.path.toLowerCase().split('.').last;
    return validExtensions.contains('.$extension');
  }

  // Obter tamanho do arquivo em MB
  static double getFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  // Verificar se o arquivo é muito grande (mais de 10MB)
  static bool isFileTooLarge(File file) {
    return getFileSizeInMB(file) > 10;
  }
}
