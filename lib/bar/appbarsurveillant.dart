import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class CustomAppBarSurveillant extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarSurveillant({Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SingleChildScrollView(
        child: Column(
          children: [
            // StackWidgetFiliere(id: widget.id,)
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(30),
                    color: Colors.blueAccent,
                  ),
                  height: 200,
                  child:
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    title: Text('Hello Ahad!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white
                    )),
                    subtitle: Text('Good Morning', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white54
                    )),
                    trailing: const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('images/image2.jpg'),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    elevation: 0,
    centerTitle: false,
    title: Text('Dashboard'),
    actions: <Widget>[
      IconButton(
        icon: SvgPicture.asset("assets/icons/notification.svg"),
        onPressed: () {},
      ),
    ],
  );
}
