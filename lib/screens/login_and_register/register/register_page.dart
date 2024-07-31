// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:buddy_guardian/provider/login_provider.dart';
import 'package:buddy_guardian/provider/register_provider.dart';
import 'package:buddy_guardian/screens/login_and_register/login/login_page.dart';
import 'package:buddy_guardian/services/local_storage.dart';
import 'package:buddy_guardian/services/push_notification_service.dart';
import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:buddy_guardian/utils/utils_snackbar.dart';
import 'package:buddy_guardian/validators/validator.dart';
import 'package:buddy_guardian/widgets/circularprogress_widget.dart';
import 'package:buddy_guardian/widgets/input_decoration_widget.dart';
import 'package:buddy_guardian/widgets/materialbuttom_widget.dart';
import 'package:buddy_guardian/widgets/upload_image_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? image;

  bool obscureText = true;
  bool isLoading = false;
  bool isLoadingGoogle = false;

  String? username;
  static String? token;
  int? i;

  @override
  void initState() {
    super.initState();
    token = PushNotificationService.token;
    //print("token: $token");
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  List<String> usernameSuggestions = [];

//ENVIAR REGISTRO
  void _submitForm() async {
    final registerProvider =
        Provider.of<RegisterProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    if (!formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    formKey.currentState!.save();

    //verificar que ingrese una imagen
    if (image == null) {
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, 'Selecciona una imagen de perfil');
      return;
    }

    //obtener el username del email que ingreso el usuario
    final username = emailController.text.split('@').first;

    // VALIDA SI EL USERNAME YA EXISTE EN LA BD
    bool usernameExists =
        await registerProvider.checkUsernameExistsRegister(username);
    if (usernameExists) {
      usernameSuggestions = generateUsernameSuggestions(username);
      showUsernameSuggestionsDialog(context);
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, 'El nombre de usuario se encuentra en uso');
      return;
    }

    // VALIDA SI EL EMAIL YA EXISTE EN LA BD
    bool emailExists =
        await registerProvider.checkEmailExists(emailController.text);
    if (emailExists) {
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, 'El email ya se encuentra en uso');
      return;
    }

    // Create user account
    try {
      await registerProvider.registerUser(
        username: username,
        email: emailController.text,
        password: passwordController.text,
        image: image,
        token: token!,
        rol: "user",
        onError: (errorMessage) {
          setState(() {
            isLoading = false;
            registerProvider.errorMessage = errorMessage;
          });
        },
      );
      // Enviar correo de verificación
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      setState(() {
        isLoading = false;
      });
      //showSnackbar(context, "Registro Exitoso, Verifica tu correo electrónico");
      dialogoDeConfirmacion(
        context,
        "Registro Exitoso",
        "Se ha enviado un correo de verificación a ${emailController.text}. Por favor, haz clic en el enlace de verificación en el correo para poder iniciar sesión.",
      );
    } catch (errorMessage) {
      setState(() {
        isLoading = false;
      });
      // Display error message
      showSnackbar(context,
          "El email ya existe o la contraseña es muy incorrecta, por favor intente con otro email o contraseña.");
    }
  }

//LISTA DE SUGERENCIAS DE NOMBRES DE USUARIOS
  List<String> generateUsernameSuggestions(String username) {
    final registerProvider =
        Provider.of<RegisterProvider>(context, listen: false);
    List<String> suggestions = [];
    int suffix1 = 1;
    int suffix2 = 1;
    // Utilizamos un conjunto para almacenar sugerencias únicas
    Set<String> uniqueSuggestions = <String>{};
    for (int i = 0; i < 3; i++) {
      String suggestedUsername =
          registerProvider.getNextUsername(username, suffix1);
      uniqueSuggestions.add(suggestedUsername);
      suffix1 += 2;

      if (i < 2) {
        String suggestedUsername2 =
            registerProvider.getNextUsername(username, suffix2);
        uniqueSuggestions.add(suggestedUsername2);
        suffix2 += 2;
      }
    }
    // Convertimos el conjunto a una lista para preservar el orden
    suggestions.addAll(uniqueSuggestions.toList());
    return suggestions;
  }

