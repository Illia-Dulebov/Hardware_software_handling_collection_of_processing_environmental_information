import 'package:flutter/material.dart';
import 'dart:math' as math;

class Lab6Screen extends StatefulWidget {
  @override
  _Lab6ScreenState createState() => _Lab6ScreenState();
}

double getOptimalValue(
  Function method,
  double a,
  double b,
  double accuracy,
  double k,
  double m,
  double alpha,
  double sigma,
  double tO,
) {
  final middle_value = (a + b) / 2;
  final fmid = method(middle_value, k, m, alpha, sigma, tO);

  if (accuracy >= b - a) return middle_value;

  final x1 = middle_value - accuracy;
  final x2 = middle_value + accuracy;

  final f1 = method(x1, k, m, alpha, sigma, tO);
  final f2 = method(x2, k, m, alpha, sigma, tO);

  if (f1 <= fmid && f2 <= fmid) {
    return getOptimalValue(method, x1, x2, accuracy, k, m, alpha, sigma, tO);
  } else if (f1 >= fmid && f2 >= fmid) {
    return getOptimalValue(
        method, a, middle_value, accuracy, k, m, alpha, sigma, tO);
  } else {
    return getOptimalValue(
        method, middle_value, b, accuracy, k, m, alpha, sigma, tO);
  }
}

class _Lab6ScreenState extends State<Lab6Screen> {
  final double eps = 0.1;
  final double left = 0;
  final double right = 25;
  final double tO = 1.5;

  final Map<String, dynamic> tempObject = {
    'k': 0.3,
    'm': 5.6,
    'alpha': 0.28,
    'sigma': 47.5,
  };

