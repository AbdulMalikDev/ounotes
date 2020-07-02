import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';

class DrawerHeaderView extends StatelessWidget {
  const DrawerHeaderView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: App(context).appScreenHeightWithOutSafeArea(0.3),
      child: DrawerHeader(
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade400,
              Colors.teal.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              //color: Colors.yellow,
              child: Row(
                children: <Widget>[
                  // Container(
                  //   height: 30,
                  //   width: 40,
                  //   child: Image(
                  //     image: AssetImage('assets/images/OU_Logo.jpg'),
                  //   ),
                  // ),
                  SizedBox(width: 10,),
                  Text(
                    'OU Notes',
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 25),
                  ),
                ],
              ),
            ),
            //SizedBox(height: screenHeightWithoutSafeArea * 0.0125),
            Container(
              //color: Colors.yellow,
              //  alignment: Alignment.centerRight,
              height: App(context).appScreenHeightWithOutSafeArea(0.2),
              width: App(context).appScreenWidthWithOutSafeArea(0.3),
              //padding: EdgeInsets.only(left: 20),
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.3,
                  child: Image(image: AssetImage("assets/images/apnaicon.png")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
