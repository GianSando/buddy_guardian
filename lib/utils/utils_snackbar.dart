import 'dart:convert';

import 'package:buddy_guardian/screens/login_and_register/login/login_page.dart';
import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.lightColor,
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.darkColor,
            fontFamily: "CB",
          ),
        ),
      ),
    );
  }
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.orangeAcents,
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.text,
          fontFamily: "CB",
        ),
      ),
    ),
  );
}

Future<dynamic> dialogoDeConfirmacion(
  BuildContext context,
  String title,
  String description,
) {
  return showDialog(
    context: context,
    builder: (_) => WillPopScope(
      onWillPop: () async {
        // Redirigir al usuario a la página de inicio de sesión al presionar "Atrás"
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false, // Nunca permite volver atrás
        );
        return false; // Impedir el cierre del diálogo
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.darkColor,
        title: Text(
          title,
          style:
              const TextStyle(fontFamily: "CB", color: AppColors.orangeAcents),
          textAlign: TextAlign.center,
        ),
        content: Text(
          description,
          style: const TextStyle(fontFamily: "CM", color: AppColors.text),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: MaterialButton(
              color: AppColors.blueColors,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                //navegar reemplazando la pila de rutas
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false, // Nunca permite volver atrás
                );
              },
              child: const Text(
                "Aceptar",
                style: TextStyle(fontFamily: "CB", color: AppColors.darkColor),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<List<dynamic>> cargarJson() async {
  String datos = await rootBundle.loadString('assets/json/categorias.json');
  return jsonDecode(datos);
}
