import 'package:flutter/material.dart';

const Color backgroundColor = Colors.white;

/// Colors
const Color primaryBackgroundColor = Colors.white;

const Map<int, Color> colors = {
  50: Color.fromRGBO(63, 69, 75, .1),
  100: Color.fromRGBO(63, 69, 75, .2),
  200: Color.fromRGBO(63, 69, 75, .3),
  300: Color.fromRGBO(63, 69, 75, .4),
  400: Color.fromRGBO(63, 69, 75, .5),
  500: Color.fromRGBO(63, 69, 75, .6),
  600: Color.fromRGBO(63, 69, 75, .7),
  700: Color.fromRGBO(63, 69, 75, .8),
  800: Color.fromRGBO(63, 69, 75, .9),
  900: Color.fromRGBO(63, 69, 75, 1),
};
const MaterialColor myColor = MaterialColor(0xFF3F454B, colors);
const Color primaryAccentColor = myColor;
const Color buttonBackgroundColor = primaryAccentColor;
const Color buttonForegroundColor = Colors.white;
