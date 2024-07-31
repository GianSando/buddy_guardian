import 'package:buddy_guardian/screens/ranking/ranking_widget.dart';
import 'package:buddy_guardian/services/firestore_service.dart';
import 'package:flutter/material.dart';

class RankingSemanal extends StatefulWidget {
  const RankingSemanal({super.key});

  @override
  State<RankingSemanal> createState() => _RankingSemanalState();
}

class _RankingSemanalState extends State<RankingSemanal> {
  final FirestoreService _firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return RankingWidget(
      rankingDataFuture: _firestoreService.rankingSemanal(),
      puntajeField: 'puntajeSemanal',
    );
  }
}
