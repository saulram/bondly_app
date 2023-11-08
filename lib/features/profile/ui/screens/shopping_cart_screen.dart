import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/my_rewards_viewmodel.dart';
import 'package:bondly_app/ui/shared/app_sliver_layout.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModelProvider<MyRewardsViewModel>(
      model: model,
      child: ModelBuilder<MyRewardsViewModel>(
          builder: (context, rewardsModel, child) {
        return BondlySliverLayout(
          title: "Carrito",
          floatingActionButton: FloatingActionButton.extended(
            isExtended: true,
            onPressed: () {},
            tooltip: "Carrito",
            icon: Icon(IconsaxOutline.money),
            label: Text(
              "Confirmar",
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            height: size.height * .6,
            child: ListView.builder(
              itemCount: rewardsModel.userCart.rewards.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Thumbnail"),
                            Text("Nombre"),
                            SizedBox(width: 100, child: Text("Cantidad")),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CartItemTile(
                        item: rewardsModel.userCart.rewards[index],
                        model: rewardsModel,
                      ),
                    ],
                  );
                } else if (index == rewardsModel.userCart.rewards.length - 1) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      CartItemTile(
                        item: rewardsModel.userCart.rewards[index],
                        model: rewardsModel,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      }),
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
            image: NetworkImage(item.reward.imageUrl ?? ''),
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
              child: Icon(IconsaxOutline.minus),
              onTap: () {
                model.pullItem(item.reward.id);
              },
            ),
            SizedBox(
              width: 15,
              child: model.updatingCart == false
                  ? Text(
                      "${item.quantity}",
                      textAlign: TextAlign.center,
                    )
                  : CircularProgressIndicator.adaptive(),
            ),
            GestureDetector(
              child: Icon(IconsaxOutline.add),
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
