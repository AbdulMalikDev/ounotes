import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';
import 'default_app_bar_viewmodel.dart';

class DefaultAppBarView extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final bool showNotificationButton;
  DefaultAppBarView({Key key, this.showNotificationButton = false})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double hp = App(context).appHeight(1);
    double wp = App(context).appWidth(1);
    BoxShadow defaultAppBarShadow = BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      // blurRadius: 0.5,
      offset: Offset(0, 2),
    );
    return ViewModelBuilder<DefaultAppBarViewModel>.nonReactive(
      onModelReady: (model) async {
        await model.init();
      },
      viewModelBuilder: () => DefaultAppBarViewModel(),
      builder: (
        BuildContext context,
        DefaultAppBarViewModel model,
        Widget child,
      ) {
        return Container(
          color: AppStateNotifier.isDarkModeOn
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.white,
          child: SafeArea(
            bottom: false,
            child: Container(
              // height: hp * 0.06,
              height: 60.0,
              decoration: BoxDecoration(
                color: AppStateNotifier.isDarkModeOn
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.white,
                boxShadow: [
                  defaultAppBarShadow,
                ],
              ),
              child: Stack(
                children: [
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: GestureDetector(
                  //     onTap: () {},
                  //     child: Container(
                  //       margin: const EdgeInsets.only(left: 15),
                  //       child: Text(
                  //         model.sem,
                  //         style:
                  //             Theme.of(context).textTheme.headline4.copyWith(),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: App(context).appHeight(0.07),
                      child: Image.asset(
                        Constants.appIcon,
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Container(
                  //       height: 40,
                  //       width: App(context).appWidth(0.2),
                  //       // padding: const EdgeInsets.symmetric(horizontal: 5),
                  //       child: Center(
                  //         child: Text(model.br,
                  //             style: Theme.of(context).textTheme.headline4),
                  //       ),
                  //     ),
                  //   ),
                  // )
                  // if (showNotificationButton)
                  //   Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         IconButton(
                  //           onPressed: () {},
                  //           icon: Container(
                  //             height: hp * 0.18,
                  //             width: wp * 0.25,
                  //             alignment: Alignment.center,
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               border: Border.all(
                  //                 color: Theme.of(context)
                  //                     .iconTheme
                  //                     .color
                  //                     .withOpacity(0.8),
                  //               ),
                  //             ),
                  //             child: Icon(
                  //               MdiIcons.bellOutline,
                  //               size: hp*0.023,
                  //               color: Theme.of(context)
                  //                   .iconTheme
                  //                   .color
                  //                   .withOpacity(0.8),
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(width: 10,)
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
