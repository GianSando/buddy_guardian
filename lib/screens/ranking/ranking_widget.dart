import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RankingWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> rankingDataFuture;
  final String puntajeField;

  const RankingWidget({
    super.key,
    required this.rankingDataFuture,
    required this.puntajeField,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: rankingDataFuture, // Obtiene los datos del ranking
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  "Cargando datos...",
                  style: TextStyle(fontFamily: "CB", color: AppColors.text),
                )
              ],
            ),
          ); // Muestra un indicador de carga mientras espera los datos
        } else if (snapshot.hasError) {
          return const Text('Error al cargar los datos del ranking');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No hay datos disponibles en el ranking',
              style: TextStyle(fontFamily: "CB", color: AppColors.text));
        } else {
          List<Map<String, dynamic>> rankingData = snapshot.data!;
          rankingData = rankingData
              .where((userData) => userData[puntajeField] > 0)
              .toList();
          // Ahora puedes usar rankingData en tu diseño para mostrar los datos
          return Column(
            children: [
              const SizedBox(height: 25),
              Expanded(
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //USUARIO QUE ESTA EN EL SEGUNDO PUESTO
                        SizedBox(
                          height: 200,
                          width: 120,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                top: 30,
                                child: Container(
                                  height: 200,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.blueColors.withOpacity(0.7),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 70),
                                      Text(
                                        rankingData.length >= 2
                                            ? rankingData[1]['username']
                                            : 'Nadie aún', // Segundo puesto
                                        style: const TextStyle(
                                            fontFamily: "CB", fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        rankingData.length >= 2
                                            ? "${rankingData[1][puntajeField]} Pts."
                                            : '',
                                        style: const TextStyle(
                                            fontFamily: "CM", fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              rankingData.length >= 2
                                  ? Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.blueColors,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          width: 2,
                                          color: AppColors.text,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: rankingData.length >= 2
                                              ? rankingData[1]['imageUser']
                                              : '', // URL de la imagen del segundo puesto si existe
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: AppColors.blueColors,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                width: 2,
                                                color: AppColors.text,
                                              ),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.asset(
                                                  "assets/gif/circle.gif",
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.blueColors,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          width: 2,
                                          color: AppColors.text,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.asset(
                                            "assets/images/noimage.png",
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                              Positioned(
                                top: 60,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.plata,
                                    border: Border.all(
                                        width: 1, color: AppColors.text),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "2",
                                      style: TextStyle(
                                        fontFamily: "CB",
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //USUARIO QUE ESTA EN EL PRIMER PUESTO
                        SizedBox(
                          height: 280,
                          width: 120,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                top: 35,
                                child: Container(
                                  height: 200,
                                  width: 120,
                                  decoration: const BoxDecoration(
                                    color: AppColors.blueColors,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 100),
                                      Text(
                                        rankingData.isNotEmpty
                                            ? rankingData[0]['username']
                                            : 'Nadie aún', // Primer puesto
                                        style: const TextStyle(
                                            fontFamily: "CB", fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        rankingData.isNotEmpty
                                            ? "${rankingData[0][puntajeField]} Pts."
                                            : '',
                                        style: const TextStyle(
                                            fontFamily: "CM", fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  rankingData.isNotEmpty
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: AppColors.blueColors,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                              width: 2,
                                              color: AppColors.text,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              imageUrl: rankingData.isNotEmpty
                                                  ? rankingData[0]['imageUser']
                                                  : '', // URL de la imagen del segundo puesto si existe
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: AppColors.blueColors,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: AppColors.text,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image.asset(
                                                      "assets/gif/circle.gif",
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: AppColors.blueColors,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                              width: 2,
                                              color: AppColors.text,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.asset(
                                                "assets/images/noimage.png",
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                  Positioned(
                                    top: -8,
                                    child: Image.asset(
                                      "assets/images/corona.png",
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 100,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.oro,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        width: 1, color: AppColors.text),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "1",
                                      style: TextStyle(
                                        fontFamily: "CB",
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //USUARIO QUE ESTA EN EL TERCER PUESTO
                        SizedBox(
                          height: 200,
                          width: 120,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                top: 30,
                                child: Container(
                                  height: 200,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.blueColors.withOpacity(0.5),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 70),
                                      Text(
                                        rankingData.length >= 3
                                            ? rankingData[2]['username']
                                            : 'Nadie aún', // Tercer puesto
                                        style: const TextStyle(
                                            fontFamily: "CB", fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        rankingData.length >= 3
                                            ? "${rankingData[2][puntajeField]} Pts."
                                            : '',
                                        style: const TextStyle(
                                            fontFamily: "CM", fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              rankingData.length >= 3
                                  ? Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.blueColors,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          width: 2,
                                          color: AppColors.text,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: rankingData.length >= 3
                                              ? rankingData[2]['imageUser']
                                              : '', // URL de la imagen del segundo puesto si existe
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: AppColors.blueColors,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                width: 2,
                                                color: AppColors.text,
                                              ),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.asset(
                                                  "assets/gif/circle.gif",
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.blueColors,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          width: 2,
                                          color: AppColors.text,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.asset(
                                            "assets/images/noimage.png",
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                              Positioned(
                                top: 60,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.bronce,
                                    border: Border.all(
                                        width: 1, color: AppColors.text),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "3",
                                      style: TextStyle(
                                        fontFamily: "CB",
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ClipOval(
                      clipper:
                          OvalTopBorderClipper(), // Reutiliza la clase de Clipper anterior
                      child: Container(
                        color: AppColors.headerColor,
                        height: 800,
                        width: double.infinity,
                      ),
                    ),
                    //USUARIOS A PARTIR DEL PUESTO 4
                    Positioned(
                      top: 240,
                      left: 20,
                      right: 20,
                      child: Container(
                        width: double.infinity,
                        height: 400,
                        decoration:
                            const BoxDecoration(color: AppColors.headerColor),
                        child: rankingData.length >=
                                3 // Verificar si hay suficientes elementos para mostrar
                            ? ListView.builder(
                                itemCount: rankingData.length - 3,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  final rankingIndex = index + 3;
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, bottom: 5),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("${rankingIndex + 1}",
                                                style: const TextStyle(
                                                    fontFamily: "CB",
                                                    fontSize: 16)),
                                            const SizedBox(width: 10),
                                            CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                rankingData[rankingIndex]
                                                    ['imageUser'],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                rankingData[rankingIndex]
                                                    ['username'],
                                                style: const TextStyle(
                                                    fontFamily: "CB",
                                                    fontSize: 16),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "${rankingData[rankingIndex][puntajeField]} Pts.",
                                              style: const TextStyle(
                                                  fontFamily: "CB",
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(), // No mostrar nada si no hay suficientes elementos
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class OvalTopBorderClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(-210, 205, 600, size.height + 100);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
