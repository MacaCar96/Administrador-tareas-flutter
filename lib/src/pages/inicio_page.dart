
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_tareas/src/models/tareas_model.dart';
import 'package:admin_tareas/src/providers/tareas_provider.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);


  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {

  final _tareasProvider = TareasProvider();

  var formatter = DateFormat.yMMMMEEEEd('es_ES');
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0.0,
        title: const Text('Todas las tareas' ),
      ),
      drawer:  Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0))),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('Admin. de tareas', style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600
                      ), textAlign: TextAlign.center,),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {}, 
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(height: 0.0,),
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: _tareasProvider.getTareas(),
        builder: (BuildContext context, AsyncSnapshot<List<Tareas>> snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          }

          if (snapshot.data!.length > 0) {

            return _lista(snapshot.data);
            
          }

          return const Center(child: Text('No hay tareas pendientes'),);

          
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Agregar una nueva tarea',
        label: const Text('Nueva tarea'),
        icon: const Icon(Icons.add),
        onPressed: (){

          Navigator.pushNamed(context, '/nueva-tarea', arguments: {
            'cargar_datos' : _cargarDatos
          });
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _lista(List<Tareas>? data) {

    return ListView.builder(
      itemCount: data?.length,
      itemBuilder: (BuildContext context, int index) {

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 0.0,
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            leading: Icon(Icons.article, color: data![index].isCompleted == 1 ? Colors.green : null,),
            title: Text(data[index].title!),
            //subtitle: Text(data[index].dueDate!),
            subtitle: Text(capitalize(formatter.format(DateTime.parse(data[index].dueDate!)))),
            onTap: () {
              Navigator.pushNamed(context, '/editar-tarea', arguments: {
                'cargar_datos' : _cargarDatos,
                'task_id' : '${data[index].id!}'
              });
            },
          ),
        );
        
      }
    
    );

  }

  void _cargarDatos() {
    setState(() {});
  }

}