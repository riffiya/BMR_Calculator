import 'package:flutter/material.dart';

const Color primaryBlue = Color.fromARGB(255, 3, 112, 222); 
const Color accentBlue = Color(0xFF64B5F6);
const Color scaffoldGrey = Color(0xFFF3F6F9);
const Color cardGrey = Color(0xFFECEFF1);
const Color darkText = Color(0xFF263238);

const double bottomContainerHeight = 70.0;

enum Gender { male, female }
enum BmrFormula { mifflinStJeor, revisedHarrisBenedict, katchMcArdle }

const labelTextStyle = TextStyle(fontSize: 16, color: darkText);
const numberTextStyle = TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: darkText);
const buttonTextStyle = TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);
const resultCategoryStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBlue);
const bmrNumberStyle = TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: darkText);
