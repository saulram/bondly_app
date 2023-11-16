// To parse this JSON data, do
//
//     final accountStatement = accountStatementFromJson(jsonString);

import 'dart:convert';

AccountStatement accountStatementFromJson(String str) =>
    AccountStatement.fromJson(json.decode(str));

String accountStatementToJson(AccountStatement data) =>
    json.encode(data.toJson());

class AccountStatement {
  String? user;
  DateTime? date;
  List<Transaction>? transactions;
  int? balance;
  String? description;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  AccountStatement({
    this.user,
    this.date,
    this.transactions,
    this.balance,
    this.description,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  AccountStatement copyWith({
    String? user,
    DateTime? date,
    List<Transaction>? transactions,
    int? balance,
    String? description,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      AccountStatement(
        user: user ?? this.user,
        date: date ?? this.date,
        transactions: transactions ?? this.transactions,
        balance: balance ?? this.balance,
        description: description ?? this.description,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory AccountStatement.fromJson(Map<String, dynamic> json) =>
      AccountStatement(
        user: json["user"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        transactions: json["transactions"] == null
            ? []
            : List<Transaction>.from(
                json["transactions"]!.map((x) => Transaction.fromJson(x))),
        balance: json["balance"],
        description: json["description"],
        id: json["_id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "date": date?.toIso8601String(),
        "transactions": transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
        "balance": balance,
        "description": description,
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Transaction {
  String? name;
  int? amount;
  String? type;
  DateTime? date;
  String? id;

  Transaction({
    this.name,
    this.amount,
    this.type,
    this.date,
    this.id,
  });

  Transaction copyWith({
    String? name,
    int? amount,
    String? type,
    DateTime? date,
    String? id,
  }) =>
      Transaction(
        name: name ?? this.name,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        date: date ?? this.date,
        id: id ?? this.id,
      );

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        name: json["name"],
        amount: json["amount"],
        type: json["type"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
        "type": type,
        "date": date?.toIso8601String(),
        "_id": id,
      };
}