//SHOWDIALOGO PARA SUGERIR NOMBRES DE USUARIOS
  void showUsernameSuggestionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.darkColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 15,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Nombre de usuario ya registrado.',
                style: TextStyle(
                    color: AppColors.orangeAcents,
                    fontFamily: "CB",
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Estas son algunas sugerencias para tí',
                style: TextStyle(
                    color: AppColors.text, fontFamily: "CB", fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: usernameSuggestions.length,
              itemBuilder: (BuildContext context, int index) {
                String suggestion = usernameSuggestions[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.primaries[index],
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(
                        suggestion,
                        style: const TextStyle(
                            color: AppColors.text,
                            fontFamily: "CB",
                            letterSpacing: 0.5,
                            fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        // Cerrar el diálogo y devolver la sugerencia seleccionada
                        Navigator.of(context).pop(suggestion);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    ).then((selectedSuggestion) {
      if (selectedSuggestion != null) {
        // Actualiza el valor del controlador con la sugerencia seleccionada
        setState(() {
          username = selectedSuggestion;
        });
      }
    });
  }

  Future<void> _registerGoogle() async {
    final registerProvider =
        Provider.of<RegisterProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    setState(() {
      isLoadingGoogle = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        // El usuario se ha registrado correctamente

        // VALIDA SI EL EMAIL YA EXISTE EN LA BD
        bool emailExists = await registerProvider.checkEmailExists(user.email!);
        if (emailExists) {
          setState(() {
            isLoadingGoogle = false;
          });
          showSnackbar(context,
              'El email ya se encuentra en uso, por favor inicie sesión');
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          //navegar reemplazando la pila de rutas
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
          return;
        }

        //OBTENER FECHA Y HORA ACTUAL
        DateTime now = DateTime.now();

        // Create user account
        try {
          final userDatos = {
            'id': user.uid,
            'username': user.displayName!.replaceAll(' ', ''),
            'username_lowercase':
                user.displayName!.replaceAll(' ', '').toLowerCase(),
            'email': user.email!,
            'password': 'passwordPorDefecto',
            'imageUser': user.photoURL,
            'createdAt': now,
            'token': token!,
            'estado': true,
            'premium': false,
            'aprobado': false,
            'verificado': false,
            'favoritos': 0,
            'compartidos': 0,
            'seguidos': 0,
            'seguidores': 0,
            'favoritosJson': [],
            'compartidosJson': [],
            'seguidosJson': [],
            'seguidoresJson': [],
            'rol': "user",
          };

          print("userDatos: $userDatos");

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userDatos);

          // Obtener los datos del usuario desde la base de datos
          dynamic userData = await loginProvider.getUserData(user.email!);
          // Guardar datos del usuario en LocalStorage
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              '/game',
              arguments: {'userData': userData},
            );
          });
          //showSnackbar
          showSnackbar(context, "Bienvenido ${user.displayName}!");

          setState(() {
            isLoadingGoogle = false;
          });
        } catch (errorMessage) {
          setState(() {
            isLoadingGoogle = false;
          });
          // Display error message
          showSnackbar(context, errorMessage.toString());
        }
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoadingGoogle = false;
      });
    }
  }

  void selectedImage() async {
    image = await pickImageUser(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? WillPopScope(
            onWillPop: () async => false,
            child: const Scaffold(
              backgroundColor: AppColors.lightColor,
              body: Center(
                child: CircularProgressWidget(
                  text: "Registrando...",
                  color: AppColors.darkColor,
                ),
              ),
            ),
          )
        : buildWelcomePage(context);
  }

  Widget buildWelcomePage(BuildContext context) {
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
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  child: Form(
                    key: formKey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 15.0),
                        const Text(
                          "Bienvenido a\nBuddy Guardian.",
                          style: TextStyle(
                            color: AppColors.purpleColors,
                            fontSize: 18.0,
                            fontFamily: "IM",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15.0),
                        InkWell(
                          onTap: selectedImage,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: AppColors.purpleColors,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.purpleAcents,
                                width: 2,
                              ),
                            ),
                            child: image == null
                                ? const Icon(
                                    Icons.person,
                                    size: 100,
                                    color: AppColors.orangeAcents,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(19),
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        InputDecorationWidget(
                          labelText: "Ingrese su correo electrónico",
                          hintText: "quienlohace@gmail.com",
                          controller: emailController,
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
                        isLoading
                            ? const CircularProgressWidget(
                                text: "Registrando...",
                                color: AppColors.darkColor,
                              )
                            : MaterialButtomWidget(
                                margin: const EdgeInsets.all(0),
                                title: "Regístrate",
                                color: AppColors.pinkColors,
                                onPressed: () {
                                  _submitForm();
                                },
                              ),
                        const SizedBox(height: 15),
                        isLoadingGoogle
                            ? const CircularProgressWidget(
                                text: "Por favor, espere...",
                                color: AppColors.darkColor,
                              )
                            : InkWell(
                                onTap: () {
                                  _registerGoogle();
                                },
                                child: Card(
                                  elevation: 10,
                                  shadowColor: AppColors.purpleColors,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        "Regístrate con Google",
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
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "¿Ya tienes cuenta?",
                              style: TextStyle(
                                color: AppColors.purpleColors,
                                fontSize: 15.0,
                                fontFamily: "IM",
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Ingresa aquí",
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
            ),
          ),
        ],
      ),
    );
  }
}
