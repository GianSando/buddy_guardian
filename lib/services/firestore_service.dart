// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

//MOSTRAR DATOS DEL PUNTAJE DIARIO
  Future<List<Map<String, dynamic>>> rankingDiario() async {
    List<Map<String, dynamic>> rankingData = [];

    try {
      // Obtiene una referencia a la colección 'ranking' en Firestore
      CollectionReference rankingCollection =
          FirebaseFirestore.instance.collection('ranking');

      // Consulta los documentos en la colección y ordena por el campo 'puntajeDiario' de forma descendente
      QuerySnapshot querySnapshot = await rankingCollection
          .orderBy('puntajeDiario', descending: true)
          .get();

      // Convierte los documentos en una lista de mapas
      rankingData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error al obtener los datos del ranking: $e');
    }

    return rankingData;
  }

  //MOSTRAR DATOS DEL PUNTAJE SEMANAL
  Future<List<Map<String, dynamic>>> rankingSemanal() async {
    List<Map<String, dynamic>> rankingData = [];

    try {
      // Obtiene una referencia a la colección 'ranking' en Firestore
      CollectionReference rankingCollection =
          FirebaseFirestore.instance.collection('ranking');

      // Consulta los documentos en la colección y ordena por el campo 'puntajeDiario' de forma descendente
      QuerySnapshot querySnapshot = await rankingCollection
          .orderBy('puntajeSemanal', descending: true)
          .get();

      // Convierte los documentos en una lista de mapas
      rankingData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error al obtener los datos del ranking: $e');
    }

    return rankingData;
  }

  //MOSTRAR DATOS DEL PUNTAJE MENSUAL
  Future<List<Map<String, dynamic>>> rankingMensual() async {
    List<Map<String, dynamic>> rankingData = [];

    try {
      // Obtiene una referencia a la colección 'ranking' en Firestore
      CollectionReference rankingCollection =
          FirebaseFirestore.instance.collection('ranking');

      // Consulta los documentos en la colección y ordena por el campo 'puntajeDiario' de forma descendente
      QuerySnapshot querySnapshot = await rankingCollection
          .orderBy('puntajeMensual', descending: true)
          .get();

      // Convierte los documentos en una lista de mapas
      rankingData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error al obtener los datos del ranking: $e');
    }

    return rankingData;
  }

  //MOSTRAR DATOS DEL PUNTAJE GLOBAL
  Future<List<Map<String, dynamic>>> rankingGlobal() async {
    List<Map<String, dynamic>> rankingData = [];

    try {
      // Obtiene una referencia a la colección 'ranking' en Firestore
      CollectionReference rankingCollection =
          FirebaseFirestore.instance.collection('ranking');

      // Consulta los documentos en la colección y ordena por el campo 'puntajeDiario' de forma descendente
      QuerySnapshot querySnapshot = await rankingCollection
          .orderBy('puntajeTotal', descending: true)
          .get();

      // Convierte los documentos en una lista de mapas
      rankingData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error al obtener los datos del ranking: $e');
    }

    return rankingData;
  }

}
