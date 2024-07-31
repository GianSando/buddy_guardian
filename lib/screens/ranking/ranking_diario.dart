import 'package:flutter/material.dart';
import 'package:buddy_guardian/screens/ranking/ranking_widget.dart';
import 'package:buddy_guardian/services/firestore_service.dart';

class RankingDay extends StatefulWidget {
  const RankingDay({super.key});

  @override
  State<RankingDay> createState() => _RankingDayState();
}

class _RankingDayState extends State<RankingDay> {
  final FirestoreService _firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return RankingWidget(
      rankingDataFuture: _firestoreService.rankingDiario(),
      puntajeField: 'puntajeDiario',
    );
  }
}