  final Map<String, dynamic> pressureObject = {
    'k': 1.0,
    'm': 6.0,
    'alpha': 3.2,
    'sigma': 24.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Лабораторна робота №6'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "--Тепловий об'єкт--",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: FilterComparisonCard(
                      object: tempObject,
                      method: 'Moving Average Continuous',
                      methodFunction: movingAverageContinuous,
                    ),
                  ),
                  Center(
                    child: FilterComparisonCard(
                      object: tempObject,
                      method: 'Moving Average Discrete',
                      methodFunction: movingAverageDiscrete,
                    ),
                  ),
                  Center(
                    child: FilterComparisonCard(
                      object: tempObject,
                      method: 'Exponential Smoothing Continuous',
                      methodFunction: exponentialSmothContinuous,
                    ),
                  ),
                  Center(
                    child: FilterComparisonCard(
                      object: tempObject,
                      method: 'Exponential Smoothing Discrete',
                      methodFunction: exponentialSmothDiscrete,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Об'єкт регулювання тиску",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: FilterComparisonCard(
                      object: pressureObject,
                      method: 'Moving Average Continuous',
                      methodFunction: movingAverageContinuous,
                    ),
                  ),
                  Center(
                    child: FilterComparisonCard(
                      object: pressureObject,
                      method: 'Moving Average Discrete',
                      methodFunction: movingAverageDiscrete,
                    ),
                  ),
                  Center(
                    child: FilterComparisonCard(
                      object: pressureObject,
                      method: 'Exponential Smoothing Continuous',
                      methodFunction: exponentialSmothContinuous,
                    ),
                  ),
                  Center(
                    child: FilterComparisonCard(
                      object: pressureObject,
                      method: 'Exponential Smoothing Discrete',
                      methodFunction: exponentialSmothDiscrete,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  double movingAverageContinuous(
    double t,
    double k,
    double m,
    double alpha,
    double sigma,
    double tO,
  ) {
    return (m *
            m *
            math.exp(-alpha * t) *
            (-4 * alpha * t - 2 * alpha * alpha * t * t - 4) +
        4 * m * m -
        2 * k * t * alpha * m -
        2 * k * t * m * math.exp(-alpha * m * t) +
        4 * k -
        4 * k * math.exp(-alpha * m * t));
  }

  double getSigmaAverageContinuous(
    double k,
    double m,
    double alpha,
    double sigma,
    double tOpt,
  ) {
    return sigma *
        (1 +
            (math.pow(2, -alpha * tOpt) / alpha) * tOpt -
            (2 / (alpha * alpha * tOpt * tOpt)) *
                (1 - math.exp(-alpha * tOpt)) +
            (2 * k) / (alpha * m * tOpt) -
            ((2 * k) / (alpha * alpha * m * m * tOpt * tOpt)) *
                (1 - math.exp(-alpha * m * tOpt)));
  }

  double movingAverageDiscrete(
    double n,
    double k,
    double m,
    double alpha,
    double sigma,
    double tO,
  ) {
    final expatO = math.exp(alpha * tO);
    final expmatO = math.exp(-alpha * tO);
    final expmamtO = math.exp(-alpha * m * tO);
    final expamtO = math.exp(alpha * m * tO);
    final expmantO = math.exp(-alpha * n * tO);
    final expmamntO = math.exp(-alpha * m * n * tO);
    return ((1 - expmatO) *
            (expmamtO - 1) *
            (expamtO - 1) *
            (2 * n * n * alpha * tO * expmantO +
                4 * n * expmantO -
                n * n * expmatO +
                n * n * expatO -
                4 * n) -
        2 *
            n *
            n *
            (expmatO - 1) *
            (expatO - 1) *
            (expmamtO - 1) *
            (n * alpha * tO * expmantO - 1 + expmantO) +
        k *
            (expmatO - 1) *
            (expatO - 1) *
            (1 - expmatO) *
            (2 * n * n * alpha * m * tO * expmamntO -
                4 * n -
                n * n * expmamtO +
                n * n * expamtO +
                4 * n * expmamntO));
  }

  double getSigmaAverageDiscrete(
    double k,
    double m,
    double alpha,
    double sigma,
    double tO,
    double nOpt,
  ) {
    final expatO = math.exp(alpha * tO);
    final expmatO = math.exp(-alpha * tO);
    final expmamtO = math.exp(-alpha * m * tO);
    final expamtO = math.exp(alpha * m * tO);
    final expmantO = math.exp(-alpha * nOpt * tO);
    final expmamntO = math.exp(-alpha * m * nOpt * tO);
    return sigma *
        (1 +
            (2 + nOpt * expmatO - nOpt * expatO - 2 * expmantO) /
                (nOpt * nOpt * (expmatO - 1) * (expmatO - 1)) -
            (2 * (1 - expmantO)) / (nOpt * (1 - expmatO)) +
            (k * (2 + nOpt * expmamtO - nOpt * expamtO - 2 * expmamntO)) /
                (nOpt * nOpt * (expmamtO - 1) * (expamtO - 1)));
  }

  double exponentialSmothContinuous(
    double y,
    double k,
    double m,
    double alpha,
    double sigma,
    double tO,
  ) {
    return k * alpha * m * math.pow(alpha + y, 2) -
        alpha * math.pow(alpha * m + y, 2);
  }

  double getSigmaExponentialContinuous(
    double k,
    double m,
    double alpha,
    double sigma,
    double yO,
  ) {
    return sigma * ((k * yO) / (alpha * m * yO) + alpha / (alpha + yO));
  }

  double exponentialSmothDiscrete(
    double y,
    double k,
    double m,
    double alpha,
    double sigma,
    double tO,
  ) {
    final expmatO = math.exp(-alpha * tO);
    final expmamtO = math.exp(-alpha * m * tO);
    return (1 / ((2 - y) * (1 - y) * expmatO * expmatO)) *
            (1 + (1 - y) * expmatO - y * expmatO) *
            (2 - y) *
            (1 - (1 - y) * expmatO) -
        y *
            (1 + (1 - y) * expmatO) *
            ((1 - y) * expmatO - 1 + (2 - y) * expmatO) +
        (1 / ((2 - y) * (1 - y) * expmamtO * expmamtO)) *
            (k * (1 + (1 - y) * expmamtO) - k * y * expmamtO) *
            (2 - y) *
            (1 - (1 - y) * expmamtO) -
        k *
            y *
            (1 + (1 - y) * expmamtO) *
            ((1 - y) * expmamtO - 1 + (2 - y) * expmamtO) -
        (2 * (1 - (1 - y) * expmamtO) - 2 * y * expmatO) /
            math.pow(1 - (1 - y) * expmatO, 2);
  }

  double getSigmaExponentialDiscrete(
    double k,
    double m,
    double alpha,
    double sigma,
    double tO,
    double yO,
  ) {
    final expmatO = math.exp(-alpha * tO);
    final expmamtO = math.exp(-alpha * m * tO);
    return sigma *
        (1 +
            (yO * (1 + (1 - yO) * expmatO)) /
                ((2 - yO) * (1 - (1 - yO) * expmatO)) +
            (k * yO * (1 + (1 - yO) * expmamtO)) /
                ((2 - yO) * (1 - (1 - yO) * expmamtO)) -
            (2 * yO) / (1 - (1 - yO) * expmamtO));
  }

  double getOptimalValue(
    Function method,
    double a,
    double b,
    double accuracy,
    double k,
    double m,
    double alpha,
    double sigma,
    double tO,
  ) {
    final middle_value = (a + b) / 2;
    final fmid = method(middle_value, k, m, alpha, sigma, tO);

    if (accuracy >= b - a) return middle_value;

    final x1 = middle_value - eps;
    final x2 = middle_value + eps;

    final f1 = method(x1, k, m, alpha, sigma, tO);
    final f2 = method(x2, k, m, alpha, sigma, tO);

    if (f1 <= fmid && f2 <= fmid) {
      return getOptimalValue(method, x1, x2, accuracy, k, m, alpha, sigma, tO);
    } else if (f1 >= fmid && f2 >= fmid) {
      return getOptimalValue(
          method, a, middle_value, accuracy, k, m, alpha, sigma, tO);
    } else {
      return getOptimalValue(
          method, middle_value, b, accuracy, k, m, alpha, sigma, tO);
    }
  }
}

class FilterComparisonCard extends StatelessWidget {
  final Map<String, dynamic> object;
  final String method;
  final Function methodFunction;

  const FilterComparisonCard({
    required this.object,
    required this.method,
    required this.methodFunction,
  });

  @override
  Widget build(BuildContext context) {
    final double k = object['k'];
    final double m = object['m'];
    final double alpha = object['alpha'];
    final double sigma = object['sigma'];
    final double tO = 1.5;

    final optimalValue = getOptimalValue(
      methodFunction,
      0,
      25,
      0.00001,
      k,
      m,
      alpha,
      sigma,
      tO,
    );

    final sigmaAverage = methodFunction(
      optimalValue,
      k,
      m,
      alpha,
      sigma,
      tO,
    );

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              method,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('--Оптимальне значення-- ${optimalValue.toStringAsFixed(2)} --'),
            Text('--Похибка-- ${sigmaAverage.toStringAsFixed(2)} --'),
          ],
        ),
      ),
    );
  }
}
