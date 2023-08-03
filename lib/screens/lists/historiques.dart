import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/models/Historique.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Historiques extends StatefulWidget {
  @override
  _HistoriquesState createState() => _HistoriquesState();
}

class _HistoriquesState extends State<Historiques> {
  List<Historique> historiquesList = [];

  Future<List<Historique>> fetchHistoriques() async {
    var headers = {"Content-Type": "application/json; charset=utf-8"};
    var response = await http.get(Uri.parse('http://192.168.186.113:8000/historiques/historiques/'), headers: headers);

    var data = utf8.decode(response.bodyBytes); // Ensure UTF-8 decoding
    //print(data);
    var historiques = <Historique>[];
    for (var u in jsonDecode(data)) {
      var examuns_date = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['examuns_date']);
      historiques.add(
          Historique(u['id'], u['description'], u['examuns'], examuns_date));
    }

    return historiques;
  }
    void _showNotificationContent(String content) {
    showDialog(
      context: context,
      builder: (BuildContext context)  {
        return CustomPopupDialog(content: content);
      },
    );
  }
  @override
  void initState() {
    super.initState();
    fetchHistoriques().then((historiques) {
      setState(() {
        historiquesList = historiques;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
            _top(),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45), topRight: Radius.circular(45)),
                  color: Colors.white,
                ),
                child: FutureBuilder<List<Historique>>(
                  future: fetchHistoriques(),
                  builder: (BuildContext context, AsyncSnapshot<List<Historique>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      var historiques = snapshot.data!;
                      return ListView.builder(

                        itemCount: historiques.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var historique = historiques[index];
                          return GestureDetector(
                            onTap: () => _showNotificationContent(historique.description),
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              elevation: 0,
                              child: Row(
                                children: [
                                  Avatar(
                                    margin: EdgeInsets.only(right: 20),
                                    size: 60,
                                    image: 'images/history1.jpg',
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              historique.examuns,
                                              style: TextStyle(
                                                  fontSize: 17, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              DateFormat('yyyy-MM-dd HH:mm').format(historique.examuns_date),
                                              style: TextStyle(
                                                  color: Colors.grey, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          historique.description,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historiques\n',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}

class CustomPopupDialog extends StatelessWidget {
  final String content;

  CustomPopupDialog({required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
