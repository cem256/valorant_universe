import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../product/constants/api_constants.dart';

class NetworkManager {
  static final NetworkManager _instace = NetworkManager._init();
  static NetworkManager get instance => _instace;
  NetworkManager._init() {
    dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    if (kDebugMode) dio.interceptors.add(PrettyDioLogger(responseBody: false));
  }

  late final Dio dio;
}
