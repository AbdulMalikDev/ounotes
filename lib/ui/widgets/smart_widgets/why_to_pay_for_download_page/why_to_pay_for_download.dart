import 'package:FSOUNotes/misc/constants.dart';
import 'package:flutter/material.dart';

class WhyToPayForDownloadView extends StatelessWidget {
  final String price;
  WhyToPayForDownloadView({this.price});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -30,
              left: 0,
              child: Container(
                height: 120,
                width: 120,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login_top.png"),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: 0,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login_bottom.png"),
                  ),
                ),
              ),
            ),
            Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: Image(
                        image: AssetImage('assets/images/why.jpg'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "It Sucks !",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: primary),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "₹10 per download ??",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: primary),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "LOREM IPSUM",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.teal.shade400),
                  ),
                  Text(
                    "Suspendisse at pharetra augue, porttit",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.teal.shade400),
                  ),
                  Text(
                    "Proin arcu mauris, fringilla id ex",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.teal.shade400),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
