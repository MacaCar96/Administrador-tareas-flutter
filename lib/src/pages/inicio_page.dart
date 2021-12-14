
import 'package:admin_tareas/src/providers/filtro_tareas_provider.dart';
import 'package:admin_tareas/src/widgets/lista_tareas.dart';
import 'package:admin_tareas/src/widgets/menu_vertical.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_tareas/src/models/tareas_model.dart';
import 'package:admin_tareas/src/providers/tareas_provider.dart';
import 'package:provider/provider.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);


  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {

  String tituloAppBar = 'Todas las tareas';
  bool _isTodas = true;
  bool _isTerminadas = false;
  bool _isPendientes = false;

  final _tareasProvider = TareasProvider();

  var formatter = DateFormat.yMMMMEEEEd('es_ES');
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void _activeMenu(bool todas, bool terminadas, bool pendientes) {
    _isTodas = todas;
    _isTerminadas = terminadas;
    _isPendientes = pendientes;
  }

  @override
  Widget build(BuildContext context) {

    final filtroTareas = Provider.of<FiltroTareasProvider>(context);

    if (filtroTareas.filtro == 0) {
      tituloAppBar = 'Pendientes';
      _activeMenu(false, false, true);
    } else if (filtroTareas.filtro == 1) {
      tituloAppBar = 'Terminadas';
      _activeMenu(false, true, false);
    } else {
      tituloAppBar = 'Todas las tareas';
      _activeMenu(true, false, false);
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0.0,
        title: Text(tituloAppBar),
      ),
      drawer: MenuVertical(isTodas: _isTodas, isTerminadas: _isTerminadas, isPendientes: _isPendientes,),
      /* drawer:  Drawer(
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
              ),
              const SizedBox(height: 15.0,),
              Ink(
                child: ListTile(
                  leading: const Icon(Icons.all_inbox),
                  title: const Text('Todas las tareas'),
                  dense: true,
                  onTap: () {},
                ),
              ),
              Ink(
                child: ListTile(
                  leading: const Icon(Icons.checklist_rtl_rounded),
                  title: const Text('Terminadas'),
                  dense: true,
                  onTap: () {},
                ),
              ),
              Ink(
                child: ListTile(
                  leading: const Icon(Icons.pending_actions_rounded),
                  title: const Text('Perndientes'),
                  dense: true,
                  onTap: () {},
                ),
              )
            ],
          ),
        ),
      ), */
      body: FutureBuilder(
        future: _tareasProvider.getTareas(),
        builder: (BuildContext context, AsyncSnapshot<List<Tareas>> snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          }

          if (snapshot.data!.length > 0) {

            //return _lista(snapshot.data);
            return ListaTareas(
              data: snapshot.data, 
              filtroTareas: filtroTareas.filtro,
              onCallback: _cargarDatos,
            );
            
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
      padding: const EdgeInsets.only(bottom: 100.0),
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