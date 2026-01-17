import '../../../data/models/tab_data.dart';


abstract class TabDataWhenStrategy {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(TabData? tabData) loaded,
    required R Function(String errorText, bool errorType) error,
  });
}
