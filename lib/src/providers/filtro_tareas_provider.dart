
import 'package:flutter/cupertino.dart';

// Creamos una clase FiltroTareasProvider el cúal estara siendo herededa de ChangeNotifier
// esto con la finalida de mantener el estado de nuestro filtro a nivel padre
class FiltroTareasProvider extends ChangeNotifier {

  int _statusFiltro;

  FiltroTareasProvider(this._statusFiltro);

  int get filtro => _statusFiltro;

  void changeFintro(int statusFintro) {
    _statusFiltro = statusFintro;

    // Funcion de ChangeNotifier que permitira avistar a todos los widget hijos que hubo un cambio
    notifyListeners(); 
  }
  
}