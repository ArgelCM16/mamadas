import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _id = '';
  String _nombres = '';
  String _apellidos = '';
  String _correo = '';

  // Getters
  String get id => _id;
  String get nombres => _nombres;
  String get apellidos => _apellidos;
  String get correo => _correo;

  // Método para actualizar los datos del usuario
  void updateUser(String id, String nombre, String apellidos, String correo) {
    _id = id;
    _nombres = nombre;
    _apellidos = apellidos;
    _correo = correo;
    notifyListeners(); // Notifica a los widgets que los datos han cambiado
  }
}
