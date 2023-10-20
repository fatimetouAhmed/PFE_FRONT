import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../bar/masterpageadmin.dart';
import '../../models/departement.dart';
import '../lists/listsemestre.dart';
import 'dashbord2.dart';
import 'package:http/http.dart' as http;
import '../../consturl.dart';
const double _kItemExtent = 32.0;

class DatePickerApp extends StatelessWidget {
  const DatePickerApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: DashBoardAnnee(),
    );
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
    paint.color = Colors.blueAccent!;
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DashBoardAnnee extends StatefulWidget {
  const DashBoardAnnee({Key? key});

  @override
  State<DashBoardAnnee> createState() => _DashBoardAnneeState();
}

class _DashBoardAnneeState extends State<DashBoardAnnee> {
  late Size size;
  List<List<String>> anneesList = [];
  List<String> departementsList = [];
  List<String> formationsList = [];
  List<String> niveausList = [];
  DateTime date1 = DateTime.now(); // Initialisation par défaut à la date actuelle
  DateTime date2 = DateTime.now();
  int _selectedAnnee = 0;
  int _selectedDepartement = 0;
  int _selectedFormation = 0;
  bool _isAnneeSelected = false;
  int _selectedNiveau = 0;
  int id_annee=0;
  bool _isSelectDepartement=false;
  bool isSelectNiveau=false;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    // print('Date 1 sélectionnée : ${date1.toString()}');
    // print('Date 2 sélectionnée : ${date2.toString()}');
    // print(departementsList[_selectedDepartement]);
    // print(formationsList[_selectedFormation]);
    // print(niveausList[_selectedNiveau]);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MasterPage(index: 0,accessToken: '', child: DashBoard2(accessToken: '',nomDep: departementsList[_selectedDepartement],  nomNiv: niveausList[_selectedNiveau],),),
      ),
    );
  }

  Future<List<List<String>>> fetchAnnees() async {
    var response = await http.get(Uri.parse(baseUrl+'annees/annee_universitaire'));
    var annees = <List<String>>[];
    for (var u in jsonDecode(response.body)) {
      annees.add([u['annee_debut'], u['annee_fin']]);
    }// print(annees);
    return annees;
  }
  Future<List<String>> fetchDepartements(String id) async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'annees/departements/' + id));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> departements = [];
        for (var u in data) {
          var nomDepartement = u;
          if (nomDepartement is String) {
            departements.add(nomDepartement);
          }
        }
        return departements;
      } else {
        throw Exception('Erreur lors de la requête à l\'API');
      }
    } catch (e) {
      print('Erreur: $e');
      throw e;
    }
  }
  Future<List<String>> fetchFormations(String nom) async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'annees/formations/$nom' ));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> formations = [];
        for (var u in data) {
          var nomFormation = u;
          if (nomFormation is String) {
            formations.add(nomFormation);
          }
        }
        return formations;
      } else {
        throw Exception('Erreur lors de la requête à l\'API');
      }
    } catch (e) {
      print('Erreur: $e');
      throw e;
    }
  }
  Future<List<String>> fetchNiveaus(String nom) async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'annees/niveaus/$nom'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> niveaus = [];
        for (var u in data) {
          var nomNiveau = u;
          if (nomNiveau is String) {
            niveaus.add(nomNiveau);
          }
        }
        return niveaus;
      } else {
        throw Exception('Erreur lors de la requête à l\'API');
      }
    } catch (e) {
      print('Erreur: $e');
      throw e;
    }
  }
  Future<int?> fetchAnnees_by_id(String annee1,String annee2) async {
    var response = await http.get(Uri.parse(baseUrl+'annees/annee_universitaire_by_id/$annee1/$annee2'));
    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      return jsonData;
    }
    return null;
  }
  void initState() {
    super.initState();
    fetchAnnees().then((annees) {
      setState(() {
       anneesList = annees;
       date1 = DateTime(int.parse(anneesList[0][0]));
       date2 = DateTime(int.parse(anneesList[1][0]));
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: CustomPaint(
              painter: ShapesPainter(),
              child: Container(
                height: size.height / 2,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    width: 350,
                    height: 500,
                    child: createGridItem(0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createGridItem(int position) {
    Color? color = Colors.white;
    late Widget icondata;
    late Widget select;

    String label = 'Années Scolaire';

    switch (position) {
      case 0:
        color = Colors.white;
        icondata = CircleAvatar(radius: 40, backgroundColor: Colors.transparent, backgroundImage: AssetImage('images/years.png'),);
        select = CupertinoPageScaffold(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            _showDialog(
                              CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: _kItemExtent,
                                scrollController: FixedExtentScrollController(
                                  initialItem: _selectedAnnee,
                                ),
                                onSelectedItemChanged: (
                                    int selectedItem) {
                                  setState(() {
                                    _selectedAnnee = selectedItem;
                                    _isAnneeSelected = true;
                                  });
                                  fetchAnnees_by_id('${anneesList[_selectedAnnee][0]}', '${anneesList[_selectedAnnee][1]}').then((id_annee) {
                                    if (id_annee != null) {
                                      // Faites quelque chose avec id_annee ici
                                      fetchDepartements(id_annee.toString()).then((nom) {
                                        setState(() {
                                          departementsList = nom;
                                          print(departementsList);
                                        });
                                      });
                                    } else {
                                      print('La requête n\'a pas abouti.');
                                    }
                                  });
                                },
                                children: List<Widget>.generate(
                                  anneesList.length,
                                      (int index) {
                                    return Center(
                                      child: Text(
                                        '${anneesList[index][0]} -- ${anneesList[index][1]}',
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                    );
                                  },
                                ),

                              ),
                            ),
                        child: Text(
                          _selectedAnnee < anneesList.length
                              ? '${anneesList[_selectedAnnee][0]} -- ${anneesList[_selectedAnnee][1]}'
                              : 'Invalid Annee',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),

                      ),
                      // ),

                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (_isAnneeSelected == true)
                        Row(
                          children: [
                            const Text(
                              'Departement: ',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  _showDialog(
                                    CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: _kItemExtent,
                                      scrollController: FixedExtentScrollController(
                                        initialItem: _selectedDepartement,
                                      ),
                                      onSelectedItemChanged: (
                                          int selectedItem) {

                                        setState(() {
                                          _selectedDepartement = selectedItem;
                                          if (_selectedDepartement < departementsList.length) {
                                            fetchFormations(
                                                departementsList[_selectedDepartement])
                                                .then((nom) {
                                              setState(() {
                                                formationsList = nom;
                                                print(formationsList);
                                              });
                                            });

                                          }
                                          _isSelectDepartement=true;
                                        });

                                      },
                                      children: List<Widget>.generate(
                                        departementsList.length,  // Corrected variable name
                                            (int index) {
                                          return Center(
                                              child: Text(
                                                  departementsList[index]));  // Corrected variable name
                                        },
                                      ),
                                    ),
                                  ),
                              child: Text(
                                _selectedDepartement < departementsList.length  // Corrected variable name
                                    ? departementsList[_selectedDepartement]  // Corrected variable name
                                    : 'Invalid ',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),

                      Visibility(
                          visible: _isSelectDepartement==true,
                          child: Row(
                            children: [
                              const Text(
                                'Formation: ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    _showDialog(
                                      CupertinoPicker(
                                        magnification: 1.22,
                                        squeeze: 1.2,
                                        useMagnifier: true,
                                        itemExtent: _kItemExtent,
                                        scrollController: FixedExtentScrollController(
                                          initialItem: _selectedFormation,
                                        ),
                                        onSelectedItemChanged: (
                                            int selectedItem) {
                                          setState(() {
                                            _selectedFormation = selectedItem;
                                            isSelectNiveau=true;
                                            if (_selectedFormation < formationsList.length) {
                                              fetchNiveaus(
                                                  formationsList[_selectedFormation])
                                                  .then((nom) {
                                                setState(() {
                                                  niveausList = nom;
                                                  print(niveausList);
                                                });
                                              });
                                            }

                                          });

                                        },
                                        children: List<Widget>.generate(
                                          formationsList.length,
                                              (int index) {
                                            return Center(
                                                child: Text(
                                                    formationsList[index]));
                                          },
                                        ),
                                      ),
                                    ),
                                child: Text(
                                  _selectedFormation < formationsList.length
                                      ? formationsList[_selectedFormation]
                                      : 'Invalid ',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible:isSelectNiveau==true,
                          child: Row(
                            children: [
                              const Text(
                                'Niveau: ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    _showDialog(
                                      CupertinoPicker(
                                        magnification: 1.22,
                                        squeeze: 1.2,
                                        useMagnifier: true,
                                        itemExtent: _kItemExtent,
                                        scrollController: FixedExtentScrollController(
                                          initialItem: _selectedNiveau,
                                        ),
                                        onSelectedItemChanged: (
                                            int selectedItem) {
                                          setState(() {
                                            _selectedNiveau = selectedItem;
                                            // fetchNiveausId(_selectedNiveau.toString()).then((id_niv) {
                                            //   setState(() {
                                            //
                                            //   });
                                            // });
                                          });
                                        },
                                        children: List<Widget>.generate(
                                          niveausList.length,
                                              (int index) {
                                            return Center(
                                                child: Text(
                                                    niveausList[index]));
                                          },
                                        ),
                                      ),
                                    ),
                                child: Text(
                                  _selectedNiveau < niveausList.length
                                      ? niveausList[_selectedNiveau]
                                      : 'Invalid ',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          child: Text(
                            'Next',
                            style: TextStyle(fontSize: 22.0),
                          ),
                          onPressed: () => _onSubmit(context),
                        ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        break;
    }

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5, top: 5),
          child: Card(
            elevation: 10,
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.white),
            ),
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => child_widget,
                //   ),
                // );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icondata,

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        label,
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    select,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
