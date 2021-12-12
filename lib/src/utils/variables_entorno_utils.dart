
class VariableEntornoUtils {

  // Token de Heaers Authorization
  static String HEADER_AUTHORIZATION = 'Bearer e864a0c9eda63181d7d65bc73e61e3dc6b74ef9b82f7049f1fc7d9fc8f29706025bd271d1ee1822b15d654a84e1a0997b973a46f923cc9977b3fcbb064179ecd';
  static String HEADER_CONTENT_TYPE = 'application/x-www-form-urlencoded';
  static String TOKEN_PARAMS = 'macacar96';

  static String API_DOMINIO = 'https://ecsdevapi.nextline.mx'; // API nombre del dominio

  static String API_GET_TAREAS = '$API_DOMINIO/vdev/tasks-challenge/tasks?token=$TOKEN_PARAMS'; // API mostrar todas las tareas
  static String API_GET_TAREA_ID = '$API_DOMINIO/vdev/tasks-challenge/tasks/'; // API mostrar la información de una sola tarea
  static String API_POST_TAREA_CREATE = '$API_DOMINIO/vdev/tasks-challenge/tasks?token=$TOKEN_PARAMS'; // API para crear una nueva tarea

}