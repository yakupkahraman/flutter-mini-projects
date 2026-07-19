import 'dart:math';
import 'package:flutter/material.dart';

class BmiCalculator {
  BmiCalculator({required this.height, required this.weight});
  final int height;
  final int weight;

  double _bmi = 0;
  String result() {
    _bmi = weight / pow(height / 100, 2);
    return _bmi.toStringAsFixed(1);
  }

  String getText() {
    if (_bmi >= 30) {
      return 'OBESE';
    } else if (_bmi >= 25) {
      return 'OVERWEIGHT';
    } else if (_bmi > 18.5) {
      return 'NORMAL';
    } else {
      return 'UNDERWEIGHT';
    }
  }

  String getAdvice() {
    if (_bmi >= 30) {
      return 'You have a much higher than normal body weight.\n Consider talking to a doctor and increasing exercise.';
    } else if (_bmi >= 25) {
      return 'You have a more than normal body weight.\n Try to do more Exercise';
    } else if (_bmi > 18.5) {
      return 'You have a normal body weight.\nGood job!';
    } else {
      return 'You have a lower than normal body weight.\n Try to eat more';
    }
  }

  Color getTextColor() {
    if (_bmi >= 25 || _bmi <= 18.5) {
      return Colors.deepOrangeAccent;
    } else {
      return const Color(0xFF24D876);
    }
  }
}
