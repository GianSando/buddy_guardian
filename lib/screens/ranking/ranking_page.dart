// ignore_for_file: library_private_types_in_public_api

import 'package:buddy_guardian/screens/ranking/ranking_diario.dart';
import 'package:buddy_guardian/screens/ranking/ranking_global.dart';
import 'package:buddy_guardian/screens/ranking/ranking_mensual.dart';
import 'package:buddy_guardian/screens/ranking/ranking_semanal.dart';
import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:buddy_guardian/widgets/logout_widget.dart';
import 'package:buddy_guardian/widgets/material_buttom.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  final dynamic userData;
  const RankingPage({super.key, this.userData});

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Lista de widgets con contenido específico para cada página
  final List<Widget> pageContents = [
    const RankingDay(),
    const RankingSemanal(),
    const RankingMensual(),
    const RankingGlobal(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.gradientColor2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            //iconbutton para regresar a la pantalla anterior
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.text, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    "Ranking de puntajes",
                    style: TextStyle(
                      fontFamily: "CB",
                      color: AppColors.text,
                      fontSize: 25,
                    ),
                  ),
                  const LogoutWidget(),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: ListView.builder(
                itemCount: pageContents.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ButtonDecorationWidget2(
                      minWidth: 80,
                      buttonColor: _currentPageIndex == index
                          ? AppColors.blueColors
                          : AppColors.orangeAcents,
                      text: index == 0
                          ? "Día"
                          : index == 1
                              ? "Semana"
                              : index == 2
                                  ? "Mes"
                                  : "Global",
                      onPressed: () {
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pageContents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Center(child: pageContents[index]);
                },
              ),
            ),
            //SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
