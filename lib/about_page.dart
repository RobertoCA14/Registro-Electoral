import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
        backgroundColor: Colors.blue, // Color azul para la barra de la aplicación
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 150,
                backgroundImage: NetworkImage('https://elecciones2020.do/wp-content/uploads/2021/11/luis-abinader-1.jpg'),
                backgroundColor: Colors.white, // Fondo blanco para el avatar
              ),
              SizedBox(height: 16),
              Text(
                'Nombre Apellido',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue), // Texto en azul
              ),
              SizedBox(height: 8),
              Text(
                'Matrícula: 123456',
                style: TextStyle(color: Colors.blue), // Texto en azul
              ),
              SizedBox(height: 16),
              Text(
                'La democracia es el gobierno del pueblo, por el pueblo y para el pueblo.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue), // Texto en azul
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white, // Fondo blanco para la página
    );
  }
}

