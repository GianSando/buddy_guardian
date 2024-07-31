// ignore_for_file: use_build_context_synchronously

import 'package:buddy_guardian/provider/login_provider.dart';
import 'package:buddy_guardian/screens/login_and_register/register/register_page.dart';
import 'package:buddy_guardian/services/local_storage.dart';
import 'package:buddy_guardian/services/push_notification_service.dart';
import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:buddy_guardian/utils/utils_snackbar.dart';
import 'package:buddy_guardian/validators/validator.dart';
import 'package:buddy_guardian/widgets/circularprogress_widget.dart';
import 'package:buddy_guardian/widgets/input_decoration_widget.dart';
import 'package:buddy_guardian/widgets/materialbuttom_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailOrUserController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscureText = true;
  bool isLoading = false;
  bool isLoadingGoogle = false;

  static String? token;

  @override
  void initState() {
    super.initState();
    // en LocalStorage para mostrarlos en los campos de texto
    emailOrUserController.text = LocalStorage().getEmailOrUsername();
    passwordController.text = LocalStorage().getPassword();
    token = PushNotificationService.token;
  }

  void onFormSubmit() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    if (!formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });
    // Cerrar el teclado
    FocusScope.of(context).unfocus();
    // Obtener la referencia a la colección de usuarios
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    // Obtener el usuario que coincida con el email o nombre de usuario
    final QuerySnapshot resultUsername = await users
        .where('username_lowercase',
            isEqualTo: emailOrUserController.text.toLowerCase())
        .limit(1)
        .get();

    final QuerySnapshot resultEmail = await users
        .where('email', isEqualTo: emailOrUserController.text.toLowerCase())
        .limit(1)
        .get();

    QuerySnapshot result = resultUsername;

    if (resultUsername.docs.isEmpty && resultEmail.docs.isNotEmpty) {
      result = resultEmail;
    }

    if (result.docs.isNotEmpty) {
      // Si existe el usuario, obtener el email
      //final String email = result.docs.first.get('email');
      try {
        // Iniciar sesión con el email y la contraseña
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailOrUserController.text,
          password: passwordController.text,
        );
        // Obtener el usuario actual
        final User? user = FirebaseAuth.instance.currentUser;
        // Si el usuario es diferente de null
        if (user != null) {
          // Verificar si el usuario ha verificado su correo electrónico
          if (!user.emailVerified) {
            // Si el usuario no ha verificado su correo electrónico, mostrar un mensaje de error
            showSnackbar(context, "Por favor, verifica tu correo electrónico");
            setState(() {
              isLoading = false;
            });
            return;
          }

          // Obtener el token del dispositivo
          token = PushNotificationService.token;
          // Actualizar el token del usuario
          await users.doc(user.uid).update({'token': token});

          // Obtener los datos del usuario desde la base de datos
          dynamic userData = await loginProvider.getUserData(user.email!);
          // Guardar datos del usuario en LocalStorage
          await LocalStorage().saveUserData(
              emailOrUserController.text, passwordController.text);
          // Guardar el estado de inicio de sesión en LocalStorage
          await LocalStorage().setIsSignedIn(true);

          // Cambiar el estado de la autenticación
          loginProvider.checkAuthStatus();
          // Navegar a la página de inicio
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              '/game',
              arguments: {'userData': userData},
            );
          });
        }
      } catch (e) {
        // Si hay un error al iniciar sesión, mostrar un mensaje de error
        showSnackbar(context, "Contraseña incorrecta");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Si no existe el usuario, mostrar un mensaje de error
      showSnackbar(context, "El usuario no existe, registrate.");
      setState(() {
        isLoading = false;
      });
    }
  }

  //autenticación con google
  void signInWithGoogle() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    setState(() {
      isLoadingGoogle = true;
    });
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          // Verificar si el usuario ha verificado su correo electrónico
          if (!user.emailVerified) {
            // Si el usuario no ha verificado su correo electrónico, mostrar un mensaje de error
            showSnackbar(context, "Por favor, verifica tu correo electrónico");
            setState(() {
              isLoadingGoogle = false;
            });
            return;
          }

          // Obtener los datos del usuario desde la base de datos
          dynamic userData = await loginProvider.getUserData(user.email!);

          if (userData == null) {
            // No se encontró ningún usuario con el correo electrónico proporcionado.
            showSnackbar(context, "Correo no registrado");
            // Sign out from Firebase and Google
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            setState(() {
              isLoadingGoogle = false;
            });
            return;
          } else {
            //PROCEDE SI ES CORRECTO

            // Obtener el token del dispositivo
            token = PushNotificationService.token;
            // Actualizar el token del usuario
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'token': token});

            showSnackbar(context, "Bienvenido ${userData['username']}");

            //obtener email
            final String email = userData['email'];
            //obtener password
            final String password = userData['password'];
            // Guardar datos del usuario en LocalStorage
            await LocalStorage().saveUserData(email, password);

            // Guardar el estado de inicio de sesión en LocalStorage
            await LocalStorage().setIsSignedIn(true);

            // Cambiar el estado de la autenticación
            loginProvider.checkAuthStatus();
            // Navegar a la página de inicio
            Navigator.pushReplacementNamed(
              context,
              '/game',
              arguments: {'userData': userData},
            );
            //fin de proceso
            setState(() {
              isLoadingGoogle = false;
            });
          }
        }
      }
    } catch (e) {
      //print("Error al iniciar sesión con Google: $e");
      showSnackbar(context, "Error al iniciar sesión con Google");
      setState(() {
        isLoadingGoogle = false;
      });
    } finally {
      setState(() {
        isLoadingGoogle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    //margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: const BoxDecoration(
                      color: AppColors.text,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 15.0),
                            const Text(
                              "Bienvenido a\nBuddy Guardian.",
                              style: TextStyle(
                                color: AppColors.purpleColors,
                                fontSize: 20.0,
                                fontFamily: "IM",
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20.0),
                            InputDecorationWidget(
                              labelText: "Ingresa tu email",
                              hintText: "quienlohace@gmail.com",
                              controller: emailOrUserController,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.emailUsernameValidator,
                              suffixIcon: const Icon(
                                Icons.email_outlined,
                                color: AppColors.blueColors,
                              ),
                            ),
                            const SizedBox(height: 15),
                            InputDecorationWidget(
                              labelText: "Contraseña",
                              hintText: "********",
                              controller: passwordController,
                              obscureText: obscureText,
                              maxLines: 1,
                              validator: Validators.validatePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.blueColors,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            isLoadingGoogle
                                ? const CircularProgressWidget(
                                    text: "Por favor, Espere...",
                                    color: AppColors.darkColor,
                                  )
                                : InkWell(
                                    onTap: signInWithGoogle,
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      elevation: 10,
                                      shadowColor: AppColors.purpleColors,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Image.asset(
                                              'assets/icons/google.png',
                                              height: 40,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            "Inicia con Google",
                                            style: TextStyle(
                                              color: AppColors.purpleColors,
                                              fontSize: 15.0,
                                              fontFamily: "IB",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 15),
                            isLoading
                                ? const CircularProgressWidget(
                                    text: "Validando...",
                                    color: AppColors.darkColor,
                                  )
                                : MaterialButtomWidget(
                                    title: "Ingresar",
                                    color: AppColors.pinkColors,
                                    onPressed: onFormSubmit,
                                  ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "¿No tienes cuenta?",
                                  style: TextStyle(
                                    color: AppColors.purpleColors,
                                    fontSize: 14.0,
                                    fontFamily: "IM",
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    //navega reemplazando la página actual por la nueva
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Regístrate",
                                    style: TextStyle(
                                      color: AppColors.blueColors,
                                      fontSize: 15.0,
                                      fontFamily: "IB",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
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
