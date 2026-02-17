import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/features/profile/domain/models/bondly_badges_model.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum BadgeType { embassys, myBadges, categories }

class BadgesGrid extends StatefulWidget {
  final Embassys? embassys;
  final MyBadges? myBadges;
  final List<BondlyCategory>? categories;
  final BadgeType type;

  const BadgesGrid({
    super.key,
    required this.size,
    this.embassys,
    this.myBadges,
    this.categories,
    required this.type,
  });

  final Size size;

  @override
  State<BadgesGrid> createState() => _BadgesGridState();
}

class _BadgesGridState extends State<BadgesGrid> {
  late Embassys? embassys;
  late MyBadges? myBadges;
  late List<BondlyCategory>? categories;
  late Size size;
  final List<Color> bondlyColors = [
    AppColors.primaryColor,
    AppColors.secondaryColor,
    AppColors.tertiaryColor,
    AppColors.primaryColorLight,
    AppColors.secondaryColorLight,
    AppColors.tertiaryColorLight,
  ];

  @override
  void initState() {
    embassys = widget.embassys;
    size = widget.size;
    myBadges = widget.myBadges;
    categories = widget.categories;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: widget.type == BadgeType.categories
          ? _buildGrid(categories!)
          : GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount:
                  embassys?.count ?? myBadges?.count ?? categories?.length ?? 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                if (widget.type == BadgeType.embassys) {
                  final embassy = embassys?.embassys[index];
                  return _buildBadge(
                      badge: embassy?.badgeId, quantity: embassy?.quantity);
                } else if (widget.type == BadgeType.myBadges) {
                  final myBadge = myBadges?.myBadges[index];
                  return _buildBadge(
                      badge: myBadge?.badgeId, quantity: myBadge?.quantity);
                }
                return null;
              },
            ),
    );
  }

  Widget _buildBadge({BondlyBadge? badge, int? quantity}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: safeImageUrl(badge?.image),
          height: 50,
          width: 50,
        ),
        Text(
          badge!.name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        quantity != 0
            ? Text(
                "$quantity",
                style: Theme.of(context).textTheme.labelSmall,
              )
            : Container(),
      ],
    );
  }

  Widget _buildGrid(List<BondlyCategory> bondlyCategories) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
      itemCount: bondlyCategories.length,
      itemBuilder: (context, i) {
        final color = bondlyColors[i % bondlyColors.length];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: color,
                ),
                child: Text(bondlyCategories[i].name,
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.backgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ))),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bondlyCategories[i].categoryBadges.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final badge = bondlyCategories[i].categoryBadges[index];
                return _buildBadge(badge: badge, quantity: 0);
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
