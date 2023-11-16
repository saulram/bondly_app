import 'package:bondly_app/config/strings_main.dart';

class BondlyBadges {
  final Embassys embassys;
  final MyBadges myBadges;
  final List<BondlyCategory> categories;

  BondlyBadges({
    required this.embassys,
    required this.myBadges,
    required this.categories,
  });

  factory BondlyBadges.fromJson(Map<String, dynamic> json) {
    return BondlyBadges(
      embassys: Embassys.fromJson(json['embassys']),
      myBadges: MyBadges.fromJson(json['myBadges']),
      categories: List<BondlyCategory>.from(
        json['categories'].map((category) => BondlyCategory.fromJson(category)),
      ),
    );
  }
}

class Embassys {
  final int count;
  final List<Embassy> embassys;

  Embassys({
    required this.count,
    required this.embassys,
  });

  factory Embassys.fromJson(Map<String, dynamic> json) {
    return Embassys(
      count: json['count'],
      embassys: List<Embassy>.from(
        json['embassys'].map((embassy) => Embassy.fromJson(embassy)),
      ),
    );
  }
}

class Embassy {
  final BondlyBadge badgeId;
  final int quantity;

  Embassy({
    required this.badgeId,
    required this.quantity,
  });

  factory Embassy.fromJson(Map<String, dynamic> json) {
    return Embassy(
      badgeId: BondlyBadge.fromJson(json['badge_id']),
      quantity: json['quantity'],
    );
  }
}

class MyBadges {
  final int count;
  final List<MyBadge> myBadges;

  MyBadges({
    required this.count,
    required this.myBadges,
  });

  factory MyBadges.fromJson(Map<String, dynamic> json) {
    return MyBadges(
      count: json['count'],
      myBadges: List<MyBadge>.from(
        json['myBadges'].map((myBadge) => MyBadge.fromJson(myBadge)),
      ),
    );
  }
}

class MyBadge {
  final BondlyBadge badgeId;
  final int quantity;

  MyBadge({
    required this.badgeId,
    required this.quantity,
  });

  factory MyBadge.fromJson(Map<String, dynamic> json) {
    return MyBadge(
      badgeId: BondlyBadge.fromJson(json['badge_id']),
      quantity: json['quantity'],
    );
  }
}

class BondlyCategory {
  final String id;
  final String name;
  final int account;
  final String description;
  final String imageUrl;
  final List<BondlyBadge> categoryBadges;

  BondlyCategory({
    required this.id,
    required this.name,
    required this.account,
    required this.description,
    required this.imageUrl,
    required this.categoryBadges,
  });

  factory BondlyCategory.fromJson(Map<String, dynamic> json) {
    return BondlyCategory(
      id: json['_id'],
      name: json['name'],
      account: json['account'],
      description: json['description'],
      imageUrl: json['imageUrl'] != null
          ? "${StringsMain.baseImagesUrl}${json['imageUrl']}"
          : '',
      categoryBadges: List<BondlyBadge>.from(
        json['categoryBadges']['badges']
            .map((badge) => BondlyBadge.fromJson(badge)),
      ),
    );
  }
}

class BondlyBadge {
  final String id;
  final String categoryId;
  final String name;
  final String image;
  final int value;
  final bool isActive;
  final bool visible;

  BondlyBadge({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.image,
    required this.value,
    required this.isActive,
    required this.visible,
  });

  factory BondlyBadge.fromJson(Map<String, dynamic> json) {
    return BondlyBadge(
      id: json['_id'],
      categoryId: json['category_id'],
      name: json['name'],
      image: json['image'] != null
          ? "${StringsMain.baseImagesUrl}${json['image']}"
          : '',
      value: json['value'],
      isActive: json['isActive'],
      visible: json['visible'],
    );
  }
}
