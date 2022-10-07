import '../../modells/cost.dart';
import 'components/table.dart';

class ControllerOwner {
  /// Depending on Index the sort method is called with specific sortable
  ///
  /// * ColumnIndex == 0 -> sort Method is called with Comparable DateTime
  /// * ColumnIndex == 1 -> sort Method is called with Comparable String
  /// * ColumnIndex == 2 -> sort Method is called with Comparable num
  /// * ColumnIndex == 3 -> sort Method is called with Comparable String
  /// * ColumnIndex == 4 -> sort Method is called with Comparable String
  /// * ColumnIndex == 5 -> sort Method is called with Comparable String
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
