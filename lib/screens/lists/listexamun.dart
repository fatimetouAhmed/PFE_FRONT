import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/models/examun.dart';
import '../../../constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../bar/masterpageadmin.dart';
import '../forms/examunform.dart';

class ListExamun extends StatefulWidget {
  final String accessToken;

  ListExamun({Key? key,required this.accessToken}) : super(key: key);

  @override
  _ListExamunState createState() => _ListExamunState();
}

class _ListExamunState extends State<ListExamun> {
  List<Examun> examunList = [];

  Future<List<Examun>> fetchExamuns() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/examuns/'),headers: headers);
    var examuns = <Examun>[];
    for (var u in jsonDecode(response.body)) {
      // print(u['heure_deb']);
      // print(u['heure_fin']);

      var heureDeb = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['heure_deb']);
      var heureFin = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['heure_fin']);

      examuns.add(Examun(u['id'],u['type'],heureDeb,heureFin, u['id_mat'], u['id_sal']));
    }
    print(examuns);
    return examuns;
  }

  Future delete(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    await http.delete(Uri.parse('http://127.0.0.1:8000/examuns/' + id),headers: headers);
  }

  @override
  void initState() {
    super.initState();
    fetchExamuns().then((examun) {
      setState(() {
        examunList = examun;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return      SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 340, child: _head()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Examuns',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MasterPage(
                                      index: 0,  accessToken: widget.accessToken,

                                        child:
                                      ExamunForm(examun: Examun(0, '', DateTime.parse('0000-00-00 00:00:00'),DateTime.parse('0000-00-00 00:00:00'), 0, 0),  accessToken: widget.accessToken
                                      ),

                                    ),
                              ),
                              // ),
                            );
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40.0,
                            semanticLabel: 'Add',
                            weight: 600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Container(
                    height: MediaQuery.of(context).size.height - 370,
                    child:Scaffold(
                      body: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 2,
                        ),
                        child: FutureBuilder<List<Examun>>(
                          future: fetchExamuns(),
                          builder: (BuildContext context, AsyncSnapshot<List<Examun>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              var examuns = snapshot.data!;
                              return ListView.separated(
                                itemCount: examuns.length,
                                separatorBuilder: (BuildContext context, int index) =>
                                    SizedBox(height: 16), // Spacing of 16 pixels between each item
                                itemBuilder: (BuildContext context, int index) {
                                  var examun = examuns[index];
                                  return InkWell(
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: <Widget>[
                                        Container(
                                          height: 136,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(22),
                                            color: Colors.blue,
                                            boxShadow: [kDefaultShadow],
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(22),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: SizedBox(
                                            height: 136,
                                            width: size.width - 200,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        examun.type,
                                                        style: Theme.of(context).textTheme.button,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        DateFormat('HH:mm').format(examun.heure_deb),
                                                        style: Theme.of(context).textTheme.button,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        // DateFormat('yyyy-MM-dd HH:mm:ss').format(examun.heure_fin),
                                                        // DateFormat('MM-dd HH:mm').format(examun.heure_fin),
                                                        DateFormat('HH:mm').format(examun.heure_fin),
                                                        style: Theme.of(context).textTheme.button,
                                                      ),
                                                      SizedBox(width: 8),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => MasterPage(
                                                                index: 0,accessToken: widget.accessToken,
                                                                child:
                                                              ExamunForm(
                                                                examun: examun,  accessToken: widget.accessToken

                                                              ),),

                                                            ),
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons.edit,
                                                          color: Colors.blue,
                                                          size: 24.0,
                                                          semanticLabel: 'Edit',
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Alert(
                                                            context: context,
                                                            type: AlertType.warning,
                                                            title: "Confirmation",
                                                            desc: "Are you sure you want to delete this item?",
                                                            buttons: [
                                                              DialogButton(
                                                                child: Text(
                                                                  "Cancel",
                                                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                color: Colors.red,
                                                                radius: BorderRadius.circular(20.0),
                                                              ),
                                                              DialogButton(
                                                                child: Text(
                                                                  "Delete",
                                                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                                                ),
                                                                onPressed: () async {
                                                                  await delete(examun.id.toString());
                                                                  setState(() {});
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => MasterPage(
                                                                        index: 0,accessToken: widget.accessToken,
                                                                        child: ListExamun(accessToken: widget.accessToken,),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                color: Colors.blue,
                                                                radius: BorderRadius.circular(20.0),
                                                              ),
                                                            ],
                                                          ).show();
                                                        },

                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                          size: 24.0,
                                                          semanticLabel: 'Delete',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: kDefaultPadding * 1.5,
                                                    vertical: kDefaultPadding / 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(22),
                                                      topRight: Radius.circular(22),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    examun.id.toString(),
                                                    style: Theme.of(context).textTheme.button,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // ),
    );
  }
}


Widget _head() {
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  left: 340,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Color.fromRGBO(250, 250, 250, 0.1),
                      child: Icon(
                        Icons.notification_add_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gestion des Examuns',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      Positioned(
        top: 140,
        left: 37,
        child: Container(
          height: 170,
          width: 320,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey,
                offset: Offset(0, 6),
                blurRadius: 12,
                spreadRadius: 6,
              ),
            ],
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total des Examuns',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      '65',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '15',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '50',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ],
  );
}
