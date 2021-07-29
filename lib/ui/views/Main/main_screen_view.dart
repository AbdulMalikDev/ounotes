import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_InputScreen/fd_inputView.dart';
import 'package:FSOUNotes/ui/views/Settings/settings_view.dart';
import 'package:FSOUNotes/ui/views/downloads/Downloads_view.dart';
import 'package:FSOUNotes/ui/views/home/home_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/default_app_bar/default_app_bar_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/subjects_dialog/subjects_dialog_view.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pimp_my_button/pimp_my_button.dart';
import 'package:rate_my_app/rate_my_app.dart';

class MainView extends StatefulWidget {
  const MainView({Key key}) : super(key: key);
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  List<Widget> _screens = [];

  void onPageChanged(int idx) {
    print('onPageChanged Idx: ' + idx.toString());
    setState(() {
      _selectedIndex = idx;
    });
  }

  void onIconTapped(int pageIdx) {
    print('selectedIndex: ' + pageIdx.toString());
    _pageController.jumpToPage(pageIdx);
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeView(),
      FDInputView(),
      DownLoadView(),
      SettingsView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Helper.showWillPopDialog(context: context),
      child: RateMyAppBuilder(
        builder: (context) => ThemeSwitchingArea(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: Scaffold(
                // drawer: DrawerView(),
                appBar: DefaultAppBarView(),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                bottomNavigationBar: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  notchMargin: 1.0,
                  clipBehavior: Clip.antiAlias,
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    elevation: 999.0,
                    iconSize: 32.0,
                    currentIndex: _selectedIndex,
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
                    selectedLabelStyle: Theme.of(context).textTheme.bodyText1,
                    unselectedLabelStyle: Theme.of(context).textTheme.bodyText1,
                    showUnselectedLabels: true,
                    unselectedItemColor: AppStateNotifier.isDarkModeOn
                        ? Colors.grey
                        : Colors.black54,
                    onTap: onIconTapped,
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(
                        icon: Icon(MdiIcons.filter),
                        label: 'Filter',
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
                body: PageView(
                  controller: _pageController,
                  children: _screens,
                  onPageChanged: onPageChanged,
                  physics: NeverScrollableScrollPhysics(),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: DescribedFeatureOverlay(
                    featureId: OnboardingService
                        .floating_action_button_to_add_subjects, // Unique id that identifies this overlay.
                    tapTarget: const Icon(Icons
                        .add), // The widget that will be displayed as the tap target.
                    title: Text('Add Your Subjects !'),
                    description: Text(
                        'Please use \"+\" button to add subjects and swipe left or right to delete them'),
                    backgroundColor: Theme.of(context).primaryColor,
                    targetColor: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    child: PimpedButton(
                      particle: DemoParticle(),
                      pimpedWidgetBuilder: (context, controller) {
                        return FloatingActionButton(
                          onPressed: () async {
                            controller.forward(from: 0.4);
                            await Future.delayed(Duration(milliseconds: 290));
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) =>
                                  SubjectsDialogView(),
                            );
                          },
                          child: const Icon(Icons.add),
                          backgroundColor: Theme.of(context).accentColor,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        onInitialized: (context, rateMyApp) {},
      ),
    );
  }
}
