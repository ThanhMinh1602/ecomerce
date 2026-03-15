import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/product_detail/widgets/review_card.dart';
import 'package:flutter/material.dart';

class ProductReviewList extends StatelessWidget {
  const ProductReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Reviews(112)', style: AppStyle.smallContentBold),
            GestureDetector(
              onTap: () {},
              child: Text(
                'see more',
                style: AppStyle.smallContentRegular.copyWith(
                  color: AppColor.k949494,
                  fontSize: 12.0,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 12.0),
          itemBuilder: (context, index) {
            return const ReviewCard(
              userName: "Johny Dang",
              userAvatar:
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6t5FdJANrWj65CYTMOhwrNnb1dGz5-obsHlbbE_nJqwNwzcCGt8oF6_C4qkFItNF-1gQmbDM-JBTXw47z75CWJpyyYBf5tu77RlARKg&s=10",
              date: "Oct 26, 2020",
              rating: 5,
              comment: "I really like this product.",
            );
          },
        ),
      ],
    );
  }
}
