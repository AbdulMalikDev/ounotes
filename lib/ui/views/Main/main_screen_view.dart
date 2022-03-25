import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/ui/views/Main/main_screen_viewmodel.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/smart_widgets/default_app_bar/default_app_bar_view.dart';

class MainScreenView extends StatefulWidget {
  final bool shouldShowUpdateDialog;
  final Map<String, dynamic> versionDetails;
  const MainScreenView({Key key, this.shouldShowUpdateDialog, this.versionDetails})
      : super(key: key);
  @override
  _MainScreenViewState createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainScreenViewModel>.reactive(
      viewModelBuilder: () => MainScreenViewModel(),
      onModelReady: (model) {
        model.updateDialog(
            widget.shouldShowUpdateDialog, widget.versionDetails);
      },
      builder: (
        BuildContext context,
        MainScreenViewModel model,
        Widget child,
      ) {
        return WillPopScope(
          onWillPop: () => Helper.showWillPopDialog(context: context),
          child: RateMyAppBuilder(
            builder: (context) => ThemeSwitchingArea(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SafeArea(
                  bottom: false,
                  child: Scaffold(
                      extendBody: true,
                      // drawer: DrawerView(),
                      appBar: DefaultAppBarView(
                        showNotificationButton: model.currIdx == 0,
                      ),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      // appBar: model.isEditPressed
                      //     ? AppBar(
                      //         leading: IconButton(
                      //           icon: Icon(
                      //             Icons.arrow_back,
                      //             color: Colors.white,
                      //           ),
                      //           onPressed: () {
                      //             model.setIsEditPressed = false;
                      //             model.resetUserSelectedSubjects();
                      //           },
                      //         ),
                      //         title: ValueListenableBuilder(
                      //           valueListenable: model.userSelectedSubjects,
                      //           builder: (context, userSelectedSubjects, child) {
                      //             return Text(
                      //               "${userSelectedSubjects.length} Selected",
                      //               style: theme.appBarTheme.textTheme.headline6,
                      //             );
                      //           },
                      //         ),
                      //         backgroundColor: theme.appBarTheme.color,
                      //         actions: [
                      //           IconButton(
                      //             icon: Icon(
                      //               Icons.delete,
                      //               color: Colors.white,
                      //             ),
                      //             onPressed: () {
                      //               print('delete pressed');
                      //               Helper.showDeleteConfirmDialog(
                      //                 context: context,
                      //                 onDeletePressed: () {
                      //                   Navigator.pop(context);
                      //                   model.deleteSelectedSubjects();
                      //                 },
                      //                 msg:
                      //                     "Are you sure you want to delete these subjects?",
                      //               );
                      //             },
                      //           ),
                      //         ],
                      //       )
                      //     : AppBar(
                      //         leading: Builder(builder: (BuildContext context) {
                      //           return DescribedFeatureOverlay(
                      //             featureId: OnboardingService
                      //                 .drawer_hamburger_icon_to_access_other_features, // Unique id that identifies this overlay.
                      //             tapTarget: const Icon(Icons
                      //                 .menu), // The widget that will be displayed as the tap target.
                      //             title: Text('Drawer'),
                      //             description:
                      //                 Text('Find cool new features in the drawer'),
                      //             backgroundColor: Theme.of(context).primaryColor,
                      //             targetColor: Colors.white,
                      //             textColor: Colors.white,
                      //             onComplete: () {
                      //               Scaffold.of(context).openDrawer();
                      //               return Future.value(true);
                      //             },
                      //             child: IconButton(
                      //               icon: Icon(Icons.menu),
                      //               onPressed: () => Scaffold.of(context).openDrawer(),
                      //             ),
                      //           );
                      //         }),
                      //         iconTheme: IconThemeData(
                      //           color: Colors.white, //change your color here
                      //         ),
                      //         title: Text(
                      //           'My Subjects',
                      //           style: theme.appBarTheme.textTheme.headline6,
                      //         ),
                      //         backgroundColor: theme.appBarTheme.color,
                      //         actions: <Widget>[
                      //           IconButton(
                      //             icon: Icon(
                      //               MdiIcons.pencil,
                      //               color: Colors.white,
                      //             ),
                      //             onPressed: () {
                      //               model.setIsEditPressed = true;
                      //             },
                      //           ),
                      //           IconButton(
                      //             icon: Icon(
                      //               Icons.search,
                      //               color: Colors.white,
                      //             ),
                      //             onPressed: () {
                      //               showSearch(
                      //                   context: context,
                      //                   delegate: SearchView(path: Path.Appbar));
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      // floatingActionButtonLocation:
                      //     FloatingActionButtonLocation.centerDocked,
                      // floatingActionButton: FloatingActionButton(
                      //   key: ValueKey("MainScreen"),
                      //   backgroundColor: Theme.of(context).accentColor,
                      //   onPressed: () {},
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Icon(
                      //       Icons.upload_sharp,
                      //     ),
                      //   ),
                      //   tooltip: "Upload",
                      // ),
                      bottomNavigationBar: BottomAppBar(
                        shape: CircularNotchedRectangle(),
                        notchMargin: 2,
                        clipBehavior: Clip.antiAlias,
                        // color: Theme.of(context).appBarTheme.backgroundColor,
                        child: BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          iconSize: 32.0,
                          currentIndex: model.currIdx,
                          showSelectedLabels: true,
                          selectedItemColor: Colors.white,
                          unselectedIconTheme: IconThemeData(
                            color: AppStateNotifier.isDarkModeOn
                                ? Colors.grey
                                : Colors.black,
                            opacity: 0.6,
                          ),
                          selectedIconTheme: IconThemeData(
                            color: Colors.white,
                            opacity: 0.9,
                          ),
                          selectedLabelStyle:
                              Theme.of(context).textTheme.bodyText1,
                          unselectedLabelStyle:
                              Theme.of(context).textTheme.bodyText1,
                          showUnselectedLabels: true,
                          unselectedItemColor: AppStateNotifier.isDarkModeOn
                              ? Colors.grey
                              : Colors.black54,
                          onTap: model.onIconTapped,
                          items: [
                            BottomNavigationBarItem(
                                icon: Icon(Icons.home), label: 'Home'),
                            BottomNavigationBarItem(
                              icon: Icon(MdiIcons.filter),
                              label: 'Filter',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(MdiIcons.upload),
                              label: 'Upload',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.download_rounded),
                              label: 'Downloads',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.settings),
                              label: 'Settings',
                            ),
                          ],
                        ),
                      ),
                      body: model.screens[model.currIdx]),
                ),
              ),
            ),
            onInitialized: (context, rateMyApp) {},
          ),
        );
      },
    );
  }
}
