import 'package:flutter/material.dart';

Color statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'alive':
      return Colors.green;
    case 'dead':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
