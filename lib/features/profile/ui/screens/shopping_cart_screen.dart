import 'package:bondly_app/config/strings_cart.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/my_rewards_viewmodel.dart';
import 'package:bondly_app/ui/shared/app_sliver_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ficonsax/ficonsax.dart';
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
  bool busy = false;

  @override
  void initState() {
    model = getIt<MyRewardsViewModel>();
    super.initState();
  }

  Future<void> showConfirmationModal(
      BuildContext context, int itemCount, MyRewardsViewModel model) async {
    final result = await showAdaptiveDialog<String>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text(StringsCart.importantTitle),
        content: Text(
          StringsCart.confirmationMessageBody(
            itemCount.toString(),
            model.userCart.total.toString(),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              style: Theme.of(context).filledButtonTheme.style?.copyWith(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).disabledColor,
                    ),
                  ),
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              style: Theme.of(context).filledButtonTheme.style?.copyWith(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
              onPressed: () async {
                final result = await model.checkOutCart();
                if (result) {
                  model.cartEdited = false;
                  model.handleResetAll();
                  context.go("/homeScreen");

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(StringsCart.hhrr),
                    ),
                  );
                } else {
                  Navigator.pop(context, StringsCart.cancel);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(StringsCart.notEnoughPoints),
                    ),
                  );
                }
              },
              child: busy
                  ? CircularProgressIndicator.adaptive()
                  : const Text(StringsCart.confirm),
            ),
          ),
        ],
      ),
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
            title: "Cart",
            floatingActionButton: FloatingActionButton.extended(
              isExtended: true,
              onPressed: () {
                showConfirmationModal(context,
                    rewardsModel.userCart.rewards.length, rewardsModel);
              },
              tooltip: "Cart",
              icon: const Icon(IconsaxOutline.money),
              label: const Text(StringsCart.confirm),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              height: size.height * .6,
              child: rewardsModel.userCart.rewards.isEmpty
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Thumbnail"),
                                    const Text("Nombre"),
                                    SizedBox(
                                      width: 100,
                                      child: const Text("Cantidad"),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              CartItemTile(
                                item: rewardsModel.userCart.rewards[index],
                                model: rewardsModel,
                              ),
                            ],
                          );
                        } else if (index ==
                            rewardsModel.userCart.rewards.length - 1) {
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              CartItemTile(
                                item: rewardsModel.userCart.rewards[index],
                                model: rewardsModel,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total"),
                                    Text("${rewardsModel.userCart.total} pts"),
                                  ],
                                ),
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
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: CachedNetworkImageProvider(item.reward.imageUrl ?? ''),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        item.reward.name,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(
        " ${item.reward.points} points",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: SizedBox(
        width: 70,
        child: Row(
          children: [
            GestureDetector(
              child: const Icon(IconsaxOutline.minus),
              onTap: () {
                model.pullItem(item.reward.id);
              },
            ),
            const SizedBox(width: 15, height: 15),
            Text(
              "${item.quantity}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            GestureDetector(
              child: const Icon(IconsaxOutline.add),
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
