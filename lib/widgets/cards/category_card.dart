import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/models/category.dart';
import 'package:nineteenfive_ecommerce_app/screens/admin/add_category.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/size_card.dart';
import 'package:nineteenfive_ecommerce_app/widgets/image/image_network.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard(this.category);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCategory.editCategory(widget.category))).then((value) => setState((){}));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(28),
            vertical: ScreenUtil().setHeight(10)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(28)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(17)),
            border: Border.all(
              color: Colors.grey[100]!,
              width: 2
            ),
            boxShadow: [
              // BoxShadow(
              //     color: Colors.black.withOpacity(0.1),
              //     offset: Offset(2, 2),
              //     blurRadius: 20),
              // BoxShadow
              //     color: Colors.white.withOpacity(1),
              //     offset: Offset(-6, -6),
              //     blurRadius: 10),
            ]),
        child: Row(
          children: [
            Hero(
              tag: widget.category.categoryId,
              child: ImageNetwork(
                imageUrl:widget.category.imageUrl,
                width: ScreenUtil().setWidth(55),
                height: ScreenUtil().setHeight(50),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(40),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.category.categoryName,
                      style: Theme.of(context).textTheme.headline5),
                  if (widget.category.sizes != null)
                    Wrap(
                      children:
                          List.generate(widget.category.sizes!.length, (index) {
                        return Padding(
                          padding:  EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                          child: SizeCard(
                            size: widget.category.sizes![index],
                            isSelected: false,
                          ),
                        );
                      }),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
