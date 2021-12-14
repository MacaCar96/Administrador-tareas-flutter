
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_tareas/src/utils/variables_entorno_util.dart';
import 'package:admin_tareas/src/models/tareas_model.dart';


class TareasProvider {


  // Creamos un metodo para recuperar todas las tareas que retornara una lista de Tareas
  // el cual hara una función asyncrona hasta que obtengamos alguna respuesta de la API
  Future<List<Tareas>> getTareas() async {

    try {
      var _url = Uri.parse(VariableEntornoUtils.API_GET_TAREAS); // Preparamos la URL de la API

      // Ahora si hacemos uso del paquete http para hacer la petición http
      final _respuesta = await http.get(
        _url, // URL
        headers: { 'Authorization' : VariableEntornoUtils.HEADER_AUTHORIZATION }, // Headers
        //body: { 'token' : VariableEntornoUtils.TOKEN_PARAMS } // Params
      );

      // Ya obteniendo la consulta vamos a codificar la respuesta para convetirlo en un formato Map
      final _decodeData = json.decode(_respuesta.body);
      print(_decodeData);

      // Pasamos los datos tipo Map a nuestro Modelo de tareas para obtener un lista de objetos de tipo Tareas
      final _tareas = TareasModel.fromJsonListTareas(_decodeData);

      return _tareas.items; // Retornamos la lista de Tareas
    } catch (e) {

      return [];

    }
    
  }

  Future<Map<String, dynamic>> setTarea(Map<String, dynamic> dataBody) async {

    try {
      var _url = Uri.parse(VariableEntornoUtils.API_GET_TAREAS); // Preparamos la URL de la API

      // Ahora si hacemos uso del paquete http para hacer la petición http
      final _respuesta = await http.post(
        _url, // URL
        headers: { 
          'Authorization' : VariableEntornoUtils.HEADER_AUTHORIZATION,
          'Content-Type' : VariableEntornoUtils.HEADER_CONTENT_TYPE
        }, // Headers
        body: dataBody // Params
      );

      // Ya obteniendo la consulta vamos a codificar la respuesta para convetirlo en un formato Map
      final _decodeData = json.decode(_respuesta.body);
      print(_decodeData);

      Map<String, dynamic> _resultado;
      if (_decodeData['detail'] == 'Éxito al crear la tarea') {
        _resultado = {
          'status' : 100,
          'mensaje' : 'Éxito al crear la tarea'
        };
      } else {
        _resultado = {
          'status' : 200,
          'mensaje' : '${_decodeData['detail']}'
        };
      }

      return _resultado; // Retornamos el Map como respuesta
    } catch (e) {

      return {
        'status' : 200,
        'mensaje' : 'Error desconocido, intente más tarde.'
      };

    }
    
  }

  Future<Tareas?> getTareaId(String taskId) async {

    try {
      var _url = Uri.parse('${VariableEntornoUtils.API_GET_TAREA_ID}$taskId?token=${VariableEntornoUtils.TOKEN}'); // Preparamos la URL de la API
      print('URL: $_url');
      // Ahora si hacemos uso del paquete http para hacer la petición http
      final _respuesta = await http.get(
        _url, // URL
        headers: { 'Authorization' : VariableEntornoUtils.HEADER_AUTHORIZATION }, // Headers
        //body: { 'token' : VariableEntornoUtils.TOKEN_PARAMS } // Params
      );

      // Ya obteniendo la consulta vamos a codificar la respuesta para convetirlo en un formato Map
      final _decodeData = json.decode(_respuesta.body);
      print(_decodeData);

      // Pasamos los datos tipo Map a nuestro Modelo de tareas para obtener un lista de objetos de tipo Tareas
      final _tareas = Tareas.fromJsonMapTareasId(_decodeData[0]);

      return _tareas; // Retornamos la lista de Tareas
    } catch (e) {

      return null;

    }
    
  }

  Future<Map<String, dynamic>> setTareaIdActualizar(String taskId, Map<String, dynamic> dataBody) async {

    try {
      var _url = Uri.parse('${VariableEntornoUtils.API_PUT_TAREA_ID}$taskId'); // Preparamos la URL de la API

      // Ahora si hacemos uso del paquete http para hacer la petición http
      final _respuesta = await http.put(
        _url, // URL
        headers: { 
          'Authorization' : VariableEntornoUtils.HEADER_AUTHORIZATION,
          'Content-Type' : VariableEntornoUtils.HEADER_CONTENT_TYPE
        }, // Headers
        body: dataBody // Params
      );

      // Ya obteniendo la consulta vamos a codificar la respuesta para convetirlo en un formato Map
      final _decodeData = json.decode(_respuesta.body);
      print(_decodeData);

      Map<String, dynamic> _resultado;
      if (_decodeData['detail'] == 'Éxito al actualizar la tarea') {
        _resultado = {
          'status' : 100,
          'mensaje' : 'Éxito al actualizar la tarea'
        };
      } else {
        _resultado = {
          'status' : 200,
          'mensaje' : '${_decodeData['detail']}'
        };
      }

      return _resultado; // Retornamos el Map como respuesta
    } catch (e) {

      return {
        'status' : 200,
        'mensaje' : 'Error desconocido, intente más tarde.'
      };

    }
    
  }

  Future<Map<String, dynamic>> setTareaIdEliminar(String taskId) async {

    try {
      var _url = Uri.parse('${VariableEntornoUtils.API_PUT_TAREA_ID}$taskId'); // Preparamos la URL de la API

      // Ahora si hacemos uso del paquete http para hacer la petición http
      final _respuesta = await http.delete(
        _url, // URL
        headers: { 
          'Authorization' : VariableEntornoUtils.HEADER_AUTHORIZATION,
          'Content-Type' : VariableEntornoUtils.HEADER_CONTENT_TYPE
        }, // Headers
        body: { 'token' : VariableEntornoUtils.TOKEN } // Params
      );

      // Ya obteniendo la consulta vamos a codificar la respuesta para convetirlo en un formato Map
      final _decodeData = json.decode(_respuesta.body);
      print(_decodeData);

      Map<String, dynamic> _resultado;
      if (_decodeData['detail'] == 'Éxito al eliminar la tarea') {
        _resultado = {
          'status' : 100,
          'mensaje' : 'Éxito al eliminar la tarea'
        };
      } else {
        _resultado = {
          'status' : 200,
          'mensaje' : '${_decodeData['detail']}'
        };
      }

      return _resultado; // Retornamos el Map como respuesta
    } catch (e) {

      return {
        'status' : 200,
        'mensaje' : 'Error desconocido, intente más tarde.'
      };

    }
    
  }

}