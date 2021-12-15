import 'package:flutter/material.dart';

class MensajeErrorUtil {

  // Recibe como atributos dos parametros
  // el primero de tipo BuildContext y el segundo tipo String

  BuildContext context;
  String mensaje;

  MensajeErrorUtil({
    required this.context,
    required this.mensaje
  });


  // Creamos nuesto mensaje personalizado de Dialog para mostrar los error
  Future<void> showMensaje() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Notificación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(mensaje),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
}