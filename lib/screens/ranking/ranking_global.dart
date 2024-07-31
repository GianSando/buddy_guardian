import 'package:flutter/material.dart';
import 'package:buddy_guardian/screens/ranking/ranking_widget.dart';
import 'package:buddy_guardian/services/firestore_service.dart';

class RankingGlobal extends StatefulWidget {
  const RankingGlobal({
    super.key,
  });

  @override
  State<RankingGlobal> createState() => _RankingGlobalState();
}

class _RankingGlobalState extends State<RankingGlobal> {
  final FirestoreService _firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return RankingWidget(
      rankingDataFuture: _firestoreService.rankingGlobal(),
      puntajeField: 'puntajeTotal',
    );
  }
}
