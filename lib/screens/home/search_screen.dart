import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/models/product.dart';
import 'package:nineteenfive_ecommerce_app/screens/product/item_details.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:nineteenfive_ecommerce_app/utils/color_palette.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  List<Product> suggestions = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // StaticData.categoriesList.forEach((element) {
    //   if (element.categoryName
    //       .trim()
    //       .toLowerCase()
    //       .contains(query.trim().toLowerCase())) {
    //     suggestions.add(element.categoryName);
    //   }
    // });
    searchFocusNode.requestFocus();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          leading: IconButton(
            icon: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: ScreenUtil().setWidth(25),
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: ScreenUtil().setWidth(70),
            decoration: BoxDecoration(
                color: ColorPalette.lightGrey,
                borderRadius: BorderRadius.circular(ScreenUtil().radius(15))),
            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              cursorColor: Theme.of(context).cursorColor,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                setState(() {
                  query = value;
                  suggestions.clear();
                  if (query.trim().isNotEmpty) {
                    StaticData.products.forEach((element) {
                      if (element.productName
                          .trim()
                          .toLowerCase()
                          .contains(query.trim().toLowerCase())) {
                        suggestions.add(element);
                      }
                    });
                  }
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search Product',
                hintStyle: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: ColorPalette.darkGrey),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: ColorPalette.black, height: 1.8),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    query = '';
                    searchController.clear();
                    suggestions.clear();
                  });
                },
                icon: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.clear,
                    size: ScreenUtil().setWidth(25),
                  ),
                )),
          ],
        ),
        body: query.isNotEmpty && suggestions.length == 0
            ? Container(
                width: double.infinity,
                child: Text(
                  'No product found for \"$query\"',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: ColorPalette.black, height: 1.8),
                ),
              )
            : GridView.builder(
                itemCount: suggestions.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(18),
                  vertical: ScreenUtil().setWidth(10),
                ),
                // physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    childAspectRatio: 0.64),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ItemDetails(suggestions[index])))
                          .then((value) => setState(() {}));
                    },
                    child: ProductCard(
                      suggestions[index],
                    ),
                  );
                },
              ));
  }
}
