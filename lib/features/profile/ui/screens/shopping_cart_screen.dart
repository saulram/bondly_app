import 'package:bondly_app/config/dimensions.dart';
import 'package:bondly_app/config/strings_cart.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/my_rewards_viewmodel.dart';
import 'package:bondly_app/ui/shared/app_sliver_layout.dart';
import 'package:bondly_app/src/network_image_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:bondly_app/ui/shared/bondly_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyCartScreen extends StatefulWidget {
  static const String route = "/userCartScreen";

  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  late MyRewardsViewModel model;

  @override
  void initState() {
    model = getIt<MyRewardsViewModel>();
    super.initState();
  }

  Future<void> showConfirmationModal(
    BuildContext context,
    int itemCount,
    MyRewardsViewModel model,
  ) async {
    Dialog alertDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton.filled(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(LucideIcons.xCircle)),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              StringsCart.importantTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15.0),
            child: confirmationMessageBody(
                itemCount.toString(), model.userCart.total.toString(), context),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 110,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(StringsCart.cancel),
                ),
              ),
              SizedBox(
                width: 110,
                child: OutlinedButton(
                  onPressed: () async {
                    await model.checkOutCart();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).secondaryHeaderColor),
                    textStyle: WidgetStateProperty.all<TextStyle>(
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                    ),
                  ),
                  child: Text(
                    StringsCart.confirm,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  static Text confirmationMessageBody(
      String itemCount, String total, BuildContext context) {
    final TextStyle boldStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            );

    return Text.rich(
      TextSpan(
        text: 'Acabas de seleccionar ',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
        children: <TextSpan>[
          TextSpan(
            text: '$itemCount producto(s)',
            style: boldStyle,
          ),
          TextSpan(
              text: ' para canjear tus puntos.\n\n',
              style: Theme.of(context).textTheme.bodyMedium),
          TextSpan(
            text:
                'Al dar click al botón CONFIRMAR se generará un canje que restará \n',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextSpan(
            text: '$total punto(s) \n',
            style: boldStyle,
          ),
          TextSpan(
            text:
                'de tu estado de cuenta, lo cual es irreversible. ¿Estás seguro de los premios que quieres canjear?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ModelProvider<MyRewardsViewModel>(
      model: model,
      child: ModelBuilder<MyRewardsViewModel>(
        builder: (context, rewardsModel, child) {
          return BondlySliverLayout(
            key: rewardsModel.cartScaffoldKey,
            title: "Cart",
            floatingActionButton: FloatingActionButton.extended(
              isExtended: true,
              onPressed: () {
                showConfirmationModal(context,
                    rewardsModel.userCart.rewards.length, rewardsModel);
              },
              tooltip: "Cart",
              icon: const Icon(LucideIcons.wallet),
              label: const Text(StringsCart.confirm),
            ),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              height: size.height * .6,
              child: rewardsModel.busy
                  ? const Center(
                      child: BondlyShimmerBlock(
                          width: 200, height: 200, borderRadius: 12),
                    )
                  : rewardsModel.userCart.rewards.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(StringsCart.emptyCartMessage),
                              TextButton(
                                child: const Text(StringsCart.goToRewards),
                                onPressed: () => context.pop(),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: rewardsModel.userCart.rewards.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  const CartListHeader(),
                                  const SizedBox(height: 10),
                                  CartItemTile(
                                    item: rewardsModel.userCart.rewards[index],
                                    model: rewardsModel,
                                  ),
                                ],
                              );
                            } else if (index ==
                                rewardsModel.userCart.rewards.length - 2) {
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  CartItemTile(
                                    item: rewardsModel.userCart.rewards[index],
                                    model: rewardsModel,
                                  ),
                                  const SizedBox(height: 10),
                                  CartListFooter(
                                    total: rewardsModel.userCart.total,
                                  ),
                                ],
                              );
                            }
                            return CartItemTile(
                              item: rewardsModel.userCart.rewards[index],
                              model: rewardsModel,
                            );
                          },
                        ),
            ),
          );
        },
      ),
    );
  }
}

class CartListFooter extends StatelessWidget {
  final int total;
  const CartListFooter({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total"),
          Text("$total pts"),
        ],
      ),
    );
  }
}

class CartListHeader extends StatelessWidget {
  const CartListHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Img"),
          Text("Nombre"),
          SizedBox(
            width: 100,
            child: Text("Cantidad"),
          ),
        ],
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final MyRewardsViewModel model;

  const CartItemTile({
    super.key,
    required this.item,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          image: DecorationImage(
            image:
                CachedNetworkImageProvider(safeImageUrl(item.reward.imageUrl)),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        item.reward.name,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(
        " ${item.reward.points} puntos",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: SizedBox(
        width: 70,
        child: Row(
          children: [
            GestureDetector(
              child: const Icon(LucideIcons.minus),
              onTap: () {
                model.pullItem(item.reward.id);
              },
            ),
            const SizedBox(width: 15, height: 15),
            Text(
              item.quantity.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            GestureDetector(
              child: const Icon(LucideIcons.plus),
              onTap: () {
                model.pushItem(item.reward.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
