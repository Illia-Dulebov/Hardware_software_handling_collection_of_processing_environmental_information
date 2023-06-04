import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:charts_flutter/flutter.dart' as charts;

class Lab3Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна робота №3'),
      ),
      body: const Lab3(),
    );
  }
}

class Lab3 extends StatelessWidget {
  final Mx = 240;
  final Xti = 250;
  final Dx = 32;
  final tau0 = 7;
  final tau = 18;
  final k = 1.5;
  final timePeriod = 0.55;

  const Lab3({super.key});

  double pow(double base, double exponent) {
    return math.pow(base, exponent).toDouble();
  }

  double getT(double i) {
    return tau * i + timePeriod * tau0;
  }

  double getKxValue(double t) {
    double base = t / tau0;
    double result = math.pow(base.toDouble(), k.toDouble()).toDouble();
    return Dx * (1 - result);
  }

  double getXtExtrapolation(double Kx, double i) {
    double Xt =
        ((1 - math.pow(timePeriod + i, k)) * (Xti - Mx) + Mx).toDouble();
    if(i == 0) {
      print('--Результат розрахунку стохастичної екстраполяції -- ${Xt}');
    }
    return Xt;
  }

  double getXtInterpolation(double KxValue, double i) {
    double Xt = math.exp((-timePeriod + i) * tau / tau) * (Xti - Mx) + Mx;
    if(i == 0) {
      print('--Результат розрахунку стохастичної інтерполяції -- ${Xt}');
    }
    return Xt;
  }

  List<double> generateTArray() {
    List<double> tArray = [];
    for (int i = 0; i < 10; i++) {
      tArray.add((tau0 * i).toDouble());
    }
    return tArray;
  }

  List<double> generateKxArray(List<double> tArray) {
    List<double> KxArray = [];
    for (double t in tArray) {
      KxArray.add(getKxValue(t));
    }
    return KxArray;
  }

  List<double> generateTArrayE() {
    List<double> tArrayE = [];
    for (int i = 0; i < 10; i++) {
      tArrayE.add(getT(i.toDouble()));
    }
    return tArrayE;
  }

  List<double> generateXextArray(List<double> tArrayE, List<double> KxArray) {
    List<double> XextArray = [];
    for (int i = 0; i < tArrayE.length; i++) {
      double Kx = KxArray[i];
      double Xext = getXtExtrapolation(Kx, i.toDouble());
      XextArray.add(Xext);
    }
    return XextArray;
  }

  List<double> generateXintArray(List<double> tArrayE, List<double> KxArray) {
    List<double> XintArray = [];
    for (int i = 0; i < tArrayE.length; i++) {
      double Kx = KxArray[i];
      double Xint = getXtInterpolation(Kx, i.toDouble());
      XintArray.add(Xint);
    }
    return XintArray;
  }

  @override
  Widget build(BuildContext context) {
    List<double> tArray = generateTArray();
    List<double> KxArray = generateKxArray(tArray);

    List<double> tArrayE = generateTArrayE();
    List<double> XextArray = generateXextArray(tArrayE, KxArray);
    List<double> XintArray = generateXintArray(tArrayE, KxArray);

    return Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10,),
        Center(child: Text('--Результат розрахунку стохастичної екстраполяції -- ${XextArray[0].toStringAsFixed(2)}', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
        const SizedBox(height: 10,),
        Center(child: Text('--Результат розрахунку стохастичної інтерполяції -- ${XintArray[0].toStringAsFixed(2)}', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  'Kx(t)',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Plot Kx(t)
            Expanded(
              child: LineChartWidget(
                data: tArray,
                values: KxArray,
                label: 'Kx(t)',
                color: Colors.orange,
                yLabel: 'Kx(t)',
                xLabel: 'Час (секунди)',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Center(
                child: Text(
                  '--Час (секунди)--',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Divider(
              height: 5,
              color: Colors.orange,
              thickness: 3,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  'Xext(t)',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Plot Xext(t)
            Expanded(
              child: LineChartWidget(
                data: tArrayE,
                values: XextArray,
                label: 'Xext(t)',
                color: Colors.purple,
                yLabel: 'Xext(t)',
                xLabel: 'Час (секунди)',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Center(
                child: Text(
                  '--Час (секунди)--',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Divider(
              height: 5,
              color: Colors.orange,
              thickness: 3,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  'Xint(t)',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Plot Xint(t)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChartWidget(
                  data: tArrayE,
                  values: XintArray,
                  label: 'Xint(t)',
                  color: Colors.cyan,
                  yLabel: 'Xint(t)',
                  xLabel: 'Час (секунди)',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Center(
                child: Text(
                  '--Час (секунди)--',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      ],
    ),
          ),
        ));
  }
}

class LineChartWidget extends StatefulWidget {
  final List<double> data;
  final List<double> values;
  final String label;
  final Color color;
  final String xLabel;
  final String yLabel;

  LineChartWidget({
    required this.data,
    required this.values,
    required this.label,
    required this.color,
    required this.xLabel,
    required this.yLabel,
  });

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  double xGlobal = 0;
  double yGlobal = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 50,
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              widget.label,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          right: 140,
          top: 0,
          child: RotatedBox(
            quarterTurns: 4,
            child: Text(
              '--X=${xGlobal.toStringAsFixed(2)}, Y=${yGlobal.toStringAsFixed(2)}--',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 1300,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return charts.LineChart(
                _createSeriesData(),
                animate: false,
                defaultRenderer: charts.LineRendererConfig(
                  includePoints: true,
                  includeArea: true,
                  stacked: false,
                ),
                domainAxis: const charts.NumericAxisSpec(
                  renderSpec: charts.GridlineRendererSpec(
                    labelAnchor: charts.TickLabelAnchor.inside,
                    labelJustification: charts.TickLabelJustification.inside,
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 12,
                      color: charts.MaterialPalette.black,
                    ),
                  ),
                ),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 12,
                      color: charts.MaterialPalette.black,
                    ),
                  ),
                ),
                behaviors: [
                  charts.PanAndZoomBehavior(),
                ],
                selectionModels: [
                  charts.SelectionModelConfig(
                    type: charts.SelectionModelType.info,
                    changedListener: _handleSelectionChanged,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  List<charts.Series<ChartValue, double>> _createSeriesData() {
    return [
      charts.Series<ChartValue, double>(
        id: widget.label,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(widget.color),
        domainFn: (ChartValue value, _) => value.x,
        measureFn: (ChartValue value, _) => value.y,
        data: List<ChartValue>.generate(widget.data.length, (index) {
          return ChartValue(widget.data[index], widget.values[index]);
        }),
      ),
    ];
  }

  void _handleSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      final value = selectedDatum.first.datum;
      final x = value.x;
      final y = value.y;

      setState(() {
        xGlobal = x;
        yGlobal = y;
      });

    }
  }
}

class ChartValue {
  final double x;
  final double y;

  ChartValue(this.x, this.y);
}
