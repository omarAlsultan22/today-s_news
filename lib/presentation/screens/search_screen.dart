import '../cubits/search_cubit.dart';
import '../states/search_state.dart';
import 'package:flutter/material.dart';
import '../widgets/lists/list_builder.dart';
import '../../data/models/article_Model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/states/loading_state_widget.dart';
import 'package:todays_news/core/constants/app_constants.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import '../widgets/states/error_widgets/connection_error_state_widget.dart';
import 'package:todays_news/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:todays_news/presentation/widgets/states/error_widgets/error_state_widget.dart';


class SearchScreen extends StatefulWidget {
  final LoadDataUseCase _loadDataUseCase;

  const SearchScreen({required LoadDataUseCase loadDataUseCase, super.key})
      : _loadDataUseCase = loadDataUseCase;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  late SearchCubit _currentCubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  static const _zero = AppConstants.zero;
  static const _fontSize = AppConstants.mediumSize;
  static const _paddingAll = _fontSize;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchController.removeListener(_onSearchData);
    super.dispose();
  }

  void _onSearchData() {
    _currentCubit.getSearch(query: _searchController.text.trim());
  }

  AppBar _buildAppBar(List<Article> data) =>
      AppBar(
        elevation: _zero,
        scrolledUnderElevation: _zero,
        title: const Text(
          "Search Screen",
          style: TextStyle(
            fontSize: _fontSize,
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
    final connectivityProvider = ConnectivityProvider();
    return BlocProvider(create: (context) =>
        SearchCubit(loadDataUseCase: widget._loadDataUseCase,
            connectivityProvider: connectivityProvider),
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
                  const SizedBox(height: AppConstants.smallSize),
                  Expanded(
                    child: state.when(
                        onConnection: ()=> const Center(
                            child: ConnectionErrorStateWidget()
                        ),
                        onInitial: () =>
                        const Expanded(
                            child: Center(child: Text(
                                'Type to start searching'))),
                        onLoading: () =>
                        const LoadingStateWidget(),
                        onLoaded: (newTabData) =>
                            ListBuilder(
                                isLocked: false,
                                list: newTabData.products,
                                hasMore: tabData.hasMore,
                                onScroll: () {
                                  _currentCubit.getSearch(
                                      query: _searchController.text
                                  );
                                }
                            ),
                        onError: (error) =>
                        ErrorStateWidget(
                            error: error.message,
                            onRetry: () =>
                                _currentCubit.getSearch(
                                    query: _searchController.text))
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
      padding: const EdgeInsets.all(_paddingAll),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: AppConstants.searchIcon,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.largeSize),
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