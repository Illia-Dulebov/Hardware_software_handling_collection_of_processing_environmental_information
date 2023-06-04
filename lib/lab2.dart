import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;

extension ListExtensions<E> on List<E> {
  List<T> mapIndexed<T>(T Function(int index, E element) f) {
    var index = 0;
    return map((element) => f(index++, element)).toList();
  }
}

class Lab2Screen extends StatelessWidget {
  const Lab2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна робота №2'),
      ),
      body: PagesWithSubTasks(),
    );
  }
}

class PagesWithSubTasks extends StatefulWidget {
  @override
  _PagesWithSubTasksState createState() => _PagesWithSubTasksState();
}

class DataPoint {
  final double x;
  final double y;

  DataPoint(this.x, this.y);
}

class _PagesWithSubTasksState extends State<PagesWithSubTasks> {
  List<double> temperatureValues = [46, 42, 30, 18, 6, 1, 0];
  List<double> pressureValues = [24, 22.5, 15, 6, 2, 0];
  double sigmaXmaxTemp = 4.9;
  double sigmaXismTemp = 1.1;
  double sigmaXmaxPressure = 3.4;
  double sigmaXismPressure = 0.9;

  double calculateMathExpectation(List<double> array) {
    return array.reduce((a, b) => a + b) / array.length;
  }

  double calculateDispersion(List<double> array) {
    double mathematicalExpectation = calculateMathExpectation(array);
    double variance = array
            .map((x) =>
                (x - mathematicalExpectation) * (x - mathematicalExpectation))
            .reduce((a, b) => a + b) /
        array.length;
    return variance;
  }

  double calculateKx(List<double> array, double xmax, double xism) {
    double dx = calculateDispersion(array);
    double result = (2 * dx + xism * xism - xmax * xmax) / 2;
    return result;
  }

  String findKx(List<double> array, double xmax, double xism, String direction,
      String target) {
    String printResult = "";
    if (direction.contains("+") && target.contains("Xmax")) {
      for (double i = xmax; i < xmax * 2; i++) {
        double result = calculateKx(array, i, xism);
        printResult +=
            "--$target = ${i.toStringAsFixed(2)}-- Kx = ${result.toStringAsFixed(2)}--\n";
      }
      return printResult;
    } else if (direction.contains("+") && target.contains("Xism")) {
      for (double i = xism; i < xism * 2; i += 0.1) {
        double result = calculateKx(array, xmax, i);
        printResult +=
            "--$target = ${i.toStringAsFixed(2)}-- Kx = ${result.toStringAsFixed(2)}--\n";
      }
      return printResult;
    } else if (direction.contains("-") && target.contains("Xmax")) {
      for (double i = xmax; i > 0; i--) {
        double result = calculateKx(array, xmax, i);
        printResult +=
            "--$target = ${i.toStringAsFixed(2)}-- Kx = ${result.toStringAsFixed(2)}--\n";
      }
      return printResult;
    } else {
      for (double i = xism; i > 0; i -= 0.1) {
        double result = calculateKx(array, xmax, i);
        printResult +=
            "--$target = ${i.toStringAsFixed(2)}--  Kx = ${result.toStringAsFixed(2)}--\n";
      }
      return printResult;
    }
  }


