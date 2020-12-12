import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/Profile/profile_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:flutter/material.dart';
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
          inAsyncCall: model.isBusy,
          opacity: 0.5,
          progressIndicator: circularProgress(),
          child: Scaffold(
            appBar: AppBar(
              title: Text("My Profile"),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: model.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: [
                      Container(
                        height: App(context).appHeight(0.2),
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
                            Text(model.user?.username ?? '',
                                style: Theme.of(context).textTheme.headline6),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildTile("Email", model.user?.email ?? "", context),
                          buildTile(
                              "Semester", model.user?.semester ?? " ", context),
                          buildTile(
                              "Branch", model.user?.branch ?? " ", context),
                          buildTile(
                              'College', model.user?.college ?? "", context),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
                            child: Text(
                              "Open pdf in",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      fontSize: 20, color: Colors.deepOrange),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              decoration: Constants.defaultDecoration.copyWith(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: []
                              ),
                              padding: const EdgeInsets.all(5),
                              child: DropdownButton(
                                elevation: 15,
                                value: model.userOption,
                                items: model.dropDownOfOpenPDF,
                                onChanged:
                                    model.changedDropDownItemOfOpenPdfChoice,
                                dropdownColor:
                                    Theme.of(context).colorScheme.background,
                                focusColor:
                                    Theme.of(context).colorScheme.background,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 60),
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FlatButton(
                          child: Text(
                            "Log out",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            model.handleSignOut(context);
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
          ),
        );
      },
      viewModelBuilder: () => ProfileViewModel(),
    );
  }
}

Widget buildTile(String title, String subtitle, BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
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
    ),
  );
}
