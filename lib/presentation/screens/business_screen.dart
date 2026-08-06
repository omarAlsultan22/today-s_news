import 'base/base_tab_screen.dart';
import 'package:flutter/material.dart';


class BusinessScreen extends BaseTabScreen {
  const BusinessScreen({super.key});

  @override
  int get screenIndex => 0;

  @override
  IconData get icon => Icons.business;

  @override
  String get category => 'business';

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends BaseTabScreenState<BusinessScreen> {}