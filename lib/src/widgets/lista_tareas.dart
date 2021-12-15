import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_tareas/src/models/tareas_model.dart';

class ListaTareas extends StatefulWidget {

  // Lista de tareas recuperadas
  List<Tareas>? data;

  // Filtro de tareas
  // 0 - Pendientes
  // 1 - Terminadas
  // 2 - Todas las tareas
  int filtroTareas;

  // Función
  Function onCallback;

  ListaTareas({Key? key, 
    required this.data,
    required this.filtroTareas,
    required this.onCallback
  }) : super(key: key);

  @override
  _ListaTareasState createState() => _ListaTareasState();
}

class _ListaTareasState extends State<ListaTareas> {

  var formatter = DateFormat.yMMMMEEEEd('es_ES');
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);


  @override
  Widget build(BuildContext context) {

    // Vamos a crear filtro de tareas
    if (widget.filtroTareas == 0) {

      for (var i = 0; i < widget.data!.length; i++) {
        widget.data!.removeWhere((element) => element.isCompleted == 1);
      }

    } else if (widget.filtroTareas == 1) {

      for (var i = 0; i < widget.data!.length; i++) {
        widget.data!.removeWhere((element) => element.isCompleted == 0);
      }

    } 


    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100.0),
      itemCount: widget.data?.length,
      itemBuilder: (BuildContext context, int index) {

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 0.0,
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            leading: Icon(Icons.article, color: widget.data![index].isCompleted == 1 ? Colors.green : null,),
            title: Text(widget.data![index].title!),
            //subtitle: Text(data[index].dueDate!),
            subtitle: Text(capitalize(formatter.format(DateTime.parse(widget.data![index].dueDate!)))),
            onTap: () {
              Navigator.pushNamed(context, '/editar-tarea', arguments: {
                'cargar_datos' : widget.onCallback,
                'task_id' : '${widget.data![index].id!}'
              });
            },
          ),
        );
        
      }
    
    );
  }
}