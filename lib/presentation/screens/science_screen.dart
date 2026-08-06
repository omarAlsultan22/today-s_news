import 'base/base_tab_screen.dart';
import 'package:flutter/material.dart';


class ScienceScreen extends BaseTabScreen {
  const ScienceScreen({super.key});

  @override
  int get screenIndex => 2;

  @override
  IconData get icon => Icons.science;

  @override
  String get category => 'science';

  @override
  State<ScienceScreen> createState() => _ScienceScreenState();
}

class _ScienceScreenState extends BaseTabScreenState<ScienceScreen> {}