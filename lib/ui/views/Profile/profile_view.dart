import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/Profile/profile_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      onModelReady: (model) => model.setUser(),
      builder: (context, model, child) {
        return ModalProgressHUD(
          inAsyncCall: model.isBusy ? true : false,
          opacity: 0.5,
          progressIndicator: circularProgress(),
          child: Scaffold(
            appBar: AppBar(
              title: Text("My Profile"),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Container(
              height: App(context).appScreenHeightWithOutSafeArea(1),
              child:
                  //  SingleChildScrollView(

                  //     child:
                  SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 150,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: App(context)
                                .appScreenHeightWithOutSafeArea(0.12),
                            width: App(context)
                                .appScreenWidthWithOutSafeArea(0.32),
                            child: Image.asset(
                              "assets/images/apnaicon.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FittedBox(
                            child: Text(model.user.username ?? '',
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        ],
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildTile("Email", model.user.email ?? "", context),
                          buildTile(
                              "Semester", model.user.semester ?? " ", context),
                          buildTile(
                              "Branch", model.user.branch ?? " ", context),
                          buildTile(
                              'College', model.user.college ?? "", context),
                        ]),
                    SizedBox(
                      height: 38,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.7,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: FlatButton(
                        child: Text(
                          "CHANGE INFORMATION",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          model.handleSignOut();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ),
        );
      },
      viewModelBuilder: () => ProfileViewModel(),
    );
  }
}

ListTile buildTile(String title, String subtitle, BuildContext context) {
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      child: Icon(
        FontAwesomeIcons.solidCircle,
        size: 12.0,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    title: Text(
      title,
      style: Theme.of(context)
          .textTheme
          .subtitle1
          .copyWith(fontSize: 20, color: Colors.deepOrange),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 18),
        ),
      ],
    ),
    // trailing: Divider(
    //   color: Colors.grey[600],
    // ),
  );
}