  @override
  Widget build(BuildContext context) {
    double kxTemp = calculateKx(temperatureValues, sigmaXmaxTemp, sigmaXismTemp);
    double kxPressure = calculateKx(pressureValues, sigmaXmaxPressure, sigmaXismPressure);

    List<double> kxValues = [];
    List<String> deltaTArr = [];

    double length = 265;
    double v = 0.66;
    int n = 42;

    double tauN = length / v;
    double nMiddle = n / tauN;
    double deltaTau = 0.15 / nMiddle;

    List<double> values = [78.7, 95.85, 88.45, 87.78,
      91.82, 101.57, 106.28, 105.27, 98.54,
      100.22, 104.26, 98.88, 101.91, 97.87, 102.91, 98.88,
      102.91, 103.59, 102.24, 91.82, 78.03, 68.95,
      64.91, 2.35, 65.58, 2.35, 77.35, 2.02,
      70.96, 87.11, 93.5, 115.36, 118.72, 117.38,
      108.3, 108.3, 106.28, 97.87, 104.93, 97.87, 106.28,
      100.56, 98.88, 98.21, 96.86, 96.52, 109.3,
      102.58, 73.99, 80.04, 87.44, 97.87,
      105.94, 114.35,
    ];


    double mx = calculateMathExpectation(values);
    double dx = calculateDispersion(values);

    List<double> kx = [];
    for (int i = 0; i < values.length; i++) {
      List<double> subValues = values.sublist(0, i + 1);
      kx.add(calculateKx(subValues, sigmaXmaxTemp, sigmaXismTemp));
    }

    double j0 = (kx.reduce((a, b) => a + b) / kx.length) * deltaTau;
    double tau0 = j0 * deltaTau;

    double t = deltaTau;
    for (int i = 0; i < values.length; i++) {
      deltaTArr.add(t.toStringAsFixed(2));
      t += deltaTau;
    }
    deltaTArr.removeLast();

    double kxValue = calculateKx(values, sigmaXmaxTemp, sigmaXismTemp);

    List<charts.Series<dynamic, num>> seriesList = [
      charts.Series<dynamic, num>(
        id: 'Kx',
        domainFn: (dynamic dataPoint, _) => dataPoint.x,
        measureFn: (dynamic dataPoint, _) => dataPoint.y,
        data: deltaTArr
            .mapIndexed(
                (index, value) => DataPoint(double.parse(value), kx[index]))
            .toList(),
      )
    ];


    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Center(
          child: const Text('-- Підзавдання №1 --',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10.0),
        const Text('-- Датчик температури --'),
        Text('--Ds -- ${calculateDispersion(temperatureValues).toStringAsFixed(2)}'),
        Text('--Mx -- ${calculateMathExpectation(temperatureValues).toStringAsFixed(2)}'),
        Text('--Kx(T) -- ${kxTemp.toStringAsFixed(2)}'),
        const SizedBox(height: 10.0),
        const Text('-- Датчик тиску --'),
        Text('--Ds: ${calculateDispersion(pressureValues).toStringAsFixed(2)}--'),
        Text('--Mx: ${calculateMathExpectation(pressureValues).toStringAsFixed(2)}--'),
        Text('--Kx(T): ${kxPressure.toStringAsFixed(2)}'),
        const SizedBox(height: 20.0),
        const Center(
          child: Text('--Xism -> константа, Xmax -> зростає --',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10.0),
        Text(
          findKx(temperatureValues, sigmaXmaxTemp, sigmaXismTemp, '+', 'Xmax'),
        ),
        const SizedBox(height: 20.0),
        const Center(
          child: Text('--Xism -> константа, Xmax -> спадає --',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10.0),
        Text(findKx(temperatureValues, sigmaXmaxTemp, sigmaXismTemp, '-', 'Xmax')),
        Text(findKx(temperatureValues, sigmaXmaxTemp, sigmaXismTemp, '-', 'Xmax')),
        const SizedBox(height: 20.0),
        Center(
          child: const Text('--Xmax -> константа, Xism -> зростає --',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10.0),
        Text(findKx(temperatureValues, sigmaXmaxTemp, sigmaXismTemp, '+', 'Xism')),
        const SizedBox(height: 20.0),
        const Center(
          child: Text('--Xmax -> константа, Xism -> спадає --',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10.0),
        Text(findKx(temperatureValues, sigmaXmaxTemp, sigmaXismTemp, '-', 'Xism')),
        const SizedBox(height: 20.0),
        const Center(
          child: Text('-- Підзавдання №2 --',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        ),
        const Image(image: AssetImage('assets/lab2.PNG')),
        const SizedBox(height: 10.0),
        Text('--Mx -- ${mx.toStringAsFixed(2)}--'),
        Text('--Ds -- ${dx.toStringAsFixed(2)}--'),
        const SizedBox(height: 10.0),
        Text('--τ_n -- ${tauN.toStringAsFixed(2)}-'),
        Text('--n_cp -- ${nMiddle.toStringAsFixed(2)}--'),
        Text('--Δτ -- ${deltaTau.toStringAsFixed(2)}--'),
        const SizedBox(height: 10.0),
        Text('--J0 -- ${j0.toStringAsFixed(2)}--'),
        Text('--τ0 -- ${tau0.toStringAsFixed(2)}--', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10.0),
        Text('--Kx(τ0) -- ${kxValue.toStringAsFixed(2)}'),
        const SizedBox(height: 20.0),
        const Center(
          child: Text('--Графік кореляційної функції випадкового процесу --',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        ),
        const SizedBox(height: 10.0),
        Stack(
          children: [
            const Positioned(
              left: 0,
              top: 80,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  "-- Значення функції --",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 300,
                  width: 700,
                  child: charts.LineChart(
                    seriesList,
                    animate: true,
                    defaultRenderer: charts.LineRendererConfig(
                      includeArea: true,
                      stacked: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Center(child: Text('--Час--')),
        const SizedBox(height: 20.0),
      ],
    );
  }
}

