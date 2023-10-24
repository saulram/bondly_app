import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/single_post_widget.dart';
import 'package:bondly_app/ui/shared/app_body_layout.dart';
import 'package:bondly_app/ui/shared/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/homeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel model;

  @override
  void initState() {
    model = getIt<HomeViewModel>();
    model.setUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModelProvider(
      model: model,
      child: ModelBuilder<HomeViewModel>(
        builder: (context, homeViewModel, child) {
          return ScaffoldLayout(
            body: BodyLayout(
              enableBanners: true,
              child: _buildBody(),
            ),
            enableBottomNavBar: true,
            avatar: model.user?.avatar,
            afterProfileCall: model.setUp,
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return PageView(
      controller: model.pageController,
      onPageChanged: (index) {
        model.onPageChanged(index);
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: model.feeds.data.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            _buildAcknowledgmentsSection(),
                            const SizedBox(height: 10),
                            SinglePostWidget(
                                post: model.feeds.data[index], index: index)
                          ],
                        );
                      }
                      return SinglePostWidget(
                        post: model.feeds.data[index],
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.green,
        ),
        Container(
          color: Colors.yellow,
        ),
      ],
    );
  }

  Container _buildAcknowledgmentsSection() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.tertiaryColorLight),
          color: AppColors.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ]),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            'Tienes ${model.user?.giftedPoints} puntos para reconocer a tus compañeros.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Elige entre los ${model.categories.categories?.length} tipos de insignias y decide que tipo de reconocimiento quieres otorgar',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          _buildCategoriesSection(),
          const Divider(),
          model.selectedCategory == null
              ? const SizedBox()
              : _buildBadgesFromCategorySection(),
          const Divider(),
          model.selectedBadge == null
              ? SizedBox()
              : _buildCreateAcknowledgment()
        ],
      ),
    );
  }

  Row _buildCreateAcknowledgment() {
    return Row(
      children: [
        Container(
          height: 100,
          width: 90,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () {},
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(
                    "https://api.bondly.mx/${model.selectedBadge?.image}",
                  ),
                ),
                Text(
                  "",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                  textAlign: TextAlign.center,
                ),
                Text(
                  model.selectedBadge?.name ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 260,
          child: Column(
            children: [
              FlutterMentions(
                key: model.mentionsKey,
                suggestionPosition: SuggestionPosition.Top,
                maxLines: 5,
                minLines: 1,
                onMentionAdd: (mention) {
                  model.pushCollaboratorId(mention['id']);
                },
                onSubmitted: (value) {},
                decoration: InputDecoration(
                    hintText: 'Etiqueta a @alguien y reconocelo!'),
                mentions: [
                  Mention(
                    trigger: '@',
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                    ),
                    data: model.collaboratorsList,
                    matchAll: false,
                    suggestionBuilder: (data) {
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        width: 150,
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                data['avatar'],
                              ),
                              backgroundColor: AppColors.tertiaryColorLight,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Column(
                              children: <Widget>[
                                Text("${data['display']}"),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              FilledButton(
                style: Theme.of(context).filledButtonTheme.style,
                onPressed: () {
                  model.handleSubmitAcknowledgment();
                },
                child: const Text('Reconocer'),
              )
            ],
          ),
        )
      ],
    );
  }

  SizedBox _buildBadgesFromCategorySection() {
    return SizedBox(
      height: 110,
      child: model.loadingBadges
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              itemCount: model.badges.badges.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  width: 90,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      model.selectedBadge == model.badges.badges[index]
                          ? model.selectedBadge = null
                          : model.selectedBadge = model.badges.badges[index];
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            "https://api.bondly.mx/${model.badges.badges?[index].image}",
                          ),
                        ),
                        Text(
                          '${model.badges.badges[index].value}pts',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          model.badges.badges?[index].name ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }

  SizedBox _buildCategoriesSection() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(10),
          itemCount: model.categories.categories?.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              height: 80,
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () {
                  model.loadingBadges = true;
                  model.selectedCategory ==
                          model.categories.categories?[index].id
                      ? model.selectedCategory = null
                      : model.selectedCategory =
                          model.categories.categories?[index].id;
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.network(
                        "https://api.bondly.mx/${model.categories.categories?[index].imageUrl}",
                      ),
                    ),
                    Text(
                      model.categories.categories?[index].name ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
