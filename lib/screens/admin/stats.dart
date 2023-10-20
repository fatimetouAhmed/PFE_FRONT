import 'dart:convert';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import '../../consturl.dart';
import 'gender_model.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
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
  bool showEvaluations = true;
  bool showMatieres = false;
  bool showFilieres = false;
  bool showSemestres = false;
  bool showEtudiants = false;
  bool showAnnees = false;
  bool showSalles = false;
  List<_SalesData> data = [];
  List<_SalesData> dataMatieres = [];
  List<_SalesData> dataFilieres = [];
  List<_SalesData> dataSemestres = [];
  List<_SalesData> dataEtudiants = [];
  List<_SalesData> dataAnnees = [];
  List<_SalesData> dataSalles = [];
  @override
  void initState() {
    super.initState();
    getData();
    fetch2();
    fetch();
    fetchMatieres();
    fetchFilieres();
    fetchSemestres();
    fetchEtudiants();
    fetchAnnees();
    fetchSalles();
  }

  Future<void> fetch() async {
    try {
      final response = await http.get(Uri.parse(baseUrl+'statis/examun/nom'));
      var jsonResponse = jsonDecode(response.body);
      List<_SalesData> tempList = [];

      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['type'];
        final historiqueResponse = await http.get(Uri.parse(baseUrl+'statis/historique/'+id.toString()));

        if (historiqueResponse.statusCode == 200) {
          dynamic jsonData = json.decode(historiqueResponse.body);

          if (jsonData != null) {
            try {
              tempList.add(
                _SalesData(nom, jsonData),
              );
            } catch (e) {
              print("Erreur lors de la conversion de la chaîne en entier : $e");
            }
          }
        }
      }

      setState(() {
        data = tempList;
      });

    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }

  Future<void> fetchMatieres() async {
    try {
      final response = await http.get(Uri.parse(baseUrl+'statis/matieres/nom'));
      var jsonResponse = jsonDecode(response.body);
      List<_SalesData> tempList = [];

      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['libelle'];
        final historiqueResponse = await http.get(Uri.parse(baseUrl+'statis/historique/matieres/'+id.toString()));

        if (historiqueResponse.statusCode == 200) {
          dynamic jsonData = json.decode(historiqueResponse.body);

          if (jsonData != null) {
            try {
              tempList.add(
                _SalesData(nom, jsonData),
              );
            } catch (e) {
              print("Erreur lors de la conversion de la chaîne en entier : $e");
            }
          }
        }
      }

      setState(() {
        dataMatieres = tempList;
      });

    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }
  Future<void> fetchFilieres() async {
    try {
      final response = await http.get(Uri.parse(baseUrl+'statis/filieres/nom'));
      var jsonResponse = jsonDecode(response.body);
      List<_SalesData> tempList = [];

      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['libelle'];
        final historiqueResponse = await http.get(Uri.parse(baseUrl+'statis/historique/filieres/'+id.toString()));

        if (historiqueResponse.statusCode == 200) {
          dynamic jsonData = json.decode(historiqueResponse.body);

          if (jsonData != null) {
            try {
              tempList.add(
                _SalesData(nom, jsonData),
              );
            } catch (e) {
              print("Erreur lors de la conversion de la chaîne en entier : $e");
            }
          }
        }
      }

      setState(() {
        dataFilieres = tempList;
      });

    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }
  Future<void> fetchSemestres() async {
    try {
      final response = await http.get(Uri.parse(baseUrl+'statis/semestres/nom'));
      var jsonResponse = jsonDecode(response.body);
      List<_SalesData> tempList = [];

      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['libelle'];
        final historiqueResponse = await http.get(Uri.parse(baseUrl+'statis/historique/semestres/'+id.toString()));

        if (historiqueResponse.statusCode == 200) {
          dynamic jsonData = json.decode(historiqueResponse.body);

          if (jsonData != null) {
            try {
              tempList.add(
                _SalesData(nom, jsonData),
              );
            } catch (e) {
              print("Erreur lors de la conversion de la chaîne en entier : $e");
            }
          }
        }
      }

      setState(() {
        dataSemestres = tempList;
      });

    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }
  Future<void> fetchEtudiants() async {
    try {
      final response = await http.get(Uri.parse(baseUrl+'statis/etudiants/nom'));
      var jsonResponse = jsonDecode(response.body);
      List<_SalesData> tempList = [];

      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['prenom'];
        final historiqueResponse = await http.get(Uri.parse(baseUrl+'statis/historique/etudiants/'+id.toString()));

        if (historiqueResponse.statusCode == 200) {
          dynamic jsonData = json.decode(historiqueResponse.body);

          if (jsonData != null) {
            try {
              tempList.add(
                _SalesData(nom, jsonData),
              );
            } catch (e) {
              print("Erreur lors de la conversion de la chaîne en entier : $e");
            }
          }
        }
      }

      setState(() {
        dataEtudiants = tempList;
      });

    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }
  Future<void> fetchAnnees() async {
    try {
      final response = await http.get(Uri.parse(baseUrl+'statis/annees/nom'));
      var jsonResponse = jsonDecode(response.body);
      List<_SalesData> tempList = [];

      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['annee'];
        final historiqueResponse = await http.get(Uri.parse(baseUrl+'statis/historique/annees/'+id.toString()));

        if (historiqueResponse.statusCode == 200) {
          dynamic jsonData = json.decode(historiqueResponse.body);

          if (jsonData != null) {
            try {
              tempList.add(
                _SalesData(nom, jsonData),
              );
            } catch (e) {
              print("Erreur lors de la conversion de la chaîne en entier : $e");
            }
          }
        }
      }

      setState(() {
        dataAnnees = tempList;
      });

    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
  }
  Future<void> fetchSalles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl+'statis/salles/nom'));
      var jsonResponse = jsonDecode(response.body);
      List<_SalesData> tempList = [];

      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['nom'];
        final historiqueResponse = await http.get(Uri.parse(baseUrl+'statis/historique/salles/'+id.toString()));

        if (historiqueResponse.statusCode == 200) {
          dynamic jsonData = json.decode(historiqueResponse.body);

          if (jsonData != null) {
            try {
              tempList.add(
                _SalesData(nom, jsonData),
              );
            } catch (e) {
              print("Erreur lors de la conversion de la chaîne en entier : $e");
            }
          }
        }
      }

      setState(() {
        dataSalles = tempList;
      });

    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
    }
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
  Future<void> fetch2() async {
    try {
      final response = await http.get(Uri.parse(baseUrl+'statis/examun/nom'));
      var jsonResponse = jsonDecode(response.body);
      List<OrdinalData> tempList = []; // Créer une liste temporaire

      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['type'];
        final historiqueResponse = await http.get(Uri.parse(baseUrl+'statis/historique/'+id.toString()));

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
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Card(
                  color: Colors.white,

                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: 'Nombre des tricheurs'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<_SalesData, String>>[
                      LineSeries<_SalesData, String>(
                        dataSource: showMatieres
                            ? dataMatieres
                            : (showEtudiants
                            ? dataEtudiants
                            : (showSalles
                            ? dataSalles
                            : (showFilieres
                            ? dataFilieres
                            : (showSemestres
                            ? dataSemestres
                            : (showAnnees ? dataAnnees : data))))),


                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) =>
                        (showEvaluations || showMatieres ||showEtudiants||showFilieres||showSemestres||showSalles||showAnnees) ? sales.sales : 0,
                        name: 'Tricheurs',
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Card(
                  color: Colors.white,

                  child:Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: showEvaluations,
                                onChanged: (value) {
                                  setState(() {
                                    showEvaluations = value!;
                                    showMatieres = false;
                                    showFilieres = false;
                                    showSemestres = false;
                                    showEtudiants = false;
                                    showAnnees = false;
                                    showSalles = false;
                                  });
                                },
                              ),
                              Text('Evaluation'),
                            ],
                          ),
                          SizedBox(width: 5,),
                          Row(
                            children: [
                              Checkbox(
                                value: showMatieres,
                                onChanged: (value) {
                                  setState(() {
                                    showMatieres = value!;
                                    showEvaluations = false;
                                    showFilieres = false;
                                    showSemestres = false;
                                    showEtudiants = false;
                                    showAnnees = false;
                                    showSalles = false;
                                  });
                                },
                              ),

                              Text('Matieres'),
                            ],
                          ),
                          SizedBox(width: 5,),
                          Row(
                            children: [
                              Checkbox(
                                value: showFilieres,
                                onChanged: (value) {
                                  setState(() {
                                    showFilieres = value!;
                                    showEvaluations = false;
                                    showMatieres = false;
                                    showSemestres = false;
                                    showEtudiants = false;
                                    showAnnees = false;
                                    showSalles = false;
                                  });
                                },
                              ),
                              Text('Filieres'),
                            ],
                          ),
                          SizedBox(width: 5,),
                          Row(
                            children: [
                              Checkbox(
                                value: showSemestres,
                                onChanged: (value) {
                                  setState(() {
                                    showSemestres = value!;
                                    showEvaluations = false;
                                    showFilieres = false;
                                    showMatieres = false;
                                    showEtudiants = false;
                                    showAnnees = false;
                                    showSalles = false;
                                  });
                                },
                              ),

                              Text('Semestres'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width:70,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: showEtudiants,
                                onChanged: (value) {
                                  setState(() {
                                    showEtudiants = value!;
                                    showEvaluations = false;
                                    showFilieres = false;
                                    showSemestres = false;
                                    showMatieres = false;
                                    showAnnees = false;
                                    showSalles = false;
                                  });
                                },
                              ),
                              Text('Etudiants'),
                            ],
                          ),
                          SizedBox(width: 5,),
                          Row(
                            children: [
                              Checkbox(
                                value: showSalles,
                                onChanged: (value) {
                                  setState(() {
                                    showSalles = value!;
                                    showEvaluations = false;
                                    showFilieres = false;
                                    showSemestres = false;
                                    showEtudiants = false;
                                    showAnnees = false;
                                    showMatieres = false;
                                  });
                                },
                              ),

                              Text('Salles'),
                            ],
                          ),
                          SizedBox(width: 5,),
                          Row(
                            children: [
                              Checkbox(
                                value: showAnnees,
                                onChanged: (value) {
                                  setState(() {
                                    showAnnees = value!;
                                    showEvaluations = false;
                                    showFilieres = false;
                                    showSemestres = false;
                                    showEtudiants = false;
                                    showMatieres = false;
                                    showSalles = false;
                                  });
                                },
                              ),
                              Text('Annees'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Card(
                  color: Colors.white,

                  child:  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SfSparkLineChart.custom(
                        trackball: SparkChartTrackball(
                            activationMode: SparkChartActivationMode.tap
                        ),
                        marker: SparkChartMarker(
                            displayMode: SparkChartMarkerDisplayMode.all
                        ),
                        labelDisplayMode: SparkChartLabelDisplayMode.all,
                        xValueMapper: (int index) =>
                        showMatieres==true
                            ? dataMatieres[index].year
                            : (showEtudiants==true
                            ? dataEtudiants[index].year
                            : (showSalles==true
                            ? dataSalles[index].year
                            : (showFilieres==true
                            ? dataFilieres[index].year
                            : (showSemestres==true
                            ? dataSemestres[index].year
                            : (showAnnees==true ? dataAnnees[index].year : data[index].year))))),
                        yValueMapper: (int index) {
                          if (showMatieres) {
                            if (!showEvaluations) {
                              return dataMatieres[index].sales;
                            } else {
                              return 0;
                            }
                          } else {
                            if (showEvaluations) {
                              return data[index].sales;
                            } else if (showEtudiants) {
                              return dataEtudiants[index].sales;
                            } else if (showSalles) {
                              return dataSalles[index].sales;
                            } else if (showFilieres) {
                              return dataFilieres[index].sales;
                            } else if (showSemestres) {
                              return dataSemestres[index].sales;
                            } else if (showAnnees) {
                              return dataAnnees[index].sales;
                            } else {
                              return 0;
                            }
                          }
                        },

                        dataCount: showMatieres ? dataMatieres.length
                            : (showEtudiants
                            ? dataEtudiants.length
                            : (showSalles
                            ? dataSalles.length
                            : (showFilieres
                            ? dataFilieres.length
                            : (showSemestres
                            ? dataSemestres.length
                            : (showAnnees ? dataAnnees.length : data.length))))),
                        //showMatieres==true ? dataMatieres.length : data.length,
                      ),
                    ),
                  ),
                ),
              ),
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

              // Container(
              //   child:

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

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final int sales;
}