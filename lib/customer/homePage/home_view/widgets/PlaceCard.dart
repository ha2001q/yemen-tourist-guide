import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaceCard extends StatefulWidget {
  const PlaceCard({super.key,required this.title,required this.location,required this.rating,required this.reviews,required this.imagePath, required this.onTap});
  final String title;
  final String location;
  final double rating;
  final int reviews;
  final String imagePath;
  final VoidCallback onTap;

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {

  @override
  Widget build(BuildContext context) {
    int rev=widget.reviews;
    double rating=widget.rating;
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 200,
        width: 160,
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
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(

                      color: Colors.white,
                    borderRadius: BorderRadius.circular(13)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
                              '$rev Reviews',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
