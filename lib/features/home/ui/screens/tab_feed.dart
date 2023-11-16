import 'package:bondly_app/features/home/ui/viewmodels/home_viewmodel.dart';
import 'package:bondly_app/features/home/ui/widgets/single_post_widget.dart';
import 'package:flutter/material.dart';

class FeedTab extends StatefulWidget {
  final HomeViewModel model;
  const FeedTab({Key? key, required this.model}) : super(key: key);

  @override
  _FeedTabState createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  late HomeViewModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: model.feeds.data.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        SinglePostWidget(
                            post: model.feeds.data[index], index: index)
                      ],
                    );
                  }
                  return Column(
                    children: [
                      SinglePostWidget(
                        post: model.feeds.data[index],
                        index: index,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
