
import 'package:admin_tareas/src/pages/editar_tarea_page.dart';
import 'package:admin_tareas/src/pages/inicio_page.dart';
import 'package:admin_tareas/src/pages/nueva_tarea_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyRouters {
  
  Map<String, WidgetBuilder> getApplicationRoutes() {

      return <String, WidgetBuilder> {
        '/' : (BuildContext context) => const InicioPage(), // Página de inicio
        '/nueva-tarea' : (BuildContext context) => const NuevaTareaPage(), // Página de nueva tarea
        '/editar-tarea' : (BuildContext context) => const EditarTareaPage(), // Página de nueva tarea
      };
  }

}