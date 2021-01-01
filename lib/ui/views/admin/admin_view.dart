import 'package:FSOUNotes/ui/views/admin/admin_viewmodel.dart';
import 'package:FSOUNotes/ui/views/admin/report/report_view.dart';
import 'package:FSOUNotes/ui/views/admin/subject_list/subject_list_view.dart';
import 'package:FSOUNotes/ui/views/admin/upload_log/upload_log_view.dart';
import 'package:FSOUNotes/ui/views/admin/user_stats/user_stats_view.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/selection_container.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<AdminViewModel>.reactive(
        onModelReady: (model) {},
        builder: (context, model, child) => Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              // appBar: AppBar(
              //   iconTheme: IconThemeData(color: Colors.white),
              //   title: RichText(
              //     text: TextSpan(
              //       text: ' ',
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 20,
              //           fontWeight: FontWeight.normal),
              //     ),
              //   ),
              //   leading: IconButton(
              //     icon: Icon(
              //       Icons.arrow_back_ios,
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //   ),
              // ),
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
                            "Admin Panel",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      SelectionContainer(
                        title: "Report",
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ReportView(),
                          ),
                        ),
                      ),
                      SelectionContainer(
                        title: "Upload Log",
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => UploadLogView(),
                          ),
                        ),
                      ),
                      SelectionContainer(
                        title: "User Stats",
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => UserStatsView(),
                          ),
                        ),
                      ),
                      SelectionContainer(
                        title: "Subject List",
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => AdminSubjectListView(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => AdminViewModel());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
