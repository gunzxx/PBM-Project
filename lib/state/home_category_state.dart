import 'dart:convert';

import 'package:http/http.dart' as http show get;
import 'package:flutter/material.dart';
import '../model/home_category_model.dart';

class HomeCategoryState extends ChangeNotifier {
  Future<List<HomeCategoryModel>>? _dataFuture;
  final String _url = "https://paa.gunzxx.my.id/api/category";

  Future<List<HomeCategoryModel>> getData() {
    _dataFuture ??= _fetchData();
    return _dataFuture!;
  }

  clearData() {
    _dataFuture = null;
  }

  Future<List<HomeCategoryModel>> refreshData() {
    _dataFuture = null;
    return _fetchData();
  }

  Future<List<HomeCategoryModel>> _fetchData() async {
    try {
      final response =
          await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final List responseData = await jsonDecode(response.body)['data'];
        List<HomeCategoryModel> datas = [];

        for (var i = 0; i < responseData.length; i++) {
          final HomeCategoryModel data = HomeCategoryModel(
            id: await responseData[i]['id'],
            name: await responseData[i]['name'],
          );
          datas.add(data);
        }

        return datas;
      } else {
        return Future.error("Gagal mengambil data.");
      }
    } catch (_) {
      return Future.error("Terjadi kesalahan.");
    }
  }
}
