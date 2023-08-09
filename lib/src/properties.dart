import 'dart:collection';

/// Custom properties
class Properties {
  final _map = HashMap<String, dynamic>();

  Properties();

  /// Put a [value] using [name] inside a map.
  void putString(String name, {String? value}) {
    _map[name] = value;
  }

  /// Get a value from a map using a [name].
  String? getString(String name) {
    if (_map.containsKey(name)) {
      return _map[name] as String?;
    }

    return null;
  }

  /// Remove a single value using a [name].
  void removeString(String name) {
    _map.remove(name);
  }

  /// Remove all values
  void clear() {
    _map.clear();
  }

  Map<String, dynamic> toJson() => _map;
}
