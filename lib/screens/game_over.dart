import 'package:buddy_guardian/game/flappy_game.dart';
import 'package:buddy_guardian/screens/ranking/ranking_page.dart';
import 'package:buddy_guardian/utils/utils_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatefulWidget {
  final dynamic userData;
  final FlappyBirdGame game;

  const GameOverScreen({super.key, required this.game, this.userData});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();



  @override
  void initState() {
    super.initState();
  
  }

  Future<void> saveScore(int score, BuildContext context) async {
    if (score == 0) {
      return;
    }

    final firestoreInstance = FirebaseFirestore.instance;

    // Referencia a la colección
    final collection = firestoreInstance.collection('ranking');

    // Buscar el documento del usuario
    final querySnapshot = await collection
        .where('username', isEqualTo: widget.userData['username'])
        .get();
    try {
      if (querySnapshot.docs.isEmpty) {
        // El usuario no existe, crear un nuevo documento
        final id = collection.doc().id;

        final datos = {
          'id': id,
          'id_usuario': widget.userData['id'],
          'username': widget.userData['username'],
          'imageUser': widget.userData['imageUser'],
          'createdAt': DateTime.now(),
          'puntajeTotal': score,
          'puntajeDiario': score,
          'puntajeSemanal': score,
          'puntajeMensual': score,
        };

        print('Datos a guardar: $datos');

        await collection.doc(id).set(datos);

        showSnackbar(context, 'Puntuación guardada');
        print('Puntuación guardada');
      } else {
        // El usuario existe, actualizar el puntaje
        final doc = querySnapshot.docs.first;

        await doc.reference.update({
          'puntajeTotal': FieldValue.increment(score),
          'puntajeDiario': FieldValue.increment(score),
          'puntajeSemanal': FieldValue.increment(score),
          'puntajeMensual': FieldValue.increment(score),
        });
        showSnackbar(context, 'Puntuación actualizada');
        print('Puntuación actualizada');
      }
    } catch (e) {
      print('Error al guardar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.black38,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Puntos: ${widget.game.bird.score}',
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontFamily: 'Game',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Fin del Juego',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontFamily: 'Game',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => onRestart(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  "Reiniciar",
                  style: TextStyle(
                      fontSize: 20, color: Colors.white, fontFamily: "IB"),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveScore(widget.game.bird.score, context);
                  Navigator.pushReplacementNamed(
                    context,
                    '/game',
                    arguments: {'userData': widget.userData},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  "Ir al Inicio",
                  style: TextStyle(
                      fontSize: 20, color: Colors.white, fontFamily: "IB"),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveScore(widget.game.bird.score, context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RankingPage(userData: widget.userData);
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  "Puntuaciones",
                  style: TextStyle(
                      fontSize: 20, color: Colors.white, fontFamily: "IB"),
                ),
              ),
              
            ],
          ),
        ),
      );

  void onRestart(BuildContext context) {
    saveScore(widget.game.bird.score, context);
    widget.game.bird.reset();
    widget.game.overlays.remove('gameOver');
    widget.game.resumeEngine();
  }
}

