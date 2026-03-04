import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewCard extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final String date;
  final double rating;
  final String comment;

  const ReviewCard({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.date,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColor.k949494.withOpacity(0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundImage: NetworkImage(userAvatar),
            backgroundColor: AppColor.kFFF1E8,
          ),
          const SizedBox(width: 6.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userName,
                      style: AppStyle.smallContentBold.copyWith(
                        color: AppColor.black500,
                      ),
                    ),
                    Text(
                      date,
                      style: AppStyle.smallContentRegular.copyWith(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),

                Row(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: SvgPicture.asset(
                        AppAsset.star01,
                        width: 16,
                        height: 16,

                        colorFilter: ColorFilter.mode(
                          index < rating
                              ? AppColor.orange500
                              : AppColor.black100,
                          BlendMode.srcIn,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10.0),
                Text(
                  comment,
                  style: AppStyle.smallContentRegular.copyWith(
                    color: AppColor.black400,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
