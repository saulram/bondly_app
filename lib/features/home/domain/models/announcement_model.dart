// To parse this JSON data, do
//
//     final announcements = announcementsFromJson(jsonString);

import 'dart:convert';

Announcements announcementsFromJson(String str) =>
    Announcements.fromJson(json.decode(str));

String announcementsToJson(Announcements data) => json.encode(data.toJson());

class Announcements {
  List<Announcement>? announcement;

  Announcements({
    this.announcement,
  });

  Announcements copyWith({
    List<Announcement>? announcement,
  }) =>
      Announcements(
        announcement: announcement ?? this.announcement,
      );

  factory Announcements.fromJson(Map<String, dynamic> json) => Announcements(
        announcement: json["data"] == null
            ? []
            : List<Announcement>.from(
                json["data"]!.map((x) => Announcement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "announcement": announcement == null
            ? []
            : List<dynamic>.from(announcement!.map((x) => x.toJson())),
      };
}

class Announcement {
  String? id;
  String? title;
  String? content;
  DateTime? createdAt;

  Announcement({
    this.id,
    this.title,
    this.content,
    this.createdAt,
  });

  Announcement copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
  }) =>
      Announcement(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        id: json["_id"],
        title: json["title"],
        content: json["content"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "createdAt": createdAt?.toIso8601String(),
      };
}
