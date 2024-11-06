import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String profileImageUrl =
      'https://your-image-url.com/profile.jpg'; 
  final String name = 'Luis Naal Pacheco';
  final String email = 'luis@example.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Foto de perfil con borde circular
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(''),
              ),
              const SizedBox(height: 20),

              // Nombre del usuario
              Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Correo del usuario
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Botón para editar perfil
              ElevatedButton.icon(
                onPressed: () {
                  // Aquí puedes agregar la lógica para editar el perfil
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text('Editar perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}