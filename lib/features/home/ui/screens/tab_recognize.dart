import 'package:bondly_app/config/colors.dart';
import 'package:bondly_app/config/strings_home.dart';
import 'package:bondly_app/config/theme.dart';
import 'package:bondly_app/dependencies/dependency_manager.dart';
import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/gold_bordered_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

class Recognizetab extends StatefulWidget {
  final HomeViewModel model;
  const Recognizetab({super.key, required this.model});

  @override
  State<Recognizetab> createState() => _RecognizetabState();
}

class _RecognizetabState extends State<Recognizetab> {
  late HomeViewModel model;
  @override
  void initState() {
    model = getIt<HomeViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAnouncementsSection(),
            const SizedBox(height: 15),
            _buildAcknowledgmentsSection(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildAnouncementsSection() {
    return GoldBorderedContainer(
      child: Column(
        children: [
          Text(
            StringsHome.announcementTitle,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const Divider(),
          const SizedBox(height: 10),
          _buildAnnouncementsList(),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsList() {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: double.infinity,
          child: CarouselSlider(
            carouselController: model.carouselController,
            options: CarouselOptions(
              height: 80.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(milliseconds: 2000),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: true,
              viewportFraction: 1,
              disableCenter: true,
              onPageChanged: (index, reason) {
                model.onAnnouncementChanged(index);
              },
            ),
            items: model.announcements.map<Widget>((announcement) {
              debugPrint("Announcement: ${announcement.content}");
              return Builder(
                builder: (BuildContext context) {
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "${announcement.content}",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ));
                },
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: model.announcements.map((announcement) {
            int index = model.announcements.indexOf(announcement);
            return GestureDetector(
              onTap: () {
                model.carouselController.animateToPage(index);
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: model.currentAnnouncementIndex == index
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withOpacity(0.5),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAcknowledgmentsSection() {
    return GoldBorderedContainer(
      child: Column(
        children: [
          Text(
            StringsHome.acknowledgmentAmountOfPoints(
                model.user?.giftedPoints.toString() ?? ''),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            StringsHome.acknowledgmentCategorySubHeader(
                model.categories.categories?.length.toString() ?? ''),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          _buildCategoriesSection(),
          model.selectedCategory == null
              ? const SizedBox()
              : Column(
                  children: [
                    const Divider(),
                    _buildBadgesFromCategorySection(),
                  ],
                ),
          model.selectedBadge == null
              ? const SizedBox()
              : Column(
                  children: [
                    const Divider(),
                    _buildCreateAcknowledgment(),
                  ],
                )
        ],
      ),
    );
  }

  Widget _buildCreateAcknowledgment() {
    return Row(
      children: [
        Container(
          height: 120,
          width: 90,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () {},
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://api.bondly.mx/${model.selectedBadge?.image}",
                  ),
                ),
                Text(
                  "${model.selectedBadge?.value ?? ''} pts",
                  style: Theme.of(context).textTheme.bodySmall
                  ,
                  textAlign: TextAlign.center,
                ),
                Text(
                  model.selectedBadge?.name ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.isDarkMode ?AppColors.tertiaryColorLight: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 230,
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
                decoration:  InputDecoration(
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                    helperStyle: Theme.of(context).textTheme.bodyMedium,
                    hintText: StringsHome.acknowledgMentInputHint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                mentions: [
                  Mention(
                    trigger: '@',
                    style:  TextStyle(
                      color: context.isDarkMode ? AppColors.tertiaryColorLight : AppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    data: model.collaboratorsList,
                    matchAll: false,
                    suggestionBuilder: (data) {
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? Colors.grey[800] : Colors.white,
                        ),
                        width: 150,
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                data['avatar'],
                              ),
                              backgroundColor: AppColors.tertiaryColorLight,
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Column(
                              children: <Widget>[
                                Text("${data['display']}",style: context.themeData.textTheme.bodyMedium?.copyWith(

                                ),),
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
              model.collaboratorsIds.isNotEmpty &&
                      model
                          .mentionsKey.currentState!.controller!.text.isNotEmpty
                  ? OutlinedButton(
                      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                        side: MaterialStateProperty.all(
                          BorderSide(
                            color: context.isDarkMode ? AppColors.tertiaryColorLight : AppColors.tertiaryColor,
                          ),
                      )
                      ),
                      onPressed: () async {
                        model.creatingAcknowledgment = true;
                        await model.handleSubmitAcknowledgment();

                        model.creatingAcknowledgment = false;
                      },
                      child: model.creatingAcknowledgment
                          ? const CircularProgressIndicator.adaptive()
                          :  Text(
                              StringsHome.acknowledgmentInputButtonText,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:context.isDarkMode ? AppColors.tertiaryColorLight : AppColors.tertiaryColor

                    ),),)
                  : const SizedBox()
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBadgesFromCategorySection() {
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
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://api.bondly.mx/${model.badges.badges[index].image}",
                          ),
                        ),
                        Text(
                          '${model.badges.badges[index].value}pts',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          model.badges.badges[index].name ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
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

  Widget _buildCategoriesSection() {
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
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://api.bondly.mx/${model.categories.categories?[index].imageUrl}",
                      ),
                    ),
                    Text(
                      model.categories.categories?[index].name ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
