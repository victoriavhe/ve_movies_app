import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String formatDate() {
    return DateFormat('dd MMM yyyy').format(this);
  }
}