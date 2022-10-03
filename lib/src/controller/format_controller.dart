import '../modells/cost.dart';

class FormatController {
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

  static String dateTimeFormatter({required DateTime dateTime}) {
    return "${dateTime.day.toString()}.${dateTime.month.toString()}.${dateTime.year.toString()}";
  }

  static List<Cost?>? relevantCosts(
      {required List<Cost>? costs,
      required String category,
      required DateTime date}) {
    var temp = costs?.map((cost) {
      if (cost.category == category && cost.creation.isBefore(date)) {
        return cost;
      }
    }).toList();
    temp?.removeWhere((cost) => cost == null);
    return temp;
  }

  static double totalCosts({required List<Cost?> costs}) {
    List<double?> temp = costs.map((cost) {
      if (cost != null) {
        cost.value;
      }
    }).toList();

    return temp.fold(0, (a, b) => a + (b ?? 0));
  }
}
