import 'dart:convert';
import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared/entity.dart';

abstract class DataConnectionService<T extends Entity> {
  Future<String> get(String path);
  Future<String> post(String path, T value);
  Future<String> put(String path, T value);
  Future<void> delete(String path, List<String> keys);
}

class DataConnection<T extends Entity> implements DataConnectionService<T> {
  final http.Client client;

  DataConnection({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<String> get(String path) async {
    try {
      print("GET: " + path);
      http.Response response = await client.get(Uri.parse(path));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw HttpException(response.statusCode, response.body);
      }
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(503, "Service Unavailable");
    }
  }

  @override
  Future<String> post(String path, T value) async {
    try {
      print("POST: " + path);
      http.Response response =
          await client.post(Uri.parse(path), body: jsonEncode(value.toJsonTransfer()));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw HttpException(response.statusCode, response.body);
      }
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(503, "Service Unavailable");
    }
  }

  @override
  Future<String> put(String path, T value) async {
    try {
      print("PUT: " + path);
      http.Response response =
          await client.put(Uri.parse(path), body: jsonEncode(value.toJsonTransfer()));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw HttpException(response.statusCode, response.body);
      }
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(503, "Service Unavailable");
    }
  }

  @override
  Future<void> delete(String path, List<String> keys) async {
    try {
      print("DELETE: " + path);
      http.Response response =
          await client.delete(Uri.parse(path), body: jsonEncode(keys));
      if (response.statusCode == 200) {
        return;
      } else {
        throw HttpException(response.statusCode, response.body);
      }
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(503, "Service Unavailable");
    }
  }
}
