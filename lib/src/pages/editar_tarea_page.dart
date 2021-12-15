
import 'package:admin_tareas/src/utils/mensaje_error_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:textfield_tags/textfield_tags.dart';

import 'package:admin_tareas/src/utils/fecha_util.dart';
import 'package:admin_tareas/src/models/tareas_model.dart';
import 'package:admin_tareas/src/providers/tareas_provider.dart';
import 'package:admin_tareas/src/utils/variables_entorno_util.dart';

class EditarTareaPage extends StatefulWidget {
  const EditarTareaPage({ Key? key }) : super(key: key);

  @override
  _EditarTareaPageState createState() => _EditarTareaPageState();
}

class _EditarTareaPageState extends State<EditarTareaPage> {

  final _tareasProvider = TareasProvider(); // Creamos la instancia de TareasProvider
  late Function _cargarDatos; // Creamos un objeto de tipo Funcion

  // Creamos todos los objetos de tipo TextEditingController
  // para nuetros TextField
  TextEditingController _myControllerTitulo = TextEditingController();
  TextEditingController _myControllerFecha = TextEditingController(); 
  TextEditingController _myControllerComentarios = TextEditingController(); 
  TextEditingController _myControllerDescripcion = TextEditingController(); 

  String taskId = ''; // Creamos objeto de tipo String para guardar el task_id
  bool _checkBoxCompleta = false; // Creamos un objeto de tipo bool para manajer el estado de Checkbox de la tarea finalizada
  
  List<String> _listaTags = []; // Creamos una lista de tipo String para guardar los Tags
  DateTime _fechaSeleccionada = DateTime.now(); // Creamos una instancia para obtener la fecha actual
  bool _statusInformacionRecuperada = false; // Creamos un objeto de tipo bool para manejar el estado de la información recuperada
  
