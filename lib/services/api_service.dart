import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../config/env_config.dart';
import '../models/contato.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  final String _baseUrl = EnvConfig.back4appServerUrl;
  final String _applicationId = EnvConfig.back4appApplicationId;
  final String _restApiKey = EnvConfig.back4appRestApiKey;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'X-Parse-Application-Id': _applicationId,
          'X-Parse-REST-API-Key': _restApiKey,
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  // Buscar todos os contatos
  Future<List<Contato>> getContatos() async {
    try {
      final response = await _dio.get('/classes/Contatos');

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => Contato.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar contatos');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  // Criar novo contato
  Future<Contato> createContato(Contato contato) async {
    try {
      final response = await _dio.post(
        '/classes/Contatos',
        data: contato.toJson(),
      );

      if (response.statusCode == 201) {
        return Contato.fromJson(response.data);
      } else {
        throw Exception('Falha ao criar contato');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  // Atualizar contato
  Future<Contato> updateContato(Contato contato) async {
    try {
      final response = await _dio.put(
        '/classes/Contatos/${contato.objectId}',
        data: contato.toJson(),
      );

      if (response.statusCode == 200) {
        return Contato.fromJson(response.data);
      } else {
        throw Exception('Falha ao atualizar contato');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  // Deletar contato
  Future<void> deleteContato(String objectId) async {
    try {
      final response = await _dio.delete('/classes/Contatos/$objectId');

      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar contato');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  // Upload de imagem
  Future<String> uploadImage(File imageFile) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/files/$fileName',
        data: formData,
        options: Options(
          headers: {
            'X-Parse-Application-Id': _applicationId,
            'X-Parse-REST-API-Key': _restApiKey,
          },
        ),
      );

      if (response.statusCode == 201) {
        return response.data['url'];
      } else {
        throw Exception('Falha no upload da imagem');
      }
    } catch (e) {
      throw Exception('Erro no upload: $e');
    }
  }

  // Salvar imagem localmente
  Future<File> saveImageLocally(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final savedFile = File('${directory.path}/$fileName');

      await savedFile.writeAsBytes(await imageFile.readAsBytes());
      return savedFile;
    } catch (e) {
      throw Exception('Erro ao salvar imagem: $e');
    }
  }
}
