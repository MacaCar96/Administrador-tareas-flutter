import 'package:admin_tareas/src/providers/filtro_tareas_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:admin_tareas/src/pages/error_page.dart';
import 'package:admin_tareas/src/routers/routers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FiltroTareasProvider(2),
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        title: 'Administrador de tareas',
        theme: ThemeData(
          //primarySwatch: ,
          primaryColor: const Color(0xFF34495E),
          scaffoldBackgroundColor: const Color(0xFFF2F3F4)
        ),
        routes: MyRouters().getApplicationRoutes(),
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => const ErrorPage()
          );
        },
      ),
    );
  }
}
