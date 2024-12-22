import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/styles.dart';
class ServicesCard extends StatefulWidget {
  const ServicesCard({super.key,required this.title,required this.type,required this.location,required this.rating,required this.reviews, required this.imageBath, required this.onTap,});
  final String title;
  final String type;
  final String location;
  final double rating;
  final int reviews;
  final String imageBath;
  final VoidCallback onTap;
  // final String? price;

  @override
  State<ServicesCard> createState() => _ServicesCardState();
}

class _ServicesCardState extends State<ServicesCard> {
  @override
  Widget build(BuildContext context) {
    int reviews=widget.reviews;
    double rating=widget.rating;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image:  DecorationImage(
                  image: CachedNetworkImageProvider(widget.imageBath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.type,
                          style: fontSmallBold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: fontMediumBold,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Color(0xFFE17055), size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child:Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 14),
                                Text(
                                  '$rating',
                                  style: const TextStyle(fontSize: 12),
                                ),])
                      ),
                      Text(
                        '$reviews Reviews',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      // if (widget.price != null) ...[
                      //   const Spacer(),
                      //   Text(
                      //     widget.price,
                      //     style: const TextStyle(
                      //       color: Color(0xFFE17055),
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
