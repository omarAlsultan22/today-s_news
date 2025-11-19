import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/components.dart';
import '../shared/constants/state_keys.dart';
import 'package:flutter/material.dart';
import '../shared/cubit/states.dart';
import '../shared/cubit/cubit.dart';
import '../models/data_Model.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  late TodaysNewsCubit _currentCubit;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentCubit = TodaysNewsCubit.get(context);
    searchController.addListener(_onSearchData);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchData() {
    _currentCubit.getSearch(text: searchController.text.trim());
  }

  AppBar _buildAppBar(List<ArticleModel> data) =>
      AppBar(
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
            data.clear();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      );


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodaysNewsCubit, TodaysNewsStates>(
      listener: (context, state) =>
          scaffoldMessenger(
              state: state,
              context: context,
              key: StatesKeys.sports
          ),
      builder: (context, state) {
        final searchList = _currentCubit.searchList;
        return Scaffold(
          appBar: _buildAppBar(searchList),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSearchField(),
              const SizedBox(height: 10.0),
              _buildSearchResults(searchList),
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

  Widget _buildSearchResults(List<ArticleModel> data) {
    if (searchController.text.isEmpty) {
      return const Expanded(
          child: Center(child: Text('Type to start searching')));
    }
    return Expanded(child:
        ListBuilder(
            list: data,
            isLoadingMore: _currentCubit.isSearchLoadingMore,
            onPressed: () {
              _currentCubit.getPaginationSearch(
                  text: searchController.text, loadMore: true);
            }
        )
    );
  }
}