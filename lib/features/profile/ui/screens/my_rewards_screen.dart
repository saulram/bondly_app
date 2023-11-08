import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/widgets/full_screen_image.dart';
import 'package:bondly_app/features/home/ui/widgets/gold_bordered_container.dart';
import 'package:bondly_app/features/profile/domain/models/cart_model.dart';
import 'package:bondly_app/features/profile/ui/screens/shopping_cart_screen.dart';
import 'package:bondly_app/features/profile/ui/viewmodels/my_rewards_viewmodel.dart';
import 'package:bondly_app/ui/shared/app_sliver_layout.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyRewardsScreen extends StatefulWidget {
  static const String route = "/myRewardsScreen";

  const MyRewardsScreen({super.key});

  @override
  State<MyRewardsScreen> createState() => _MyRewardsScreenState();
}

class _MyRewardsScreenState extends State<MyRewardsScreen> {
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
            title: "Recompensas",
            floatingActionButton: FloatingActionButton(
              isExtended: true,
              onPressed: () async {
                if (rewardsModel.cartItems.isEmpty) {
                  context.push(MyCartScreen.route);
                  return;
                } else {
                  rewardsModel.sendItemsToCart().then((cartUpdated) {
                    context.push(MyCartScreen.route);
                  });
                }
              },
              tooltip: "Carrito",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(IconsaxOutline.shopping_cart),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${rewardsModel.cartItems.length}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: rewardsModel.rewardList.rewards!.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : ListView.builder(
                      itemCount: rewardsModel.rewardList.rewards?.length,
                      itemBuilder: (context, index) {
                        Reward reward = rewardsModel.rewardList.rewards![index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: GoldBorderedContainer(
                            child: Column(
                              children: [
                                RewardCardHeader(
                                  reward: reward,
                                  size: size,
                                  rewardsModel: rewardsModel,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RewardCardImage(reward: reward),
                                const SizedBox(
                                  height: 10,
                                ),
                                RewardCardTitleSection(reward: reward),
                                const Divider(),
                                RewardDescriptionCardSection(reward: reward),
                                const Divider(),
                                RewardFooterCardSection(reward: reward),
                              ],
                            ),
                          ),
                        );
                      }),
            ));
      }),
    );
  }
}

class RewardDescriptionCardSection extends StatelessWidget {
  const RewardDescriptionCardSection({
    super.key,
    required this.reward,
  });

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        reward.description!,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class RewardFooterCardSection extends StatelessWidget {
  const RewardFooterCardSection({
    super.key,
    required this.reward,
  });

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Vigencia",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "${reward.deadline!.day}/${reward.deadline!.month}/${reward.deadline!.year}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class RewardCardTitleSection extends StatelessWidget {
  const RewardCardTitleSection({
    super.key,
    required this.reward,
  });

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          reward.name!,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          width: 10,
        ),
        Icon(
          IconsaxOutline.heart,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "${reward.likes!.length}",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class RewardCardImage extends StatelessWidget {
  const RewardCardImage({
    super.key,
    required this.reward,
  });

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImage(
              image: reward.image!,
              tag: reward.id!,
            ),
          ),
        );
      },
      child: Hero(
        tag: reward.id!,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(reward.imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RewardCardHeader extends StatelessWidget {
  const RewardCardHeader({
    super.key,
    required this.reward,
    required this.size,
    required this.rewardsModel,
  });

  final Reward reward;
  final Size size;
  final MyRewardsViewModel rewardsModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
            reward.enable == false
                ? IconsaxOutline.lock
                : IconsaxOutline.unlock,
            color: Theme.of(context).iconTheme.color),
        SizedBox(width: size.width * .4),
        //To be fixed, if item exist in cart, show the quantity and a + and - button to add or remove.
        //If not, show a button to add to cart.
        rewardsModel.getItemCount(reward.id!) == 0
            ? OutlinedButton(
                onPressed: () {
                  rewardsModel.addToCart(reward.id!);
                },
                child: Text("Seleccionar"),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      rewardsModel.removeFromCart(reward.id!);
                    },
                    icon: const Icon(IconsaxOutline.minus),
                  ),
                  Text(
                    '${rewardsModel.getItemCount(reward.id!)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      rewardsModel.addToCart(reward.id!);
                    },
                    icon: Icon(IconsaxOutline.add),
                  ),
                ],
              )
      ],
    );
  }
}
