
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
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
        title: const Text('Editar tarea'),
      ),
      body: FutureBuilder(
        future: _tareasProvider.getTareaId(taskId),
        builder: (BuildContext context, AsyncSnapshot<Tareas?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          }

          if (snapshot.data != null) {

            return _crearBody(snapshot.data);
            
          }

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
                FocusScope.of(context).requestFocus(FocusNode());

                final picked = await FechaUtil(context: context, dateSelected: _fechaSeleccionada).getObtenerFecha();

                //print('Fecha seleccionada: $picked');
                if (picked != null) {
                  _fechaSeleccionada = picked;
                  _myControllerFecha.text = DateFormat.yMMMMEEEEd('es_ES').format(_fechaSeleccionada);
                  
                  setState(() { });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 25.0,),

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
              onTag: (tag) {
                
                _listaTags.add(tag);
                print('Resultado de Tags: ${_listaTags.toString()}');

              },
              onDelete: (tag) {

                _listaTags.remove(tag);
                print('Tag eliminado: $tag');
                print('Resultado de Tags: ${_listaTags.toString()}');

              },
              validator: (tag){
                /* if(tag.length>15){
                  return "hey that's too long";
                }
                return null; */
              } 
            )
          ],
        ),
        const SizedBox(height: 15.0,),

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

                    ProgressDialog progressDialog = ProgressDialog(context, 
                      title:const Text("Eliminando"), 
                      message:const Text("Espera por favor...")
                    );
                    progressDialog.show();

                    final _respuesta = await _tareasProvider.setTareaIdEliminar('${tarea?.id}');
            
                    if (_respuesta['status'] != 200) { // Los datos fueron registrados
                      progressDialog.dismiss();
                      _cargarDatos();
            
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Notificación'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('${_respuesta['mensaje']}'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Aceptar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      
                    } else { // Problemas al registrar los datos
                      progressDialog.dismiss();
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Notificación'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('${_respuesta['mensaje']}'),
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
                  onPressed: () async {

                    ProgressDialog progressDialog = ProgressDialog(context, 
                      title:const Text("Guardando"), 
                      message:const Text("Espera por favor...")
                    );
                    progressDialog.show();
            
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
                      '${tarea?.id}' ,
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
                      progressDialog.dismiss();
                      _cargarDatos();
            
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Notificación'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('${_respuesta['mensaje']}'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Aceptar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      
                    } else { // Problemas al registrar los datos
                      progressDialog.dismiss();
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Notificación'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('${_respuesta['mensaje']}'),
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
                ),
              ),
            ),
          ],
        )
        
      ],
    );


  }
  
}