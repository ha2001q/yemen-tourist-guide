import 'package:flutter/material.dart';
import 'package:yemen_tourist_guide/customer/comment_screen/view/widgets/place_review_widget.dart';
class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          PlaceReviewWidget(),
          PlaceReviewWidget(),
          PlaceReviewWidget(),
          PlaceReviewWidget(),

        ],
      ),
    );
  }
}
