import 'dart:convert';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'gender_model.dart';
import 'package:http/http.dart' as http;

import 'network/network_helper.dart';
class BarChartAPI extends StatefulWidget {
  BarChartAPI({Key? key}) : super(key: key);
  final Color dark = Colors.cyan.shade50;
  final Color normal = Colors.cyan.shade100;
  final Color light = Colors.cyan;
  @override
  State<BarChartAPI> createState() => _BarChartAPIState();
}

class _BarChartAPIState extends State<BarChartAPI> {
  List<GenderModel> genders = [];
  bool loading = true;
  int touchedIndex = -1;
  NetworkHelper _networkHelper = NetworkHelper();

  @override
  void initState() {
    super.initState();
    getData();
    fetch();
  }
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Apr';
        break;
      case 1:
        text = 'May';
        break;
      case 2:
        text = 'Jun';
        break;
      case 3:
        text = 'Jul';
        break;
      case 4:
        text = 'Aug';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }
  void getData() async {
    var response = await _networkHelper.get(
        "https://api.genderize.io/?name[]=balram&name[]=deepa&name[]=saket&name[]=bhanu&name[]=aquib");
    List<GenderModel> tempdata = genderModelFromJson(response.body);
    setState(() {
      genders = tempdata;
      loading = false;
    });
  }

  List<OrdinalData> ordinalList = [];
  Future<void> fetch() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/examuns/examun/nom'));
      var jsonResponse = jsonDecode(response.body);
      List<OrdinalData> tempList = []; // Créer une liste temporaire

      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['type'];
        final historiqueResponse = await http.get(Uri.parse('http://127.0.0.1:8000/historiques/historique/'+id.toString()));

        if (historiqueResponse.statusCode == 200) {
          dynamic jsonData = json.decode(historiqueResponse.body);

          if (jsonData != null) {
            try {
              tempList.add(
                OrdinalData(domain: nom, measure: jsonData),
              );
            } catch (e) {
              print("Erreur lors de la conversion de la chaîne en entier : $e");
            }
          }
        }
      }

      setState(() {
        ordinalList.addAll(tempList); // Ajouter les éléments à ordinalList
      });

    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }
  List<charts.Series<OrdinalData, String>> _createSampleData() {
    return [
      charts.Series<OrdinalData, String>(
        data: ordinalList,
        id: 'sales',
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        domainFn: (OrdinalData data, _) => data.domain,
        measureFn: (OrdinalData data, _) => data.measure,
      )
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: loading
              ? CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                child: charts.BarChart(
                  _createSampleData(),
                  animate: true,
                ),
              ),
              AspectRatio(
                aspectRatio: 1.3,
                child: Card(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 18,
                      ),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event,
                                    pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection == null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: showingSections(),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Indicator(
                            color: Color(0xff0293ee),
                            text: 'First',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: Color(0xfff8b250),
                            text: 'Second',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: Color(0xff845bef),
                            text: 'Third',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: Color(0xff13d38e),
                            text: 'Fourth',
                            isSquare: true,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 28,
                      ),
                    ],
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1.66,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final barsSpace =
                          4.0 * constraints.maxWidth / 400;
                      final barsWidth =
                          8.0 * constraints.maxWidth / 400;
                      return BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.center,
                          barTouchData: BarTouchData(
                            enabled: false,
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: bottomTitles,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: leftTitles,
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            checkToShowHorizontalLine: (value) =>
                            value % 10 == 0,
                            getDrawingHorizontalLine: (value) =>
                                FlLine(
                                  color: Colors.transparent,
                                  strokeWidth: 1,
                                ),
                            drawVerticalLine: false,
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          groupsSpace: barsSpace,
                          barGroups: getData2(barsWidth, barsSpace),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Container(
              //   child:
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Card(
                  color: Colors.white,

                  child: DChartBarO(
                    groupList: [
                      OrdinalGroup(
                        id: '1',
                        data: ordinalList,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  List<BarChartGroupData> getData2(double barsWidth, double barsSpace) {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000, widget.dark),
              BarChartRodStackItem(2000000000, 12000000000, widget.normal),
              BarChartRodStackItem(12000000000, 17000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 24000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 13000000000, widget.dark),
              BarChartRodStackItem(13000000000, 14000000000, widget.normal),
              BarChartRodStackItem(14000000000, 24000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 23000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000.5, widget.dark),
              BarChartRodStackItem(6000000000.5, 18000000000, widget.normal),
              BarChartRodStackItem(18000000000, 23000000000.5, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 29000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, widget.dark),
              BarChartRodStackItem(9000000000, 15000000000, widget.normal),
              BarChartRodStackItem(15000000000, 29000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 32000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000.5, widget.dark),
              BarChartRodStackItem(2000000000.5, 17000000000.5, widget.normal),
              BarChartRodStackItem(17000000000.5, 32000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 11000000000, widget.dark),
              BarChartRodStackItem(11000000000, 18000000000, widget.normal),
              BarChartRodStackItem(18000000000, 31000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 35000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 14000000000, widget.dark),
              BarChartRodStackItem(14000000000, 27000000000, widget.normal),
              BarChartRodStackItem(27000000000, 35000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 8000000000, widget.dark),
              BarChartRodStackItem(8000000000, 24000000000, widget.normal),
              BarChartRodStackItem(24000000000, 31000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 15000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000.5, widget.dark),
              BarChartRodStackItem(6000000000.5, 12000000000.5, widget.normal),
              BarChartRodStackItem(12000000000.5, 15000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, widget.dark),
              BarChartRodStackItem(9000000000, 15000000000, widget.normal),
              BarChartRodStackItem(15000000000, 17000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 34000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000, widget.dark),
              BarChartRodStackItem(6000000000, 23000000000, widget.normal),
              BarChartRodStackItem(23000000000, 34000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 32000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, widget.dark),
              BarChartRodStackItem(7000000000, 24000000000, widget.normal),
              BarChartRodStackItem(24000000000, 32000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 14000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, widget.dark),
              BarChartRodStackItem(1000000000.5, 12000000000, widget.normal),
              BarChartRodStackItem(12000000000, 14000000000.5, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 20000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 4000000000, widget.dark),
              BarChartRodStackItem(4000000000, 15000000000, widget.normal),
              BarChartRodStackItem(15000000000, 20000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 24000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 4000000000, widget.dark),
              BarChartRodStackItem(4000000000, 15000000000, widget.normal),
              BarChartRodStackItem(15000000000, 24000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 14000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, widget.dark),
              BarChartRodStackItem(1000000000.5, 12000000000, widget.normal),
              BarChartRodStackItem(12000000000, 14000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 27000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, widget.dark),
              BarChartRodStackItem(7000000000, 25000000000, widget.normal),
              BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 29000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000, widget.dark),
              BarChartRodStackItem(6000000000, 23000000000, widget.normal),
              BarChartRodStackItem(23000000000, 29000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 16000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, widget.dark),
              BarChartRodStackItem(9000000000, 15000000000, widget.normal),
              BarChartRodStackItem(15000000000, 16000000000.5, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 15000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, widget.dark),
              BarChartRodStackItem(7000000000, 12000000000.5, widget.normal),
              BarChartRodStackItem(12000000000.5, 15000000000, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
    ];
  }
  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}