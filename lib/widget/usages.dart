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