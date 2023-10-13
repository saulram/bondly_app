import 'dart:convert';

import 'package:floor/floor.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    final jsonFile = json.decode(databaseValue);
    Iterable list = jsonFile['value'];
    List<String> stringList = List<String>.from(
      list.map((e) => e.toString())
    );

    return stringList;

  }

  @override
  String encode(List<String> value) {
    final data = <String, dynamic>{};
    data.addAll({'value': value});
    return json.encode(data);
  }
}