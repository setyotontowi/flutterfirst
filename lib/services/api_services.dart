import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Connection { undefined, connected, disconnected }

class ApiService {
  static ApiService? _instance;
  final String baseUrl;

  static ValueNotifier<Connection> _connectionNotifier =
      ValueNotifier<Connection>(Connection.undefined);

  ApiService._internal(this.baseUrl) {
    _connectionNotifier.value = Connection.undefined;
  }

  static ApiService getInstance() {
    _instance ??= ApiService._internal('https://reqres.in/');
    return _instance!;
  }

  Connection get connectionStatus => _connectionNotifier.value;

  Future<http.Response> get(String endpoint) => http.get(Uri.parse(baseUrl + endpoint));
}
