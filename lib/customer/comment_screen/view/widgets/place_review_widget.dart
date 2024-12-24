import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class PlaceReviewWidget extends StatelessWidget {
  const PlaceReviewWidget({super.key});

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
                  image: CachedNetworkImageProvider('https://s.france24.com/media/display/cc2f52c0-b4eb-11ea-a534-005056a964fe/w:1280/p:16x9/yemen%20houthi%20sanaa%20reuters.jpg'),
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


                      Text('dheya'),


                      Text('⭐ ⭐ ⭐ ⭐ ⭐')
                    ],
                  ),

                  /// message
                  Text('dheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheyadheya'),

                  /// time
                  Text('10:4PM')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
