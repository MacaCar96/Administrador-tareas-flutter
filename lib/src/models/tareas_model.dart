
class TareasModel {

  List<Tareas> items = [];

  TareasModel();

  TareasModel.fromJsonListTareas(List<dynamic>? jsonList) {
    if (jsonList == null) return;

    for (var i = 0; i < jsonList.length; i++) {
      final tareas = Tareas.fromJsonMapTareas(jsonList[i]);
      items.add(tareas);
    }

  }

}

// Creamos nuestra clase de tareas que nos ayudara a mantener guardados temporalmente los datos 
// que traigan las API
class Tareas {

  int? id;
  String? title;
  int? isCompleted;
  String? dueDate;
  String? comments;
  String? description;
  String? tags;
  String? token;
  String? createdAt;
  String? updatedAt;

  Tareas({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.dueDate,
    this.comments,
    this.description,
    this.tags,
    this.token,
    this.createdAt,
    this.updatedAt
  });

  Tareas.fromJsonMapTareas(Map<String, dynamic> json) {
    id            = json['id'];
    title         = json['title'];
    isCompleted   = json['is_completed'];
    dueDate       = json['due_date'];
    comments      = '';
    description   = '';
    tags          = '';
    token         = '';
    createdAt     = '';
    updatedAt     = '';
  }

  Tareas.fromJsonMapTareasId(Map<String, dynamic> json) {
    id            = json['id'];
    title         = json['title'];
    isCompleted   = json['is_completed'];
    dueDate       = json['due_date'];
    comments      = json['comments'];
    description   = json['description'];
    tags          = json['tags'];
    token         = json['token'];
    createdAt     = json['created_at'];
    updatedAt     = json['updated_at'];
  }

}