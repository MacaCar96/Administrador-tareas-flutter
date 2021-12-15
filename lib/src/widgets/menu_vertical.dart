import 'package:admin_tareas/src/providers/filtro_tareas_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuVertical extends StatefulWidget {

  bool isTodas = true;
  bool isTerminadas = false;
  bool isPendientes = false;

  MenuVertical({ Key? key,
    required this.isTodas,
    required this.isTerminadas,
    required this.isPendientes
  }) : super(key: key);

  @override
  _MenuVerticalState createState() => _MenuVerticalState();
}

class _MenuVerticalState extends State<MenuVertical> {

  @override
  Widget build(BuildContext context) {

    final filtroTareas = Provider.of<FiltroTareasProvider>(context);
    
    return Drawer(
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
              color: widget.isTodas ? Colors.black12 : null,
              child: ListTile(
                leading: const Icon(Icons.all_inbox),
                title: const Text('Todas las tareas'),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  filtroTareas.changeFintro(2);
                },
              ),
            ),
            Ink(
              color: widget.isTerminadas ? Colors.black12 : null,
              child: ListTile(
                leading: const Icon(Icons.checklist_rtl_rounded),
                title: const Text('Terminadas'),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  filtroTareas.changeFintro(1);
                },
              ),
            ),
            Ink(
              color: widget.isPendientes ? Colors.black12 : null,
              child: ListTile(
                leading: const Icon(Icons.pending_actions_rounded),
                title: const Text('Pendientes'),
                dense: true,
                onTap: () {
                  Navigator.pop(context);
                  filtroTareas.changeFintro(0);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}