import 'package:flutter/material.dart';
import 'package:buddy_guardian/screens/ranking/ranking_widget.dart';
import 'package:buddy_guardian/services/firestore_service.dart';

class RankingMensual extends StatefulWidget {
  const RankingMensual({
    super.key,
  });

  @override
  State<RankingMensual> createState() => _RankingMensualState();
}

class _RankingMensualState extends State<RankingMensual> {
  final FirestoreService _firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return RankingWidget(
      rankingDataFuture: _firestoreService.rankingMensual(),
      puntajeField: 'puntajeMensual',
    );
  }
}
