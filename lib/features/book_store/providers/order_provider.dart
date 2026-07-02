import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool _success = false;
  String? _error;

  bool get isLoading => _isLoading;
  bool get success => _success;
  String? get error => _error;

  Future<bool> placeOrder(OrderModel order) async {
    _isLoading = true;
    _success = false;
    _error = null;
    notifyListeners();

    try {
      await _supabase.from('orders').insert(order.toMap());
      _success = true;
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('OrderProvider error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _success = false;
    _error = null;
    notifyListeners();
  }
}
