import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';

final Logger logger = Logger('GetIdService');

class EnregistrerDetails {
  String? _technicienId;
  Dio dio = Dio();

  Future<bool> uploadImage(
      File image, String trappeNumber, String suffix) async {
    String filename = "$trappeNumber-$suffix.jpg";
    String url = 'http://192.168.1.4:5000/api/techniciens/upload_AvInt';
    if (_technicienId != null) {
      print('TechnicienId  est non  null');
      return true;
    }
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: filename),
      });
      Response response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        print('image Upload successful');
        return true;
      } else {
        print('Image upload failes ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return true;
  }

  Future<bool> uploadImage_1(
      File image, String trappeNumber, String suffix) async {
    String filename = "$trappeNumber-$suffix.jpg";
    String url = 'http://192.168.1.4:5000/api/techniciens/upload_ApInt';
    if (_technicienId != null) {
      print('TechnicienId  est non  null');
      return true;
    }
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: filename),
      });
      Response response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        print('image Upload successful');
        return true;
      } else {
        print('Image upload failes ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return true;
  } // Variable de classe

  Future<String?> getIdByLogin(String login) async {
    final String apiUrl =
        'http://192.168.1.4:5000/api/techniciens/login/$login';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('Réponse de la requête GET pour login $login: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String technicienId = data['technicienId'];
        print('ID du technicien trouvé pour login $login: $technicienId');
        return technicienId;
      } else {
        print('Erreur lors de la récupération de l\'ID pour login $login');
      }
    } catch (error) {
      print(
          'Erreur de connexion lors de la récupération de l\'ID pour login $login: $error');
    }

    return null;
  }

  Future<bool> enregistrer(
      String motifInt, String numerotrappe, String address) async {
    if (_technicienId == null) {
      // Gérer le cas où technicienId n'est pas disponible
      print('TechnicienId not available');
      return false;
    }

    try {
      final response = await http.put(
          Uri.parse(
              'http://192.168.1.4:5000/api/techniciens/$_technicienId/details'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
            {
              'motifIntervention': motifInt,
              'numeroTrappe': numerotrappe,
              'address': address,
            },
          ));

      print(
          'Réponse de la requête PUT pour enregistrement des détails: ${response.body}');

      if (response.statusCode == 200) {
        print('Enregistrement réussi: true');
        return true;
      } else {
        print('Enregistrement réussi: false');
        return false;
      }
    } catch (error) {
      print('Erreur lors de l\'enregistrement des détails: $error');
      return false;
    }
  }

  // Setter pour mettre à jour la variable _technicienId
  void setTechnicienId(String? technicienId) {
    _technicienId = technicienId;
  }
}
