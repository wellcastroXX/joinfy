// lib/main.dart
import 'package:flutter/material.dart';

// Tema
import 'package:joinfy/theme/app_theme.dart';

// Páginas (ajuste os caminhos conforme o seu projeto)
import 'package:joinfy/source/modules/pages/auth/register/register_page.dart';
import 'package:joinfy/source/modules/pages/auth/login/login_page.dart'; 
import 'package:joinfy/source/modules/pages/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) {
        return Theme(
          data: AppTheme.light(context),
          child: child!,
        );
      },
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,

      // Opção A: iniciar pela Login
      // initialRoute: '/login',

      // Opção B: manter 'home' na Register (como você já tinha)
      home: const RegisterPage(),

      routes: {
        '/login': (_) => const LoginPage(), // <— REGISTRADA
        '/register': (_) => const RegisterPage(),
        '/home_page': (_) => const HomePage(), 
      },

      // (opcional) fallback para evitar crash em rota desconhecida
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }
}
