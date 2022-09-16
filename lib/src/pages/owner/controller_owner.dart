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

  static String formatInput({required String item}) {
    item = item.replaceAll(",", ".");
    if (".".allMatches(item).length > 1) {
      for (int i = item.indexOf(".") + 1; i < item.length; i++) {
        if (item[i] == ".") {
          item = item.replaceRange(i, i + 1, "");
        }
      }
    }
    if (item.contains(".")) {
      for (int i = item.indexOf(".") + 3; i < item.length; i++) {
        if (item[i] != "€") {
          item = item.replaceRange(i, i + 1, "");
        }
      }
    }
    item = item.replaceAll("€", "");
    return "$item€";
  }
}
