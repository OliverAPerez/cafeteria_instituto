import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../components/navbar/custom_navbar.dart';
import '../../firestorelogic/perfil/profile_logic.dart';

class ProfilePage extends StatelessWidget {
  final User? user;

  const ProfilePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Perfil'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cerrar Sesión', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ProfileLogic(user: FirebaseAuth.instance.currentUser!), // Asegúrate de que este widget devuelva los botones que quieres mostrar
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),
    );
  }
}
