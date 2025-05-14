import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {

  static initEnv() async => dotenv.load(fileName: '.env');
  static String apiUrl = dotenv.env['API_URL'] ?? 'No configure the API_URL';
}