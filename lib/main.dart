import '../firebase_options.dart';
import '../firestorelogic/menu/firestore_logic.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/carrito/carrito_page.dart';
import 'pages/historialpedidos/historial_pedidos_page.dart';
import 'pages/historialrecargas/historial_recargas_page.dart';
import 'pages/login/authPage.dart';
import 'pages/menu/menu_page.dart';
import 'pages/modificarperfil/modificar_perfil_page.dart';
import 'pages/recargasaldo/recarga_saldo_page.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color.fromARGB(255, 58, 39, 39), // Color for Android
      statusBarBrightness: Brightness.dark, // Dark == white status bar -- for IOS.
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cafeteria App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 33, 104, 80),
            ),
            useMaterial3: true,
          ),
          // Define la ruta inicial
          initialRoute: '/',
          routes: {
            // Define la ruta para la pantalla de inicio de sesión
            '/': (context) => const AuthPage(),
            // Define la ruta para la pantalla de inicio
            '/home': (context) => MenuPage(category: 'alguna-categoria'),
            // Define la ruta para la página de carrito
            '/carrito': (context) => const CarritoPage(),
            // Define la ruta para la página de menú
            '/menu': (context) => const FirestoreMenu(category: 'alguna-categoria'),
            // Define la ruta para la página de recarga de saldo
            '/recargarSaldo': (context) => const RecargaSaldoPage(),
            // Define la ruta para la página de historial de pedidos
            '/historialPedidos': (context) => HistorialPedidosPage(user: FirebaseAuth.instance.currentUser!),

            // Define la ruta para la página de historial de recargas
            '/historialRecargas': (context) => const HistorialRecargasPage(),
            // Define la ruta para la página de modificar perfil
            '/modificarPerfil': (context) => const ModificarPerfilPage(),
          },
        );
      },
    );
  }
}
