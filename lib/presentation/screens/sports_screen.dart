import 'package:flutter/material.dart';
import 'base/base_tab_screen.dart';


class SportsScreen extends BaseTabScreen {
  const SportsScreen({super.key});

  @override
  int get screenIndex => 1;

  @override
  IconData get icon => Icons.sports;

  @override
  String get category => 'sports';

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends BaseTabScreenState<SportsScreen> {}
