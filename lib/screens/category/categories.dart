import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_ecommerce_app/models/category.dart';
import 'package:nineteenfive_ecommerce_app/screens/admin/add_category.dart';
import 'package:nineteenfive_ecommerce_app/widgets/cards/category_card.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: ScreenUtil().setWidth(25),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Categories',
            style: Theme.of(context).appBarTheme.textTheme!.headline1),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddCategory()));
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: ScreenUtil().setWidth(30),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(20),
          )
        ],
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context,AsyncSnapshot snapshot){
          late List categoriesList;
          if(snapshot.hasData) {
            List data = snapshot.data.docs;
            categoriesList = [];
            data.forEach((element) {
              categoriesList.add(Category.fromJson(element.data()));
            });
          }
          return snapshot.hasData?ListView.builder(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(28)),
            itemCount: categoriesList.length,
            itemBuilder: (context, index) {
              return CategoryCard(categoriesList[index]);
            },
          ):Container(child: Center(child: CircularProgressIndicator()));
        },
      )
      // body: ListView.builder(
      //     padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(28)),
      //     itemCount: StaticData.categoriesList.length,
      //     itemBuilder: (context, index) {
      //       return CategoryCard(StaticData.categoriesList[index]);
      //     }),
    );
  }
}
