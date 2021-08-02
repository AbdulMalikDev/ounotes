import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/default_app_bar/back_icon_app_bar.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/default_app_bar/back_icon_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../settings_view.dart';
import 'account_info_viewmodel.dart';

class AccountInfoView extends StatelessWidget {
  const AccountInfoView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var subtitle1 =
        Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 16);
    var iconColor = AppStateNotifier.isDarkModeOn
        ? theme.iconTheme.color
        : Colors.black.withOpacity(0.6);
    return ViewModelBuilder<AccountInfoViewModel>.reactive(
      viewModelBuilder: () => AccountInfoViewModel(),
      onModelReady: (model) async {
        await model.setUser();
      },
      builder: (
        BuildContext context,
        AccountInfoViewModel model,
        Widget child,
      ) {
        return Scaffold(
          appBar: BackIconTitleAppBar(
            title: "Account Settings",
          ),
          body: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SettingsTile(
                        title: "Email",
                        subTitle: model.user?.email ?? "",
                        icon: Icon(Icons.email, color: iconColor),
                      ),
                      SettingsTile(
                        title: "Semester",
                        subTitle: model.user?.semester ?? "",
                        icon: Icon(Icons.calendar_today, color: iconColor),
                      ),
                      SettingsTile(
                        title: "Branch",
                        subTitle: model.user?.branch ?? "",
                        icon: Icon(Icons.person, color: iconColor),
                      ),
                      SettingsTile(
                        title: "College",
                        subTitle: model.user?.college ?? "",
                        largeSubtitle: true,
                        icon: Icon(
                          Icons.school_sharp,
                          color: iconColor,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: const EdgeInsets.symmetric(horizontal: 70),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            primary: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            "CHANGE INFORMATION",
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          onPressed: () {
                            model.changeProfileData();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
