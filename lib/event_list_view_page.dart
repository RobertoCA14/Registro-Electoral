import 'package:flutter/material.dart';
import 'dart:io';
import 'event.dart';
import 'database_helper.dart';

class EventListViewPage extends StatefulWidget {
  @override
  _EventListViewPageState createState() => _EventListViewPageState();
}

class _EventListViewPageState extends State<EventListViewPage> {
  late List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final dbEvents = await DatabaseHelper.instance.getEvents();
    setState(() {
      events = dbEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Eventos'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.title),
            subtitle: Text(event.date),
            leading: event.imagePath != null
                ? SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.file(File(event.imagePath!), fit: BoxFit.cover),
                  )
                : null,
            trailing: IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                // Aquí puedes manejar la lógica para reproducir el audio
              },
            ),
            onTap: () {
              // Aquí puedes manejar la lógica para abrir la pantalla de detalles del evento
            },
          );
        },
      ),
    );
  }
}

