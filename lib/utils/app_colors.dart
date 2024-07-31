import 'package:flutter/widgets.dart';

class AppColors {
  static const blueColors = Color(0xff37C6F4);
  static const greenColors = Color(0xff60C882);
  static const purpleAcents = Color(0xff50409A);
  static const purpleColors = Color(0xff1E125B);
  static const pinkColors = Color(0xffEd3092);
  static const orangeAcents = Color(0xffF4815F);
  static const text = Color(0xffFFFFFF);
  static const darkColor = Color(0xff000000);
  static const lightColor = Color(0xffFFFFFF);
  static const red = Color(0xffFF0000);
  static const headerColor = Color(0xffE9ECF9);
  static const grey = Color(0xffA0A0A0);

  //COLORES PARA EL RANKINK
  static const oro = Color(0xffFAB300);
  static const plata = Color(0xffB0B3B8);
  static const bronce = Color(0xffE8A74F);

  static const gradientColor1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blueColors, greenColors],
  );

  static const gradientColor2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [purpleAcents, purpleColors],
  );
}

const Map<int, Color> swatch = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};
