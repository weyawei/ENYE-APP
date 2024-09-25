import 'package:intl/intl.dart';

Map<String, String> extractDateParts(String dateString) {
  // Parse the input string as a DateTime object
  DateTime parsedDate = DateTime.parse(dateString);

  // Extract day, month, and year as separate strings
  String day = DateFormat('d').format(parsedDate);     // e.g., 19
  String shortMonth = DateFormat('MMM').format(parsedDate);  // e.g., Sept
  String year = DateFormat('yyyy').format(parsedDate);  // e.g., 2024

  return {
    'day': day,
    'month': shortMonth,
    'year': year,
  };
}

String formatDateRangeSplitByTO(String dateRange) {
  // Extract current year
  int currentYear = DateTime.now().year;

  // Parse the input date range
  List<String> dates = dateRange.split(" to ");
  DateTime startDate = DateTime.parse(dates[0]);
  DateTime endDate = DateTime.parse(dates[1]);

  // Format for displaying day and month
  DateFormat dayMonthFormat = DateFormat("d MMM");

  // Check if the year matches the current year
  if (startDate.year == currentYear) {
    return "${dayMonthFormat.format(startDate)} - ${dayMonthFormat.format(endDate)}";
  } else {
    // Display with year if it's not the current year
    return "${dayMonthFormat.format(startDate)} ${startDate.year} - ${dayMonthFormat.format(endDate)} ${endDate.year}";
  }
}