import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const int n = 5;
final List<double> upperLimit = [];
final List<double> lowerLimit = [];
final List<double> deltas = [];
List<List<double>> sensorsData = [];
List<List<double>> errorsData = [];
final List<Sensor> dataset = [];
bool byPriority = false;

final List<int> sensorPriority = [5, 0, 3, 1, 4];
final List<int> intervals = [4, 2, 8, 12, 6];

class Lab1Screen extends StatefulWidget {
  const Lab1Screen({super.key});

  @override
  _Lab1ScreenState createState() => _Lab1ScreenState();
}

class _Lab1ScreenState extends State<Lab1Screen> {
  Timer? _timer;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeOptions();
    _timer = Timer.periodic(Duration(seconds: intervals[currentIndex]), (_) {
      testAllSensors();
      currentIndex = (currentIndex + 1) % n;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна робота №1'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  byPriority = !byPriority;
                });
              },
              child: Text('-- Включити пріорітет --'),
            ),
            ElevatedButton(
              onPressed: printOverLimitSensorData,
              child: Text('-- Оновити логи --'),
            ),
            ElevatedButton(
              onPressed: deleteErrorsLogs,
              child: Text('-- Видалити логи помилок --'),
            ),
            ElevatedButton(
              onPressed: deleteSensorsLogs,
              child: Text('-- Видалити логи даних --'),
            ),
            const SizedBox(height: 20,),
            const Text(
              '-- Логи значень-- ',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20,),
            Container(
                height: 250,
                child: Column(children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          List<String> formattedNumbers = sensorsData[index].map((double number) {
                            return number.toStringAsFixed(2);
                          }).toList();
                          return Text('--Сенсор ${index+1}: ${formattedNumbers} --\n', style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,);
                        }
                    ),
                  )
                ]
                )),
            const SizedBox(height: 20,),
            const Text(
              '-- Логи помилок --',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20,),
            SizedBox(
                height: 250,
                child: Column(children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          List<String> formattedNumbers = errorsData[index].map((double number) {
                            return number.toStringAsFixed(2);
                          }).toList();
                          return Text('-- Сенсор ${index+1}: ${formattedNumbers} --\n', style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,);
                        }
                    ),
                  )
                ]
                )),
          ],
        ),
      ),
    );
  }

  void initializeOptions() {
    for (int i = 0; i < n; i++) {
      final String label = 'Сенсор ${i + 1} --';
      final Color borderColor =
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      final Sensor sensor = Sensor(
        label: label,
        data: [],
        borderColor: borderColor,
        priority: sensorPriority[i],
      );
      dataset.add(sensor);

      lowerLimit.add(22);
      upperLimit.add(55);

      deltas.add(0.5);

      sensorsData.add([]);
      errorsData.add([]);
    }
  }

  void testAllSensors() {
    setState(() {});
    if (byPriority) {
      final sensorsByPriority = List.from(dataset)
        ..sort((a, b) => a.priority - b.priority);
      for (int i = 0; i < n; i++) {
        sensorsByPriority[i].test();
      }
    } else {
      dataset[currentIndex].test();
    }
  }

  void printSensorData() {
    setState(() {});
    for (int i = 0; i < n; i++) {
      print('--Інформація по ${i + 1} сенсору --');
      if (sensorsData[i].isEmpty) {
        print('--Не знайдено інформації по сенсорам --');
      } else {
        for (int j = 0; j < sensorsData[i].length; j++) {
          print('--Значення: ${sensorsData[i][j]}');
        }
      }
    }
  }

  void printOverLimitSensorData() {
    setState(() {});
    for (int i = 0; i < n; i++) {
      print('--Помилка на ${i + 1} сенсорі --');
      if (errorsData[i].isEmpty) {
        print('--Не знайдено помилок на сенсорах --');
      } else {
        for (int j = 0; j < errorsData[i].length; j++) {
          print('-- Значення: ${errorsData[i][j]} --');
        }
      }
    }
  }

  void deleteErrorsLogs() {
    setState(() {
      for(var list in errorsData) {
        list.clear();
      }
    });
  }

  void deleteSensorsLogs() {
    setState(() {
      for(var list in sensorsData) {
        list.clear();
      }
    });
  }
}

class Sensor {
  final String label;
  final List<double> data;
  final Color borderColor;
  final int priority;

  Sensor({
    required this.label,
    required this.data,
    required this.borderColor,
    this.priority = 0,
  });

  void test() {
    final sensorIndex = int.parse(label.substring(7, 8)) -1;
    final sensorValue = getRandomNumber(
      lowerLimit[sensorIndex] - deltas[sensorIndex],
      upperLimit[sensorIndex] + deltas[sensorIndex],
    );

    print('--Тестуємо сенсор --- ${sensorIndex + 1}');
    print('--Значення на сенсорі --- $sensorValue');

    if (sensorValue < lowerLimit[sensorIndex] || sensorValue > upperLimit[sensorIndex]) {
      print('--Сенсор ${sensorIndex + 1} за межею!--');
      errorsData[sensorIndex].add(sensorValue);
    }
    sensorsData[sensorIndex].add(sensorValue);
  }
}

double getRandomNumber(double min, double max) {
  return Random().nextDouble() * (max - min) + min;
}
