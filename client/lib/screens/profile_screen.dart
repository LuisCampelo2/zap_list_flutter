import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zap_list_flutter/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  ProfileScreen({super.key, required this.user});

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Usuário logado: ${user!.email}'),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              authService.logout();
            },
            child: const Text(
              'Sair da conta',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
