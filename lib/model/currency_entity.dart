import 'dart:convert';
import 'package:ffzwmxy/server/api.dart';
import 'package:dio/dio.dart';
import 'package:ffzwmxy/http/httpUtils.dart';
List<List<dynamic>> currencyEntityFromJson(String str) => List<List<dynamic>>.from(json.decode(str).map((x) => List<dynamic>.from(x.map((x) => x))));

String currencyEntityToJson(List<List<dynamic>> data) => json.encode(List<dynamic>.from(data.map((x) => List<dynamic>.from(x.map((x) => x)))));

class CurrencyEntity {
  static Future<String> polling(
      Map<String, dynamic> map) async {
    try {
      final response = await HttpUtils.post(API.CURRENCY_URL, data: map);
      return response;
    } on DioError catch (e) {
      return e.error;
    }
  }
}