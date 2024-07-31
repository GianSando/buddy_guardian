// ignore_for_file: use_build_context_synchronously

import 'package:buddy_guardian/provider/login_provider.dart';
import 'package:buddy_guardian/screens/login_and_register/login/login_page.dart';
import 'package:buddy_guardian/screens/login_and_register/register/register_page.dart';
import 'package:buddy_guardian/services/local_storage.dart';
import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:buddy_guardian/utils/utils_snackbar.dart';
import 'package:buddy_guardian/widgets/circularprogress_widget.dart';
import 'package:buddy_guardian/widgets/materialbuttom_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkPreviousSession();
  }

  void checkPreviousSession() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final emailOrUserController = LocalStorage().getEmailOrUsername();
    final passwordController = LocalStorage().getPassword();
    setState(() {
      isLoading = true;
    });

    if (emailOrUserController.isEmpty || passwordController.isEmpty) {
      setState(() {
        isLoading = false;
      });
      // Si no existe emailOrUsername o password, mostrar al splash screen
      return;
    }

    // Obtener la referencia a la colección de users
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    // Obtener el usuario que coincida con el email o username
    final QuerySnapshot resultUsername = await users
        .where('username_lowercase',
            isEqualTo: emailOrUserController.toLowerCase())
        .limit(1)
        .get();

    final QuerySnapshot resultEmail = await users
        .where('email', isEqualTo: emailOrUserController.toLowerCase())
        .limit(1)
        .get();

    QuerySnapshot result = resultUsername;

    if (resultUsername.docs.isEmpty && resultEmail.docs.isNotEmpty) {
      result = resultEmail;
    }

    // Verificar si ya ha iniciado sesión
    final isLoggedIn = LocalStorage().getIsSignedIn();

    if (result.docs.isNotEmpty) {
      // Si existe el usuario, obtener el email
      final String email = result.docs.first.get('email');
      final UserCredential? userCredential =
          await loginProvider.loginUser(email, passwordController);
      final User? user = userCredential?.user;

      if (isLoggedIn != false && user != null) {
        // Verificar si el usuario ha iniciado sesión con Google
        final isGoogleUser = user.providerData
            .any((userInfo) => userInfo.providerId == 'google.com');

        if (isGoogleUser) {
          // El usuario ha iniciado sesión con Google
          dynamic userData = await loginProvider.getUserData(user.email!);
          Navigator.pushReplacementNamed(
            context,
            '/game',
            arguments: {'userData': userData},
          );
          showSnackbar(context, "Bienvenido de nuevo ${userData['username']}!");
          return;
        }
        // Si ya ha iniciado sesión, obtener datos del usuario y navegar a InicioPage
        // Obtener los datos del usuario desde la base de datos
        dynamic userData = await loginProvider.getUserData(user.email!);
        Navigator.pushReplacementNamed(
          context,
          '/game',
          arguments: {'userData': userData},
        );
        showSnackbar(context, "Bienvenido de nuevo ${userData['username']}!");
      } else {
        // Si no es la primera vez, navegar a LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressWidget(
                text: "Cargando...",
                color: AppColors.darkColor,
              ),
            )
          : Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/fondo2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkColor.withOpacity(0.7),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/splash.png',
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Salvemos nuestro planeta juntos!',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "IR",
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Jundo a Dash, el guardián del planeta, vamos a salvar el planeta de la contaminación.\n¿Estás listo para la aventura?',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "CM",
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MaterialButtomWidget(
                          margin: const EdgeInsets.symmetric(horizontal: 60.0),
                          title: "Empieza ya!",
                          color: AppColors.pinkColors,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '¿No tienes cuenta?',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "IR",
                                fontSize: 15,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Regístrate aquí',
                                style: TextStyle(
                                  color: AppColors.blueColors,
                                  fontFamily: "IB",
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
