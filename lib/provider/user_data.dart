import 'package:flutter/material.dart';

import '../models/user/user_model.dart';

class UserData extends ChangeNotifier {
  Usuario _usuario;

  UserData(this._usuario);

  Usuario get usuario => _usuario;

  void setUsuario(Usuario usuario) {
    _usuario = usuario;
    notifyListeners();
  }
}
