import '../screens/sports_screen.dart';
import 'package:flutter/cupertino.dart';
import '../screens/science_screen.dart';
import '../screens/business_screen.dart';


class ScreenItems {
  static const List <Widget> screenItems = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];
}