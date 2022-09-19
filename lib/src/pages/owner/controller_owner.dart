import '../../modells/cost.dart';
import 'components/table.dart';

class ControllerOwner {
  static void specificSort({
    required int index,
    required int columnIndex,
    required bool ascending,
    required TableData source,
    required Function sort,
  }) {
    index == 0
        ? sort<DateTime>(
            (Cost cost) => cost.creation, columnIndex, ascending, source)
        : index == 1
            ? sort<String>(
                (Cost cost) => cost.category, columnIndex, ascending, source)
            : index == 2
                ? sort<num>(
                    (Cost cost) => cost.value, columnIndex, ascending, source)
                : index == 3
                    ? sort<String>((Cost cost) => cost.reason, columnIndex,
                        ascending, source)
                    : index == 4
                        ? sort<String>((Cost cost) => cost.description,
                            columnIndex, ascending, source)
                        : index == 5
                            ? sort<String>((Cost cost) => cost.responsibility,
                                columnIndex, ascending, source)
                            : null;
  }
}
