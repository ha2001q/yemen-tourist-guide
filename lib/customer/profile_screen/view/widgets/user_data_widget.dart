import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/styles.dart';

class UserDataWidget extends StatefulWidget {
  const UserDataWidget({super.key, required this.userData, required this.iconUserData});
  final String userData;
  final String iconUserData;

  @override
  State<UserDataWidget> createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
          width: double.infinity,
          height: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xffF5F4F8)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.userData,
                style: fontMediumBold,
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(
                widget.iconUserData,
                width: 20,
                height: 20,
              ),
            ],
          ),
      ),
    );
  }
}
