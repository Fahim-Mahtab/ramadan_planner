import 'package:flutter/foundation.dart';
import '../models/asmaul_husna_model.dart';

class AsmaulHusnaProvider extends ChangeNotifier {
  AsmaulHusnaModel get nameOfTheDay {
    final index = (DateTime.now().day - 1) % allNames.length;
    return allNames[index];
  }
}
