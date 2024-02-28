import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecentlyOpenedIssuances {
  static List<String> _openedIssuances = [];

  static void addIssuance(String filePath) {
    _openedIssuances.add(filePath);
  }

  static void removeIssuance(String filePath) {
    _openedIssuances.remove(filePath);
  }

  static List<String> get issuances => _openedIssuances;
}
