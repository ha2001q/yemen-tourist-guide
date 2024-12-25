import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class PlaceReviewWidget extends StatelessWidget {
  PlaceReviewWidget({super.key, required this.name, required this.image, required this.massage, required this.rate, required this.time});
  final String name;
  final String image;
  final String massage;
  final String rate;
  final String time;




  @override
  Widget build(BuildContext context) {
    return Container(
      width: 326,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            /// image
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(image),
                  fit: BoxFit.cover
                )
              ),
            ),

            SizedBox(width: 4,),

            /// data
            ///

            SizedBox(
              width: 326 - 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // SizedBox(width: double.infinity,),
                  /// name and stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [


                      Text(name),

                      // rate == 1 ? "⭐" : "⭐ ⭐ ⭐ ⭐ ⭐";
                      // rate == 1 ? "⭐" : "⭐ ⭐ ⭐ ⭐ ⭐";




                      Text(
                        rate == '1.0'
                            ? '⭐'
                            : rate == '1.5'
                            ? '⭐½'
                            : rate == '2.0'
                            ? '⭐⭐'
                            : rate == '2.5'
                            ? '⭐⭐½'
                            : rate == '3.0'
                            ? '⭐⭐⭐'
                            : rate == '3.5'
                            ? '⭐⭐⭐½'
                            : rate == '4.0'
                            ? '⭐⭐⭐⭐'
                            : rate == '4.5'
                            ? '⭐⭐⭐⭐½'
                            : rate == '5.0'
                            ? '⭐⭐⭐⭐⭐'
                            : '',
                      ),

                    ],
                  ),

                  /// message
                  Text(massage),

                  /// time
                  Text(time)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
