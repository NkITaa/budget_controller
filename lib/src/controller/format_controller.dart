import '../const.dart';
import '../modells/cost.dart';

// Defines methods to handle the formatting of data
class FormatController {
  // Formatter that controlls the number input
  static String formatInput({required String item}) {
    // All ',' get replaced by a '.'
    item = item.replaceAll(",", ".");

    // When more than one point is in the String all the later ones get deleted
    if (".".allMatches(item).length > 1) {
      for (int i = item.indexOf(".") + 1; i < item.length; i++) {
        if (item[i] == ".") {
          item = item.replaceRange(i, i + 1, "");
        }
      }
    }

    // If there are more than 3 characters after the '.' the following numbers are trimmed
    if (item.contains(".")) {
      for (int i = item.indexOf(".") + 3; i < item.length; i++) {
        if (item[i] != Const.currency) {
          item = item.replaceRange(i, i + 1, "");
        }
      }
    }

    // The specific currency gets deleted from the String itself
    item = item.replaceAll(Const.currency, "");

    // The ready formated String gets returned
    return "$item${Const.currency}";
  }

  // A dateTime is reformated to a specific String with the form: "dd.mm.yyyy"
  static String dateTimeFormatter({required DateTime dateTime}) {
    return "${dateTime.day.toString()}.${dateTime.month.toString()}.${dateTime.year.toString()}";
  }

  // Gets only the relevant costs
  static List<Cost?>? relevantCosts(
      {required List<Cost>? costs,
      required String category,
      required DateTime date}) {
    /// Costs are filtered and the relevant ones are added to a list, with following filters:
    ///
    /// cost.category == category
    /// cost.creation is before entered date
    var temp = costs?.map((cost) {
      if (cost.category == category && cost.creation.isBefore(date)) {
        return cost;
      }
    }).toList();

    // The costs that are null are removed from the list
    temp?.removeWhere((cost) => cost == null);

    // The List gets returned
    return temp;
  }

  // Calculates total costs from a Cost-List
  static double totalCosts({required List<Cost?> costs}) {
    // Writes all values of the costs in a separate list as a double
    List<double?> temp = costs.map((cost) {
      if (cost != null) {
        cost.value;
      }
    }).toList();

    // Sums all the cost values up
    return temp.fold(0, (a, b) => a + (b ?? 0));
  }
}
