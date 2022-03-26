import 'package:flutter/material.dart';
import 'package:selectable_container/selectable_container.dart';
import 'package:sizer/sizer.dart';

import '../../config/themes/colors.dart';

class CategoryWidget extends StatefulWidget {
  final String category;
  const CategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late String category;
  bool _select1 = false;


  @override
  void initState() {
    category = widget.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Align(
            alignment: Alignment.center,
            child: Text(category,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
