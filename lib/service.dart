import 'dart:io';
import 'package:dio/dio.dart';

import './loker_response.dart';
import './model.dart';

class LokerService {
  final String baseUrl;

  LokerService({required this.baseUrl});

  final Dio _dio = Dio();

  Future<List<LokerData>> fetchLoker() async {
    try {
      Response response = await _dio.get('$baseUrl/read.php');
      print(response.data);
      if (response.statusCode == 200) {
        return LokerResponse.fromJson(response.data).data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to load data: $error');
    }
  }

  Future<void> createLoker(LokerData loker) async {
    _dio.options
      ..baseUrl = baseUrl
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.acceptHeader: 'application/json',
      };
    try {
      final response = await _dio.post(
        '/create.php',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'nama': loker.nama,
          'noLoker': loker.noLoker,
          'tanggal': loker.tanggal,
          'idLoker': loker.idLoker,
          'metodePembayaran': loker.metodePembayaran,
          'status': loker.status,
        },
      );
      print(response);
      if (response.statusCode == 200) {
        print('Data created successfully: ${response.data}');
      } else {
        throw Exception('Failed to create data: ${response.statusCode}');
      }
    } catch (error) {
      // throw Exception('Failed to create data: $error');
    }
  }

  Future<void> updateLoker(int lokerID, LokerData loker) async {
    _dio.options
      ..baseUrl = baseUrl
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.acceptHeader: 'application/json',
      };
    try {
      final response = await _dio.post(
        '/update.php',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'id': lokerID,
          'nama': loker.nama,
          'noLoker': loker.noLoker,
          'tanggal': loker.tanggal,
          'idLoker': loker.idLoker,
          'metodePembayaran': loker.metodePembayaran,
          'status': loker.status,
        },
      );
      print(response);
      if (response.statusCode == 200) {
        print('Data updated successfully: ${response.data}');
      } else {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to update data: $error');
    }
  }

  Future<void> deleteLoker(int lokerID) async {
    _dio.options
      ..baseUrl = baseUrl
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.acceptHeader: 'application/json',
      };
    try {
      print(lokerID);

      final response = await _dio.post(
        '/delete.php',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'id': lokerID,
        },
      );
      print(response);
      if (response.statusCode == 200) {
        print('Data deleted...: ${response.data}');
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to delete data: $error');
    }
  }
}
