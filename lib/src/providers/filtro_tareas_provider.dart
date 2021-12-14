
import 'package:flutter/cupertino.dart';

class FiltroTareasProvider extends ChangeNotifier {

  int _statusFiltro;

  FiltroTareasProvider(this._statusFiltro);

  int get filtro => _statusFiltro;

  void changeFintro(int statusFintro) {
    _statusFiltro = statusFintro;

    notifyListeners();
  }
  
}