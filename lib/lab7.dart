import 'package:flutter/material.dart';
import 'dart:math';

class Lab7Screen extends StatefulWidget {

  @override
  _Lab7ScreenState createState() => _Lab7ScreenState();
}

class _Lab7ScreenState extends State<Lab7Screen> {
  double densitySaturatedSteam = 0.0;
  double correctionSaturatedSteam = 0.0;
  double flowSaturatedSteam = 0.0;

  double correctionGas = 0.0;
  double flowGas = 0.0;

  double densitySuperheatedSteam = 0.0;
  double correctionSuperheatedSteam = 0.0;
  double flowSuperheatedSteam = 0.0;

  double p0 = 1000;
  double deltaTeta = 20;
  double beta = 0.005;
  double kACPL = 3104;
  double kACPMax = 4096;
  double deltaP = 8000;
  double l = 0.0;

  @override
  void initState() {
    super.initState();
    calculate();
    calculateLevel();
  }

  void calculate() {
    double pSaturatedSteam = 5.0;
    double pGas = 4.6;
    double pSuperheatedSteam = 10;

    double tetaGas = 240;
    double tetaSuperheatedSteam = 230;

    double p0Gas = 2.0;
    double t0Gas = 293;

    double p0SaturatedSteam = 2.5;
    double p0SuperheatedSteam = 3.00;

    double kACPSaturatedSteam = 384;
    double kACPGas = 1536;
    double kACPSuperheatedSteam = 283;

    double kMaxACPSaturatedSteam = 1024;
    double kMaxACPGas = 4096;
    double kMaxACPSuperheatedSteam = 1024;

    double fMaxSaturatedSteam = 500;
    double fMaxGas = 630;
    double fMaxSuperheatedSteam = 800;

    double getDensitySaturatedSteam(double p) {
      return 0.869 + 0.518 * p - 0.002375 * pow(p, 2);
    }

    double getDensitySuperheatedSteam(double p, double teta) {
      return 1.2 -
          (0.013 * teta) +
          (0.72 * p) +
          (0.36 * 0.0001 * pow(teta, 2)) +
          (0.24 * 0.01 * pow(p, 2)) -
          (0.14 * 0.01 * teta * p);
    }

    double getCorrectionCoefSteam(double p, double p0) {
      return sqrt(p / p0);
    }

    double getCorrectionCoefGas(double t0, double p0, double p, double teta) {
      double K = t0 / p0;
      return sqrt(K * (p + 1) / (teta + 273));
    }

    double getFlow(double kACP, double kMaxACP, double fMax, double k) {
      return sqrt(kACP / kMaxACP) * fMax * k;
    }

    densitySaturatedSteam = getDensitySaturatedSteam(pSaturatedSteam);
    correctionSaturatedSteam =
        getCorrectionCoefSteam(densitySaturatedSteam, p0SaturatedSteam);
    flowSaturatedSteam = getFlow(
        kACPSaturatedSteam, kMaxACPSaturatedSteam, fMaxSaturatedSteam, correctionSaturatedSteam);

    correctionGas = getCorrectionCoefGas(t0Gas, p0Gas, pGas, tetaGas);
    flowGas = getFlow(kACPGas, kMaxACPGas, fMaxGas, correctionGas);

    densitySuperheatedSteam = getDensitySuperheatedSteam(
        pSuperheatedSteam, tetaSuperheatedSteam);
    correctionSuperheatedSteam = getCorrectionCoefSteam(
        densitySuperheatedSteam, p0SuperheatedSteam);
    flowSuperheatedSteam = getFlow(kACPSuperheatedSteam, kMaxACPSuperheatedSteam,
        fMaxSuperheatedSteam, correctionSuperheatedSteam);
  }

  void calculateLevel() {
    double getLevel(
        double p0, double beta, double deltaTeta, double deltaP, double kACPL, double kACPMax) {
      double p = p0 * (1 + beta * deltaTeta);
      double K1 = 1 / 100000;
      double deltaPMpa = deltaP * 0.00000980665;
      double Lmax = deltaPMpa / (K1 * p);
      return (kACPL / (kACPMax * p0)) * Lmax;
    }

    l = getLevel(p0, beta, deltaTeta, deltaP, kACPL, kACPMax);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна робота №7'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                  image: AssetImage('assets/lab7.PNG')),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  '-- Розрахунки для насиченої пари --',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(child: Text('--Густина-- ${densitySaturatedSteam.toStringAsFixed(3)} --')),
              Center(child: Text('--Поправ. коефіцієнт-- ${correctionSaturatedSteam.toStringAsFixed(3)} --')),
              Center(child: Text('--F*-- ${flowSaturatedSteam.toStringAsFixed(3)} --')),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  '-- Розрахунки для газу --',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(child: Text('--Поправ. коефіцієнт-- ${correctionGas.toStringAsFixed(3)} --')),
              Center(child: Text('--F*-- ${flowGas.toStringAsFixed(3)} --')),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  '--Розрахунки для перегрітої пари--',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(child: Text('--Густина-- ${densitySuperheatedSteam.toStringAsFixed(3)} --')),
              Center(child: Text('--Поправ. коефіцієнт-- ${correctionSuperheatedSteam.toStringAsFixed(3)} --')),
              Center(child: Text('--F*-- ${flowSuperheatedSteam.toStringAsFixed(3)} --')),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  '--Рівень--',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(child: Text('--L-- ${l.toStringAsFixed(6)}')),
            ],
          ),
        ),
      ),
    );
  }
}