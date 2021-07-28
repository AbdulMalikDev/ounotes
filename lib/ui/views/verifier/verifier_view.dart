import 'package:FSOUNotes/ui/views/verifier/verifier_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/selection_container.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class VerifierPanelView extends StatelessWidget {
 const VerifierPanelView({Key key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   var theme = Theme.of(context);
   return ViewModelBuilder<VerifierPanelViewModel>.reactive(
     builder: (context, model, child) => Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Text(
                            "Verifier Panel",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SelectionContainer(
                        leading: Icon(Icons.admin_panel_settings),
                        title: "Docs to verify",
                        onTap: () => model.navigateToVerifyDocumentsScreen()
                      ),
                      SelectionContainer(
                        leading: Icon(Icons.report),
                        title: "Reported Docs",
                        onTap: () => model.navigateToReportedDocumentsScreen()
                      ),
                      // SelectionContainer(
                      //   leading: Icon(Icons.pie_chart_rounded),
                      //   title: "User Stats",
                      //   onTap: () => Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //       builder: (ctx) => UserStatsView(),
                      //     ),
                      //   ),
                      // ),
                      // SelectionContainer(
                      //   leading: Icon(Icons.dashboard),
                      //   title: "Subject List",
                      //   onTap: () => Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //       builder: (ctx) => AdminSubjectListView(),
                      //     ),
                      //   ),
                      // ),
                      // SelectionContainer(
                      //   leading: Icon(Icons.account_balance),
                      //   title: "Add Verifier",
                      //   onTap: () => model.navigateToAddVerifierView(),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
     viewModelBuilder: () => VerifierPanelViewModel(),
   );
 }
}