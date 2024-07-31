// ignore_for_file: use_build_context_synchronously

import 'package:buddy_guardian/provider/login_provider.dart';
import 'package:buddy_guardian/screens/login_and_register/login/login_page.dart';
import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: AppColors.lightColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        child: const Icon(
          Icons.logout,
          color: AppColors.darkColor,
        ),
        onPressed: () async {
          final confirm = await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: AppColors.darkColor,
              title: const Text(
                "Cerrar sesión",
                style: TextStyle(
                  fontFamily: "CB",
                  color: AppColors.orangeAcents,
                ),
                textAlign: TextAlign.center,
              ),
              content: const Text(
                "¿Estás seguro de que deseas cerrar sesión?",
                style: TextStyle(
                  fontFamily: "CM",
                  color: AppColors.lightColor,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      color: AppColors.blueColors,
                      splashColor: AppColors.orangeAcents,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        Navigator.of(context).pop(false); // No confirmado
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(
                          fontFamily: "CB",
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    MaterialButton(
                      color: AppColors.orangeAcents.withOpacity(0.8),
                      splashColor: AppColors.blueColors,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        Navigator.of(context).pop(true); // Confirmado
                      },
                      child: const Text(
                        "Sí",
                        style: TextStyle(
                          fontFamily: "CB",
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );

          if (confirm == true) {
            await Provider.of<LoginProvider>(context, listen: false)
                .logoutApp();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
        },
      ),
    );
  }
}
