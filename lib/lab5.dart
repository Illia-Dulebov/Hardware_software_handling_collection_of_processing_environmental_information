import 'dart:math';

import 'package:flutter/material.dart';

class Lab5Screen extends StatefulWidget {
  const Lab5Screen({Key? key}) : super(key: key);

  @override
  State<Lab5Screen> createState() => _Lab5ScreenState();
}

class _Lab5ScreenState extends State<Lab5Screen> {

  double yMax = 16.39;
  double superHeatedStream = 2.90;
  int streamParamF = 10;
  int streamParamP = 10;
  int streamParamT = 10;
  int KacpF = 320;
  int KacpP = 832;
  int KacpT = 768;
  double deltaP = 1000;
  double Fmax = 500;
  double pMin = 0;
  double pMax = 25;
  double tMin = 0;
  double tMax = 400;
  double tSignalMin = 0;
  double tSignalMax = 10;

  late double KacpMaxPressure;
  late double pressureSensor;
  late double KacpMaxTemperature;
  late double temperatureSensor;
  late double heatedStreamDensity;
  late double correctionFactor;
  late double KacpMaxFlow;
  late double spending;

  @override
  void initState() {
    calculateResults(); // Calculate the initial results
    super.initState();
  }

  void calculateResults() {
    double roundDouble(double value, int places) {
      num mod = pow(10.0, places.toDouble());
      return (value * mod).round() / mod;
    }

    double getKacpMax(int acp) {
      return pow(2, acp).toDouble();
    }

    double getPressureSensor(int KacpP, double KacpMax, double pMax) {
      return (KacpP / KacpMax) * pMax;
    }

    double getTemperatureSensor(
        int KacpT, double KacpMax, double tSignalMax, double yMax) {
      double Knp = tSignalMax / yMax;
      double y = (tSignalMax / (KacpMax * Knp)) * KacpT;
      return roundDouble(3.01 + 13.75 * y - 0.03 * pow(y, 2), 1);
    }

    double getHeatedStreamDensity(
        double temperatureSensor, double pressureSensor) {
      return (1.2 -
          0.013 * temperatureSensor +
          0.72 * pressureSensor +
          0.36 * 0.0001 * pow(temperatureSensor, 2) +
          0.24 * 0.01 * pow(pressureSensor, 2) -
          0.14 * 0.01 * temperatureSensor * pressureSensor);
    }

    double getCorrectionFactor(
        double heatedStreamDensity, double superHeatedStream) {
      return sqrt(heatedStreamDensity / superHeatedStream);
    }

    double getFlowSensor(
        int KacpF, double KacpMax, double Fmax, double correctionFactor) {
      return sqrt(KacpF / KacpMax) * Fmax * correctionFactor;
    }

    // Calculate results
    KacpMaxPressure = getKacpMax(streamParamP);
    pressureSensor =
        getPressureSensor(KacpP, KacpMaxPressure, pMax.toDouble());

    KacpMaxTemperature = getKacpMax(streamParamT);
    temperatureSensor = getTemperatureSensor(
        KacpT, KacpMaxTemperature, tSignalMax, yMax);

    heatedStreamDensity =
        getHeatedStreamDensity(temperatureSensor, pressureSensor);
    correctionFactor =
        getCorrectionFactor(heatedStreamDensity, superHeatedStream);
    KacpMaxFlow = getKacpMax(streamParamF);
    spending = getFlowSensor(KacpF, KacpMaxFlow, Fmax, correctionFactor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна робота №5'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Image(
                image: AssetImage('assets/lab5.PNG')),
            const SizedBox(height: 20),
            Text(
              '--Тиск --\n\n --${pressureSensor.toStringAsFixed(2)} кгс/см² --\n',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '--Температура --\n\n --${temperatureSensor.toStringAsFixed(1)} °C --\n',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '--Густина пари --\n\n --${heatedStreamDensity.toStringAsFixed(2)} кг/м³ --\n',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '--Поправочний коеф. --\n\n --${correctionFactor.toStringAsFixed(2)} --\n',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '--Фактичне значення витрати --\n\n --${spending.round()} м³/год --\n',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}