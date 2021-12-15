
import 'package:admin_tareas/src/providers/tareas_provider.dart';
import 'package:admin_tareas/src/utils/fecha_util.dart';
import 'package:admin_tareas/src/utils/mensaje_error_util.dart';
import 'package:admin_tareas/src/utils/variables_entorno_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:textfield_tags/textfield_tags.dart';

class NuevaTareaPage extends StatefulWidget {
  const NuevaTareaPage({Key? key}) : super(key: key);


  @override
  _NuevaTareaPageState createState() => _NuevaTareaPageState();
}

class _NuevaTareaPageState extends State<NuevaTareaPage> {

  final _tareasProvider = TareasProvider(); // Creamos la instancia de TareasProvider
  late Function _cargarDatos; // Creamos un objeto de tipo Funcion

  bool _checkBoxCompleta = false; // Creamos un objeto de tipo bool para manajer el estado de Checkbox de la tarea finalizada

  // Creamos todos los objetos de tipo TextEditingController
  // para nuetros TextField
  TextEditingController _myControllerTitulo = TextEditingController();
  TextEditingController _myControllerFecha = TextEditingController(); 
  TextEditingController _myControllerComentarios = TextEditingController(); 
  TextEditingController _myControllerDescripcion = TextEditingController(); 

  List<String> _listaTags = []; // Creamos una lista de tipo String para guardar los Tags

  DateTime _fechaSeleccionada = DateTime.now(); // Creamos una instancia para obtener la fecha actual

  @override
  void initState() {
    super.initState();

    // Inicializamos la fecha al día de hpy
    _myControllerFecha.text = DateFormat.yMMMMEEEEd('es_ES').format(_fechaSeleccionada);

  }

  @override
  Widget build(BuildContext context) {

    var _arg = ModalRoute.of(context)?.settings.arguments; // Recuperamos el objeto Map que envimos de la vista anterior
    Map<String, dynamic>? m = _arg as Map<String, dynamic>?; // El objeto recuperado lo guardamos en un nuevo objeto Map para poder acceder a sus datos

    _cargarDatos = m!['cargar_datos']; // Recuperamos la Funcion cargar_datos

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
        title: const Text('Nueva tarea'),
      ),
      body: _crearBody(), 
    );
  }

  Widget _crearBody() {
    return ListView(
      padding: const EdgeInsets.all(15.0),
      children: [
        
        // Campo del titulo
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

        // Campo de la fecha
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('Fecha:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
            ),
            TextField(
              enableInteractiveSelection: false,
              controller: _myControllerFecha,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                isDense: true,
                //hintText: 'dd/mm/yyyy',
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

        // Campo comentario
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
                contentPadding: EdgeInsets.all(8.0),
                isDense: true,
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
                contentPadding: EdgeInsets.all(8.0),
                isDense: true,
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
                tagDecoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                tagCancelIcon: Icon(Icons.cancel, size: 18.0, color: Colors.blue[900]),
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

        // Botón de registrar
        Container(
          //padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
          width: MediaQuery.of(context).size.width,
          child: OutlineButton(
            padding: const EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            textColor: Colors.blue,
            child: const Text('Registrar nueva tarea'),
            onPressed: () async => _onCallback() // Mandamos a llamar al metodo _onCallback 
          ),
        )
        
      ],
    );

  }

  void _onCallback() async {
    if (_myControllerTitulo.text.isEmpty) { // Validamos el campo del titulo
      return MensajeErrorUtil(context: context, mensaje: 'El campo del titulo es requerido.').showMensaje(); // Mostramos el mensaje de error
    }

    // Preparamos nuestros ProgressDialog para animar el progreso de la carga
    ProgressDialog progressDialog = ProgressDialog(context, 
      title:const Text("Creando"), 
      message:const Text("Espera por favor...")
    );

    progressDialog.show(); // Mostramos el ProgressDialog

    
    // Vamos a sacar todos los valores de nuestro arreglo de Tags
    // y los iremos concatenado cada unos de los Tags con una (,) de separador
    String _tags = '';
    for (var i = 0; i < _listaTags.length; i++) {
      if (i == 0) {
        _tags = _listaTags[i];
      } else {
        _tags = '$_tags,${_listaTags[i]}';
      }
    }

    // Preparando la consulta y enviado un Map como parametros de la peticon del API
    final _respuesta = await _tareasProvider.setTarea({
      'token' : VariableEntornoUtils.TOKEN,
      'title' : _myControllerTitulo.text,
      'is_completed' : _checkBoxCompleta ? '1' : '0',
      'due_date' : DateFormat('yyyy-MM-dd','es_ES').format(_fechaSeleccionada), //'2021-12-12', //_myControllerFecha.text
      'comments' : _myControllerComentarios.text,
      'description' : _myControllerDescripcion.text,
      'tags' : _tags
    });

    if (_respuesta['status'] != 200) { // Los datos fueron registrados
      progressDialog.dismiss(); // Terminamos la animacion del dialogo de carga
      _cargarDatos(_respuesta['mensaje']); // Ejecutamos el método de la vista de inicio
      Navigator.of(context).pop(); 

    } else { // Problemas al registrar los datos
      progressDialog.dismiss(); // Terminamos la animacion del dialogo de carga
      return MensajeErrorUtil(context: context, mensaje: _respuesta['mensaje']).showMensaje(); // Mostramos el mensaje de error
    }

  }


}