
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:yemen_tourist_guide/customer/add_review/controller/review_controller.dart';
class ReviewScreen extends StatefulWidget {
  ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  ReviewController reviewController = Get.put(ReviewController());

  final GlobalKey<FormState> commentKey = GlobalKey<FormState>();

  final TextEditingController comment = TextEditingController();

  double rating = 0;

  var argument ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    argument = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Add Comment"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: commentKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30.0),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    rating = newRating;
                  },
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  controller: comment,
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Add comment",
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your comment.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50.0),
                Obx(() => Container(
                  height: 70,
                  width: 276,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: reviewController.isLoading.value
                        ? null
                        : () async {
                      if (commentKey.currentState!.validate()) {
                        if (rating == 0) {
                          Get.snackbar(
                            'Error',
                            'Please provide a rating.',
                          );
                          return;
                        }
                        final review = reviewController.toString().trim();
                        await reviewController.addComment(
                          rate: rating,
                          message: comment.text,
                          placeId:argument['place_id'],
                        );
                        Navigator.pop(context); // Close the screen
                      }
                    },
                    child: Center(
                      child: reviewController.isLoading.value
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "Send",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
