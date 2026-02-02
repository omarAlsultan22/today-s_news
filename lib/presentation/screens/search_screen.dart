import '../cubits/search_cubit.dart';
import '../states/search_state.dart';
import 'package:flutter/material.dart';
import '../../data/models/article_Model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/lists/list_builder.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/core/widgets/error_widgets/error_state.dart';
import '../../core/widgets/error_widgets/no_internet_connection_state.dart';


class SearchScreen extends StatefulWidget {
  final LoadDataUseCase _loadDataUseCase;

  const SearchScreen({required LoadDataUseCase loadDataUseCase, super.key})
      : _loadDataUseCase = loadDataUseCase;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  late SearchCubit _currentCubit;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchData);
  }

  @override
  void dispose() {
    searchController.dispose();
    searchController.removeListener(_onSearchData);
    super.dispose();
  }

  void _onSearchData() {
    _currentCubit.getSearch(query: searchController.text.trim());
  }

  AppBar _buildAppBar(List<Article> data) =>
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
    return BlocProvider(create: (context) =>
        SearchCubit(loadDataUseCase: widget._loadDataUseCase),
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            _currentCubit = SearchCubit.get(context);
            final tabData = state.categoryData;
            return Scaffold(
              appBar: _buildAppBar(tabData.products),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: state.when(
                      initial: () =>
                      const Expanded(
                          child: Center(child: Text('Type to start searching'))),
                      loading: () =>
                      const Center(child: CircularProgressIndicator()),
                      loaded: (newTabData) =>
                          ListBuilder(
                              list: newTabData!.products,
                              hasMore: tabData.hasMore,
                              onScroll: () {
                                _currentCubit.getSearch(
                                    query: searchController.text
                                );
                              }
                          ),
                      onError: (error) =>
                      error.isConnectionError ? TasksErrorStateWidget(
                          error: error.message,
                          onRetry: () =>
                              _currentCubit.getSearch(
                                  query: searchController.text)) :
                      Center(child: NoInternetConnection(
                          error: error.message)
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        )
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
}