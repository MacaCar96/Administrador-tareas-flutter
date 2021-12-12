
import 'package:admin_tareas/src/providers/tareas_provider.dart';
import 'package:admin_tareas/src/utils/variables_entorno_utils.dart';
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class NuevaTareaPage extends StatefulWidget {
  const NuevaTareaPage({Key? key}) : super(key: key);


  @override
  _NuevaTareaPageState createState() => _NuevaTareaPageState();
}

class _NuevaTareaPageState extends State<NuevaTareaPage> {

  //late Map<String, dynamic> _arg;
  late Function _cargarDatos;

  final _tareasProvider = TareasProvider();

  bool _checkBoxCompleta = false;

  TextEditingController _myControllerTitulo = TextEditingController();
  TextEditingController _myControllerFecha = TextEditingController(); 
  TextEditingController _myControllerComentarios = TextEditingController(); 
  TextEditingController _myControllerDescripcion = TextEditingController(); 

  List<String> _listaTags = [];

  @override
  Widget build(BuildContext context) {

    var _arg = ModalRoute.of(context)?.settings.arguments;
    Map<String, dynamic>? m = _arg as Map<String, dynamic>?;

    _cargarDatos = m!['cargar_datos']; // cargamos los datos

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
        title: const Text('Nueva tarea'),
      ),
      body: _crearBody(),
    );
  }

  Widget _crearBody() {

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

        Container(
          //padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            padding: const EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            textColor: Colors.white,
            child: const Text('Registrar nueva tarea'),
            onPressed: () async {

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
              final _respuesta = await _tareasProvider.setTarea({
                'token' : VariableEntornoUtils.TOKEN_PARAMS,
                'title' : _myControllerTitulo.text,
                'is_completed' : _checkBoxCompleta ? '1' : '0',
                'due_date' : '2021-12-12', //_myControllerFecha.text
                'comments' : _myControllerComentarios.text,
                'description' : _myControllerDescripcion.text,
                'tags' : _tags
              });

              if (_respuesta['status'] != 200) { // Los datos fueron registrados

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
        )
        
      ],
    );


  }


}