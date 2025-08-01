// lib/features/preload/presentation/loading_screen.dart

import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final dynamic city;
  const LoadingScreen({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Redirect vers home - LoadingScreen obsolète
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/');
    });

    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
