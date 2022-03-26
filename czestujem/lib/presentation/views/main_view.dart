import 'dart:math';

import 'package:czestujem/config/themes/colors.dart';
import 'package:czestujem/presentation/views/bottom_bar/add_view.dart';
import 'package:czestujem/presentation/views/bottom_bar/chat_list_view.dart';
import 'package:czestujem/presentation/views/bottom_bar/home_view.dart';
import 'package:czestujem/presentation/views/bottom_bar/search_view.dart';
import 'package:czestujem/presentation/views/bottom_bar/user_view.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:czestujem/core/utils/globals.dart' as globals;


class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  late List _children;

  @override
  void initState() {
    _children = [
      HomeView(),
      SearchView(),
      AddView(),
      ChatListView(),
      UserView()
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: _children[_currentIndex],
    );
  }
  
  Widget _buildBottomNavigationBar(){
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.grey[100],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: foodOrange,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(LineIcons.home,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.search,
            ),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.plus,
              color: foodBlueGreen,
            ),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.commentAlt,
            ),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.user,
            ),
            label: ""
          ),
        ]
      ),
    );
  }

  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }

}
