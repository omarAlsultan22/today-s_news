import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/cubit.dart';
import '../modules/states.dart';
import '../shared/components/components.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  late TodayNewsCubit _cubit;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cubit = TodayNewsCubit.get(context);
    searchController.addListener(_onSearchData);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchData() {
    _cubit.getSearch(searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodayNewsCubit, TodayNewsStates>(
      listener: (context, state) {
        if (state is BusinessErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) {
        final list = _cubit.searchList;

        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            title: const Text(
              "Search Screen",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
                list.clear();
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSearchField(),
              const SizedBox(height: 10.0),
              _buildSearchResults(list),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> list) {
    if (searchController.text.isEmpty) {
      return const Expanded(
          child: Center(child: Text('Type to start searching')));
    }

    return Expanded(
      child: conditionalBuilder(
        list: list,
        length: 20,
      ),
    );
  }
}