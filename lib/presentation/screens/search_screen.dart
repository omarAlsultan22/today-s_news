import '../cubits/search_cubit.dart';
import '../states/search_state.dart';
import '../widgets/search_field.dart';
import 'package:flutter/material.dart';
import '../mixins/debounce_mixin.dart';
import '../widgets/lists/list_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/connectivity_provider.dart';
import '../widgets/states/loading_state_widget.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';


class SearchScreen extends StatefulWidget {
  final LoadDataUseCase loadDataUseCase;
  final ConnectivityProvider connectivityProvider;

  const SearchScreen({
    super.key,
    required this.loadDataUseCase,
    required this.connectivityProvider
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with DebounceMixin {
  final TextEditingController _searchController = TextEditingController();
  static const int _debounceMs = 500;
  late final SearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _searchCubit = SearchCubit(
      loadDataUseCase: widget.loadDataUseCase,
      connectivityProvider: widget.connectivityProvider,
    );
  }

  @override
  void dispose() {
    disposeDebounce();
    _searchCubit.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    runDebounced(const Duration(milliseconds: _debounceMs), () =>
        _searchCubit.getSearch(query: query));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchCubit,
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(),
            body: Column(
              children: [
                SearchField(
                  controller: _searchController,
                  onChanged: _onSearchChanged, // الـ debounce يديرها
                ),
                Expanded(child: _buildContent(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(SearchState state) {
    return state.when(
      onInitial: () => const Center(child: Text('Type to start searching')),
      onLoading: () => const LoadingStateWidget(),
      onLoaded: (data) {
        if (data.queryIsNotEmpty && data.productsIsEmpty) {
          return const Center(child: Text('No news found'));
        }
        return ListBuilder(
            isLocked: false,
            list: data.products,
            hasMore: data.hasMore,
            messageResult: data.messageResult,
            onScroll: _searchCubit.loadMoreSearch
        );
      },
      onError: (error) =>
          error.buildErrorWidget(
            onRetry: () =>
                _searchCubit.getSearch(query: _searchController.text),
          ),
    );
  }

  AppBar _buildAppBar() =>
      AppBar(
        title: const Text('Search Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      );
}