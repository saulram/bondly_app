// To parse this JSON data, do
//
//     final companyBanners = companyBannersFromJson(jsonString);

import 'dart:convert';

CompanyBanners companyBannersFromJson(String str) =>
    CompanyBanners.fromJson(json.decode(str));

String companyBannersToJson(CompanyBanners data) => json.encode(data.toJson());

class CompanyBanners {
  bool? success;
  List<Banner>? banners;

  CompanyBanners({
    this.success,
    this.banners,
  });

  factory CompanyBanners.fromJson(Map<String, dynamic> json) => CompanyBanners(
        success: json["success"],
        banners: json["data"] == null
            ? []
            : List<Banner>.from(json["data"]!.map((x) => Banner.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "banners": banners == null
            ? []
            : List<dynamic>.from(banners!.map((x) => x.toJson())),
      };
}

class Banner {
  String? id;
  String? name;
  String? slug;
  String? image;
  String? description;
  bool? isActive;
  String? companyName;
  DateTime? createdAt;
  int? v;

  Banner({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.description,
    this.isActive,
    this.companyName,
    this.createdAt,
    this.v,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        id: json["_id"],
        name: json["name"],
        slug: json["slug"],
        image: json["image"],
        description: json["description"],
        isActive: json["isActive"],
        companyName: json["companyName"],
        createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ''),
        v: json["__v"],
      );

  factory Banner.fromSupabase(Map<String, dynamic> json) => Banner(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        image: json["image"],
        description: json["description"],
        isActive: json["is_active"],
        companyName: json["company_name"],
        createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "slug": slug,
        "image": image,
        "description": description,
        "isActive": isActive,
        "companyName": companyName,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
      };
}
