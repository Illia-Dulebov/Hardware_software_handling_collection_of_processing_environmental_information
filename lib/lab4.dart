import 'dart:math';

import 'package:flutter/material.dart';

class Lab4Screen extends StatefulWidget {
  const Lab4Screen({super.key});

  @override
  State<Lab4Screen> createState() => _Lab4ScreenState();
}

class _Lab4ScreenState extends State<Lab4Screen> {
  List<double> x = [12.0, 10.0, 14.0, 34.2];
  double l = 1.6;
  List<double> deltaX = [0.45, 0.45, 0.45, 0.65];
  List<double> sigma = [0.30, 0.20, 0.36, 0.34];
  List<double> a = [];
  List<double> p = [];
  List<double> deltaQ = [];
  List<double> Q = [];
  double? deltaL;

  String calculateA() {
    String resultA = "";
    for (int i = 0; i < x.length; i++) {
      if (l / x[i] > 0) {
        a.add(1);
        resultA += '--a[${i + 1}]: ${a[i]}--';
      } else {
        a.add(-1);
        resultA += '--a[${i + 1}]: ${a[i]}--';
      }
    }
    return resultA;
  }

  String calculateL() {
    String resultL = "";
    deltaL = (x[0] + x[1] + x[2] - x[3]).roundToDouble();
    resultL += '--l -- $deltaL --\n';
    if (l < deltaL!) {
      resultL += '--X має недостовірні значення --\n';
      return "${resultL} - true";
    }
    return "${resultL} - false";
  }

  String calculateP() {
    String resultPAndK = "";
    double k = 1 /
        (1 / pow(sigma[0], 2) +
            1 / pow(sigma[1], 2) +
            1 / pow(sigma[2], 2) +
            1 / pow(sigma[3], 2));
    resultPAndK += '--K --${k.toStringAsFixed(3)}\n\n';
    for (int i = 0; i < sigma.length; i++) {
      p.add(k / pow(sigma[i], 2));
      resultPAndK += 'p[${i + 1}]: ${p[i].toStringAsFixed(3)}--';
    }
    return resultPAndK;
  }

  String calculateQ() {
    String resultQ = "";
    for (int i = 0; i < x.length; i++) {
      deltaQ.add(2 * p[i] * x[i] * a[i]);
    }

    List<List<double>> matrix = [
      [deltaQ[0], 0, 0, 0, 1],
      [0, deltaQ[1], 0, 0, 1],
      [0, 0, deltaQ[2], 0, 1],
      [0, 0, 0, deltaQ[3], 1],
      [x[0], x[1], x[2], -x[3], l],
    ];

    List<double> vector = [0, 0, 0, 0, l];

    for (int i = 0; i < matrix.length; i++) {
      double mainElement = matrix[i][i];
      for (int j = i; j < matrix[i].length; j++) {
        matrix[i][j] /= mainElement;
      }
      vector[i] /= mainElement;

      for (int k = i + 1; k < matrix.length; k++) {
        double multiplier = matrix[k][i];
        for (int j = i; j < matrix[k].length; j++) {
          matrix[k][j] -= multiplier * matrix[i][j];
        }
        vector[k] -= multiplier * vector[i];
      }
    }

    for (int i = matrix.length - 1; i >= 0; i--) {
      for (int k = i - 1; k >= 0; k--) {
        double multiplier = matrix[k][i];
        for (int j = i; j < matrix[k].length; j++) {
          matrix[k][j] -= multiplier * matrix[i][j];
        }
        vector[k] -= multiplier * vector[i];
      }
    }

    List<double> solution = vector;
    for (int i = 1; i < solution.length; i++) {
      resultQ += 'q[$i]: ${solution[i].toStringAsFixed(3)}--';
      Q.add(solution[i]);
    }

    return resultQ;
  }

  String checkMissteps() {
    String resultMissteps = "";
    for (int i = 0; i < Q.length; i++) {
      resultMissteps +=
          '--Δ(похибка):\n q[${i + 1}] = ${Q[i].abs().toStringAsFixed(2)} < ΔX[${i + 1}]\n';
      if (Q[i].abs() < deltaX[i]) {
        resultMissteps +=
            '-***- Δ x[${i + 1}] не перевищує межі: ${deltaX[i].toStringAsFixed(3)} -***-\n';
      } else {
        resultMissteps +=
            '-ERR- Δ x[${i + 1}] перевищує межі: ${deltaX[i].toStringAsFixed(3)} -ERR-\n';
      }
      resultMissteps += "\n";
    }
    return resultMissteps;
  }

  String bringToCorrectValue() {
    String resultValue = "";
    List<double> correctedX = [];
    for (int i = 0; i < x.length; i++) {
      correctedX.add(x[i] - Q[i]);
    }
    resultValue += '--Значення скорегов. x --\n';
    for (int i = 0; i < correctedX.length; i++) {
      resultValue += '--x[${i + 1}]: ${correctedX[i].toStringAsFixed(3)}--';
    }
    double correctDeltaL =
        correctedX[0] + correctedX[1] + correctedX[2] - correctedX[3];
    resultValue +=
        '\n--Скореговане значення Δl -- ${correctDeltaL.toStringAsFixed(1)} --';
    return resultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна робота №4'),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Image(image: AssetImage('assets/lab4_1.PNG')),
              const SizedBox(
                height: 15,
              ),
              const Image(image: AssetImage('assets/lab4_2.PNG')),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      '-- Параметри a --${calculateA()}',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      '-- Значення похибки --\n',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    calculateL().contains('true')
                        ? Column(
                            children: [
                              Text(
                                '--Параметр l --\n\n ${calculateL()}',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                '--Параметри p --\n\n ${calculateP()}',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                '--Коефіцієнти q --\n\n ${calculateQ()}',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                '--Перевірка Δ --\n\n ${checkMissteps()}',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                '--Корегування значень --\n\n ${bringToCorrectValue()}',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          )
                        : const Text(
                            '--Коригування не потрібне!\n',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
