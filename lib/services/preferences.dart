import 'package:shared_preferences/shared_preferences.dart';
//Servicio encargado de gestionar preferencias del usuario
class PreferencesService {
  static const String _favoritesKey = 'favorites';
  
  //guardamos la lista
  Future<void> saveFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favorites);
  }

  //recuperamos la lista
  Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? ['si', 'no', 'duele', 'ayuda'];
  }
}