import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final dateFormatter = DateFormat.MEd();

class Note {
  Note({
    required this.title,
    required this.snippet,
    required this.date,
    String? id, // Optional id parameter
  }) : id = id ?? uuid.v4(); // Use provided id or generate a new one if null

  final String id; // Made id a final field
  String title;
  String snippet;
  DateTime date;

  String get timeStamp {
    return dateFormatter.format(date);
  }
}
