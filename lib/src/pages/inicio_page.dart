
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admin_tareas/src/providers/filtro_tareas_provider.dart';
import 'package:admin_tareas/src/widgets/lista_tareas.dart';
import 'package:admin_tareas/src/widgets/menu_vertical.dart';
import 'package:admin_tareas/src/models/tareas_model.dart';
import 'package:admin_tareas/src/providers/tareas_provider.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);


  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {

  String tituloAppBar = 'Todas las tareas'; // Creamos una variable para guardar temporalmente el titulo de appBar

  // Variables para controlar el estado activo del item del menú
  bool _isTodas = true;
  bool _isTerminadas = false;
  bool _isPendientes = false;

  final _tareasProvider = TareasProvider(); // Instacia a las TareasProvider para acceder a los métodos de las consultas

  var formatter = DateFormat.yMMMMEEEEd('es_ES'); // Instancia de un formato de fecha
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1); // Método para poner la primera letra mayúscula de algún texto

  // Método para actualizar el item seleccionado del menú vertical
  void _activeMenu(bool todas, bool terminadas, bool pendientes) {
    _isTodas = todas;
    _isTerminadas = terminadas;
    _isPendientes = pendientes;
  }

  @override
  Widget build(BuildContext context) {

    final filtroTareas = Provider.of<FiltroTareasProvider>(context); // Creamos la instancia a nuestro provider de estado

    // Control de los filtros de la tarea
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
      body: FutureBuilder(
        future: _tareasProvider.getTareas(),
        builder: (BuildContext context, AsyncSnapshot<List<Tareas>> snapshot) {

          // Hasta que no haya data mostraremos CircularProgressIndicator con efecto de animación de que esta cargando la información
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          }

          if (snapshot.data!.length > 0) { // Si hay data comprobaremos de que no venga nula

            // Retornamos el Widget personalizado que hemos creado para la lista de tareas
            return ListaTareas(
              data: snapshot.data, // Lista de tareas
              filtroTareas: filtroTareas.filtro, // Filtro 
              onCallback: _cargarDatos, // Evento de mensaje y actulizacion de los datos registrados, eliminados y actualizados
            );
            
          }

          // Encaso de que la data venga nula mostraremos un mensaje
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
      ), 
    );
  }

  // Mensaje y actualización de los eventos de registro, actualizar y eliminar de las tareas
  void _cargarDatos(String mensaje) {
    Fluttertoast.showToast(
      msg: mensaje, 
      toastLength: Toast.LENGTH_LONG, 
      gravity: ToastGravity.BOTTOM, 
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5)
    );
    setState(() {});
  }

}