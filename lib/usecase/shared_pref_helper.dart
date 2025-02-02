import 'package:shared_preferences/shared_preferences.dart';

abstract interface class _SharedPreferenceUseCase {
  void setInt(String key, int value);
  void setDouble(String key, double value);
  void setString(String key, String value);
  void setBool(String key, bool value);
  void setList(String key, List<String> value);
  Future<String> getString(String key);
  Future<int> getInt(String key);
  Future<double> getDouble(String key);
  Future<bool> getBool(String key);
  Future<List<String>> getList(String key);
  Future<bool> containKey(String key);
  void remove(String key);
  void clearAll();
}

class SharedPreferenceUseCaseRepo implements _SharedPreferenceUseCase {
  final _pref = SharedPreferences.getInstance();

  @override
  void setString(String key, String value) async {
    final sp = await _pref;
    await sp.setString(key, value);
  }

  @override
  Future<String> getString(String key) async {
    final sp = await _pref;
    return sp.getString(key) ?? '';
  }

  @override
  Future<int> getInt(String key) async {
    final sp = await _pref;
    return sp.getInt(key) ?? -1;
  }

  @override
  void setInt(String key, int value) async {
    final sp = await _pref;
    await sp.setInt(key, value);
  }

  @override
  void remove(String key) async {
    final sp = await _pref;
    sp.remove(key);
  }

  @override
  Future<bool> getBool(String key) async {
    final sp = await _pref;
    return sp.getBool(key) ?? false;
  }

  @override
  void setBool(
    String key,
    bool value,
  ) async {
    final sp = await _pref;
    await sp.setBool(key, value);
  }

  @override
  Future<bool> containKey(String key) async {
    final sp = await _pref;
    return sp.containsKey(key);
  }

  @override
  Future<List<String>> getList(String key) async {
    final sp = await _pref;
    return sp.getStringList(key) ?? [];
  }

  @override
  void setList(String key, List<String> value) async {
    final sp = await _pref;
    await sp.setStringList(key, value);
  }

  @override
  Future<double> getDouble(String key) async {
    final sp = await _pref;
    return sp.getDouble(key) ?? 0;
  }

  @override
  void setDouble(String key, double value) async {
    final sp = await _pref;
    await sp.setDouble(key, value);
  }

  @override
  void clearAll() async {
    final sp = await _pref;
    await sp.clear();
  }
}
