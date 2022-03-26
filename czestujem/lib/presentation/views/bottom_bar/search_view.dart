import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:czestujem/domain/entities/food.dart';
import 'package:czestujem/presentation/widgets/food_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  @override
  void initState() {


  }

  @override
  Widget build(BuildContext context) {
    CollectionReference foods = FirebaseFirestore.instance.collection("foodCollection");
    return StreamBuilder<QuerySnapshot>(
        stream: foods.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading"),
            );
          }

          if (snapshot.hasData) {
            print(snapshot.data!.size);
            return GridView.count(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              crossAxisSpacing: 1.w,
              crossAxisCount: 2,
              children: getExpenseItems(snapshot)
            );
          }
          return Container();
        });
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map((doc) => FoodTile(food: Food.fromJSON(doc.data() as Map<String, dynamic>),))
        .toList();
  }
}
