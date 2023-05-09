// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

class Orders {
  final bool isVeg;
  final String description;
  final double range;
  final DateFormat date;

  Orders({
    required this.range,
    required this.isVeg,
    required this.description,
    required this.date,
  });
}
