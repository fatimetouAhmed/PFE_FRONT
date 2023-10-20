import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/screens/lists/listexamun.dart';
import 'package:pfe_front_flutter/screens/lists/listsurveillant.dart';
import '../../bar/masterpageadmin.dart';
import '../lists/listpv.dart';
import '../lists/listuser.dart';
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
class DashBoardSurveillance extends StatelessWidget {
  late Size size;
  String accessToken;
  final String nomDep;
  final String nomNiv;
  DashBoardSurveillance({required this.accessToken, required this.nomDep, required this.nomNiv});
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return  Scaffold(
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
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  createGridItem(0),
                  createGridItem(1),
                  createGridItem(2),
                  createGridItem(3),
                  createGridItem(4),
                  // createGridItem(5),
                  // createGridItem(6),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget createGridItem(int position) {
    Color? color = Colors.white;
    late Widget icondata;
    late Widget child_widget;
    // Use late to indicate it will be assigned before use
    String label='Superviseurs';
    switch (position) {
      case 0:
        color = Colors.white;
        icondata = CircleAvatar(radius: 30, backgroundColor: Colors.transparent, backgroundImage: AssetImage('images/superviseurs.png'),);
        label='Superviseurs';
        child_widget= MasterPage(index: 0,accessToken: accessToken, child: ListUser(  accessToken: accessToken),);
        break;
      case 1:
        color = Colors.white;
        icondata = CircleAvatar(radius: 30, backgroundColor: Colors.transparent, backgroundImage: AssetImage('images/suveillant.png'),);
        label='Surveillants';
        child_widget= MasterPage(index: 0,accessToken: accessToken, child: ListUser(  accessToken: accessToken),);
        break;
      case 2:
        color = Colors.white;
        icondata = CircleAvatar(radius: 30, backgroundColor: Colors.transparent, backgroundImage: AssetImage('images/surveillances.png'),);
        label='Surveillances';
        child_widget= MasterPage(index: 0,accessToken: accessToken, child: ListSurveillance(  accessToken: accessToken,nomDep: nomDep, nomNiv: nomNiv,),);
        break;
      case 3:
        color = Colors.white;
        icondata = CircleAvatar(radius: 30, backgroundColor: Colors.transparent, backgroundImage: AssetImage('images/examuns.png'),);
        label='Evaluations';
        child_widget=
            MasterPage(index: 0,accessToken: accessToken, child: ListExamun(  accessToken: accessToken, nomDep: nomDep, nomNiv: nomNiv,),);
        break;
      case 4:
        color = Colors.white;
        icondata = CircleAvatar(radius: 30, backgroundColor: Colors.transparent, backgroundImage: AssetImage('images/pvs.png'),);
        label='Procès verbals';
        child_widget= MasterPage(index: 0,accessToken: accessToken, child: PvHome(  accessToken: accessToken),);
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => child_widget,
                  ),
                );
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
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    )
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