  @override
  Widget build(BuildContext context) {

    var _arg = ModalRoute.of(context)?.settings.arguments; // Recuperamos el objeto Map que envimos de la vista anterior
    Map<String, dynamic>? m = _arg as Map<String, dynamic>?; // El objeto recuperado lo guardamos en un nuevo objeto Map para poder acceder a sus datos

    _cargarDatos = m!['cargar_datos']; // Recuperamos la Funcion cargar_datos
    taskId = m['task_id']; // Recuperamos el task_id

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton( // Personalizamos el icono de regresar por el icono de close(X)
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context), 
        ),
        title: const Text('Editar tarea'),
      ),
      body: FutureBuilder( // Utilizaremos FutureBuilder para recuperar la información de la API
        future: _tareasProvider.getTareaId(taskId),
        builder: (BuildContext context, AsyncSnapshot<Tareas?> snapshot) {

          // Hasta que no haya data mostraremos CircularProgressIndicator con efecto de animación de que esta cargando la información
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          }

          // Si hay data comprobaremos de que no venga nula
          if (snapshot.data != null) {
            return _crearBody(snapshot.data);
          }

          // Encaso de que la data venga nula mostraremos un mensaje
          return const Center(child: Text('Al parecer hubo un error a la hora de cargar los datos'),);
        }
      ),
    );
  }

  Widget _crearBody(Tareas? tarea) {
  
    // Validamos la carga de información recuperada
    if (!_statusInformacionRecuperada) {

      // Rellenamos los campos con la informació recuperada
      _myControllerTitulo.text = tarea!.title!;

      _fechaSeleccionada = DateTime.parse(tarea.dueDate!);
      _myControllerFecha.text = DateFormat.yMMMMEEEEd('es_ES').format(DateTime.parse(tarea.dueDate!));

       _myControllerComentarios.text = tarea.comments!;
      _myControllerDescripcion.text = tarea.description!;
      _listaTags = tarea.tags!.split(',');
      _checkBoxCompleta = tarea.isCompleted == 1 ? true : false;

      _statusInformacionRecuperada = true;

    }
    

    return ListView(
      padding: const EdgeInsets.all(15.0),
      children: [
        
        // Campo titulo
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('Titulo:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _myControllerTitulo,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                isDense: true,
                //labelText: 'Titulo',
              ),
            ),
          ],
        ),
        const SizedBox(height: 25.0,),

        // Campo fecha
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('Fecha:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
            ),
            TextField(
              controller: _myControllerFecha,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                isDense: true,
                //labelText: 'Fecha',
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode()); // Anulamos la salida del techado

                // Abrimos el calendario con la funcion de FechaUtil que creamos para obtener la fecha seleccionada
                final picked = await FechaUtil(context: context, dateSelected: _fechaSeleccionada).getObtenerFecha();

                if (picked != null) { // Comprobamos de que se haya seleccionado alguna fecha
                  _fechaSeleccionada = picked;
                  _myControllerFecha.text = DateFormat.yMMMMEEEEd('es_ES').format(_fechaSeleccionada); // Pasamos la fecha seleccionada al campo fecha
                  
                  setState(() { });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 25.0,),

        // Campo comentarios
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('Comentarios:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 5.0,),
            TextField(
              controller: _myControllerComentarios,
              maxLines: 2,
              decoration: const InputDecoration(
                fillColor: Color(0xFFE5E7E9),
                filled: true,
                //border: InputBorder.none,
                contentPadding: EdgeInsets.all(8.0),
                isDense: true,
                //disabledBorder: InputBorder.none
              ),
            ),
          ],
        ),
        const SizedBox(height: 25.0,),

        // Campo descripción
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('Descripción:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 5.0,),
            TextField(
              controller: _myControllerDescripcion,
              maxLines: 2,
              decoration: const InputDecoration(
                fillColor: Color(0xFFE5E7E9),
                filled: true,
                //border: InputBorder.none,
                contentPadding: EdgeInsets.all(8.0),
                isDense: true,
                //disabledBorder: InputBorder.none
              ),
            ),
          ],
        ),
        const SizedBox(height: 25.0,),

        // Campo de tags
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('Tags:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 5.0,),
            TextFieldTags(
              initialTags: _listaTags,
              tagsStyler: TagsStyler(
                tagTextStyle: const TextStyle(fontWeight: FontWeight.normal),
                //tagDecoration: BoxDecoration(color: Colors.blue[300], borderRadius: BorderRadius.circular(0.0), ),
                tagDecoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                //tagCancelIconPadding: const EdgeInsets.all(0.0),
                tagCancelIcon: Icon(Icons.cancel, size: 18.0, color: Colors.blue[900]),
                //tagPadding: const EdgeInsets.all(4.0)
                tagPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              ),
              textFieldStyler: TextFieldStyler(
                helperText: 'Introducir etiquetas',
                hintText: '¿Tiene etiquetas?',
                textFieldBorder: const UnderlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              ),
              onTag: (tag) { _listaTags.add(tag); }, // Recuperamos el nuevo tag
              onDelete: (tag) { _listaTags.remove(tag); }, // Eliminamos el tag de la lista
            )
          ],
        ),
        const SizedBox(height: 15.0,),

        // Campo de tarea terminada
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('Tarea terminada',  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w300)),
          value: _checkBoxCompleta, 
          onChanged: (value) {
            setState(() {
              _checkBoxCompleta = value!;
            });
          }
        ),
        const SizedBox(height: 25.0,),

        // Botón de eliminar tarea
        Row(
          children: [
            Expanded(
              child: Container(
                //padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                //width: MediaQuery.of(context).size.width,
                child: OutlineButton(
                  padding: const EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  highlightedBorderColor: Colors.red,
                  textColor: Colors.red,
                  child: const Text('Eliminar'),
                  onPressed: () async {

                    // Mandamos un mensaje de confirmación antes de eliminar la tarea
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          title: const Text('Notificación'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const <Widget>[
                                Text('¿Esta seguro de eliminar la tarea?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancelar', style: TextStyle(color: Colors.black38),),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Confirmar', style: TextStyle(color: Colors.red),),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _onCallbackConfirmacionEliminar('${tarea?.id}');
                              },
                            ),
                          ],
                        );
                      },
                    );
            
                  }
                ),
              ),
            ),
            const SizedBox(width: 15.0,),
            Expanded(
              child: Container(
                //padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                //width: MediaQuery.of(context).size.width,
                child: OutlineButton(
                  padding: const EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  textColor: Colors.blue,
                  child: const Text('Guardar'),
                  onPressed: () async => _onCallbackGuardar('${tarea?.id}')
                ),
              ),
            ),
          ],
        )
        
      ],
    );

  }

  void _onCallbackGuardar(String id) async {
    if (_myControllerTitulo.text.isEmpty) { // Validamos el campo del titulo
      return MensajeErrorUtil(context: context, mensaje: 'El campo del titulo es requerido.').showMensaje(); // Mostramos el mensaje de error
    }

    // Preparamos nuestros ProgressDialog para animar el progreso de la carga
    ProgressDialog progressDialog = ProgressDialog(context, 
      title:const Text("Guardando"), 
      message:const Text("Espera por favor...")
    );

    progressDialog.show(); // Mostramos el ProgressDialog

    // Vamos a sacar todos los valores de nuestro arreglo de Tags
    // y los iremos concatenado cada unos de los Tags con una (,) de separador
    String _tags = '';
    for (var i = 0; i < _listaTags.length; i++) {
      if (i == 0) {
        _tags = '${_listaTags[i]}';
      } else {
        _tags = '$_tags,${_listaTags[i]}';
      }
    }

    // Preparando la consulta y enviado un Map como parametros de la peticon del API
    final _respuesta = await _tareasProvider.setTareaIdActualizar(
      id ,
      {
        'token' : VariableEntornoUtils.TOKEN,
        'title' : _myControllerTitulo.text,
        'is_completed' : _checkBoxCompleta ? '1' : '0',
        'due_date' : DateFormat('yyyy-MM-dd','es_ES').format(_fechaSeleccionada),
        'comments' : _myControllerComentarios.text,
        'description' : _myControllerDescripcion.text,
        'tags' : _tags
      }
    );

    if (_respuesta['status'] != 200) { // Los datos fueron registrados
      progressDialog.dismiss(); // Terminamos la animacion del dialogo de carga
      _cargarDatos(_respuesta['mensaje']); // Ejecutamos el método de la vista de inicio
      Navigator.of(context).pop(); 

    } else { // Problemas al registrar los datos
      progressDialog.dismiss(); // Terminamos la animacion del dialogo de carga
      return MensajeErrorUtil(context: context, mensaje: _respuesta['mensaje']).showMensaje(); // Mostramos el mensaje de error
      
    }
  }

  void _onCallbackConfirmacionEliminar(String id) async {

    // Preparamos nuestros ProgressDialog para animar el progreso de la carga
    ProgressDialog progressDialog = ProgressDialog(context, 
      title:const Text("Eliminando"), 
      message:const Text("Espera por favor...")
    );

    progressDialog.show(); // Mostramos el ProgressDialog

    // Preparamos la consulta y esperamos el resultado
    final _respuesta = await _tareasProvider.setTareaIdEliminar(id);

    if (_respuesta['status'] != 200) { // La tarea fue eliminada con éxito
      progressDialog.dismiss(); // Terminamos la animacion del dialogo de carga
      _cargarDatos(_respuesta['mensaje']); // Ejecutamos el método de la vista de inicio
      Navigator.pop(context);
      
      
    } else { // Problemas al eliminar los datos
      progressDialog.dismiss(); // Terminamos la animacion del dialogo de carga
      return MensajeErrorUtil(context: context, mensaje: _respuesta['mensaje']).showMensaje(); // Mostramos el mensaje de error
    }
  }
  
}