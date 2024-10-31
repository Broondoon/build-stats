import 'dart:convert';
import 'dart:core';
import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:http/http.dart';
import 'package:shared/entity.dart';
import 'package:http/http.dart' as http;

abstract class DataConnectionService<T extends Entity> {
  Future<String> get(String path);
  Future<String> post(String path, T value);
  Future<String> put(String path, T value);
  Future<void> delete(String path, List<String> key);
}

class DataConnection<T extends Entity> implements DataConnectionService<T> {
  @override
  Future<String> get(String path) async {
    try {
      Response response = await http.get(Uri.parse(path));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw HttpException(response.statusCode, response.body);
      }
    } catch (e) {
      throw HttpException(503, "Service Unavailable");
    }
  }

  @override
  Future<String> post(String path, T value) async {
    try {
      Response response =
          await http.post(Uri.parse(path), body: value.toJson());
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw HttpException(response.statusCode, response.body);
      }
    } catch (e) {
      throw HttpException(503, "Service Unavailable");
    }
  }

  @override
  Future<String> put(String path, T value) async {
    try {
      Response response = await http.put(Uri.parse(path), body: value.toJson());
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw HttpException(response.statusCode, response.body);
      }
    } catch (e) {
      throw HttpException(503, "Service Unavailable");
    }
  }

  @override
  Future<void> delete(String path, List<String> keys) async {
    try {
      Response response =
          await http.delete(Uri.parse(path), body: jsonEncode(keys));
      if (response.statusCode == 200) {
        return;
      } else {
        throw HttpException(response.statusCode, response.body);
      }
    } catch (e) {
      throw HttpException(503, "Service Unavailable");
    }
  }
}
