// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

Categories categoriesFromJson(String str) =>
    Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
  List<Category>? categories;

  Categories({
    this.categories,
  });

  Categories copyWith({
    List<Category>? categories,
  }) =>
      Categories(
        categories: categories ?? this.categories,
      );

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        categories: json["data"] == null
            ? []
            : List<Category>.from(
                json["data"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class Category {
  String? id;
  String? name;
  int? account;
  String? description;
  String? imageUrl;
  String? type;
  bool? visible;

  Category({
    this.id,
    this.name,
    this.account,
    this.description,
    this.imageUrl,
    this.type,
    this.visible,
  });

  Category copyWith({
    String? id,
    String? name,
    int? account,
    String? description,
    String? imageUrl,
    String? type,
    bool? visible,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        account: account ?? this.account,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        type: type ?? this.type,
        visible: visible ?? this.visible,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        account: json["account"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        type: json["type"],
        visible: json["visible"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "account": account,
        "description": description,
        "imageUrl": imageUrl,
        "type": type,
        "visible": visible,
      };
}
