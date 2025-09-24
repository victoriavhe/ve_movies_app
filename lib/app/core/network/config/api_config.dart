import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final String bearerToken = dotenv.env['API_BEARER_TOKEN'] ?? '';
}
