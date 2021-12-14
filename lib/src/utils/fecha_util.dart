
import 'package:flutter/material.dart';

class FechaUtil {

  BuildContext context;
  DateTime dateSelected;

  FechaUtil({
    required this.context,
    required this.dateSelected
  });

  // Creamos nuestro metodo obtener fecha el cual retornara un tipo de dato DateTime.
  // El método invoca a showDatePicker del paquete de Material para mostrar el calendario y seleccionar la fecha
  Future<DateTime?> getObtenerFecha() async {
    final DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: dateSelected,
      firstDate: DateTime.parse('1900-01-01'),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('es', 'ES')
    );

    return _picked;

  }

}