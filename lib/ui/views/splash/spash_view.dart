import 'package:FSOUNotes/ui/views/splash/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      viewModelBuilder: () => SplashViewModel(),
      // onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset("assets/images/apnaicon.png"),
              ),
              SizedBox(height: 30,),
              CircularProgressIndicator(strokeWidth: 3,valueColor: AlwaysStoppedAnimation(Color(0xff19c7c1)),),
            ],
          ),
        ),
      ),
    );
  }
}
