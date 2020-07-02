import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AllDocumentsViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  DialogService _dialogService = locator<DialogService>();

  String _subjectName;

  set subjectName(String name) {
    _subjectName = name;
  }

  onUploadButtonPressed() {
    _navigationService.navigateTo(Routes.uploadSelectionViewRoute,
        arguments: UploadSelectionViewArguments(subjectName: _subjectName));
  }

  handleStartup(BuildContext context) async {
   bool shouldShow = await _sharedPreferencesService.shouldIShowIntroDialog();
   print(shouldShow);
   if (shouldShow) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  "Welcome !",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 18),
                ),
                content: SingleChildScrollView(
                  child: Text(
                    "This is a student-community driven application. We do not upload all resources but give you a platform to do so.\n\nPlease Make sure you upload the best resources so that all students can benefit !\n\nThe Application is open-sourced on Github. Make sure to check it out and contribute!\n\n~Yours Sincerely\n   Abdul Malik & Syed Wajid\n   Founders, OU Notes",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 18),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                      child: Text(
                        "Ok",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]);
          });
    }
 }
}
