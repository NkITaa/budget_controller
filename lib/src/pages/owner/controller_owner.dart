import '../../modells/cost.dart';
import 'components/table.dart';

class ControllerOwner {
  /// depending on Index the sort method is called with specific sortable
  ///
  /// * columnIndex == 0 -> sort Method is called with sortable DateTime
  /// * columnIndex == 1 -> sort Method is called with sortable String
  /// * columnIndex == 2 -> sort Method is called with sortable num
  /// * columnIndex == 3 -> sort Method is called with sortable String
  /// * columnIndex == 4 -> sort Method is called with sortable String
  /// * columnIndex == 5 -> sort Method is called with sortable String
  static void specificSort({
    required int columnIndex,
    required bool ascending,
    required TableData source,
    required Function sort,
  }) {
    columnIndex == 0
        ? sort<DateTime>(
            (Cost cost) => cost.creation, columnIndex, ascending, source)
        : columnIndex == 1
            ? sort<String>(
                (Cost cost) => cost.category, columnIndex, ascending, source)
            : columnIndex == 2
                ? sort<num>(
                    (Cost cost) => cost.value, columnIndex, ascending, source)
                : columnIndex == 3
                    ? sort<String>((Cost cost) => cost.reason, columnIndex,
                        ascending, source)
                    : columnIndex == 4
                        ? sort<String>((Cost cost) => cost.description,
                            columnIndex, ascending, source)
                        : columnIndex == 5
                            ? sort<String>((Cost cost) => cost.responsibility,
                                columnIndex, ascending, source)
                            : null;
  }
}
