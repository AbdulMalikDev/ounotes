import 'package:FSOUNotes/ui/views/admin/admin_viewmodel.dart';
import 'package:FSOUNotes/ui/views/admin/report/report_view.dart';
import 'package:FSOUNotes/ui/views/admin/upload_log/upload_log_view.dart';
import 'package:FSOUNotes/ui/views/admin/user_stats/user_stats_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<AdminViewModel>.reactive(
        onModelReady: (model) {},
        builder: (context, model, child) => DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: theme.scaffoldBackgroundColor,
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  bottom: TabBar(
                    controller: _tabController,
                    labelColor: Colors.amber,
                    indicatorColor: Theme.of(context).accentColor,
                    isScrollable: true,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(text: "Report Log", icon: Icon(Icons.description)),
                      Tab(text: "Upload Log", icon: Icon(Icons.note)),
                      Tab(text: "User Stats", icon: Icon(Icons.pie_chart_rounded)),
                    ],
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: ' Admin Panel',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    ReportView(),
                    UploadLogView(),
                    UserStatsView(),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => AdminViewModel());
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
