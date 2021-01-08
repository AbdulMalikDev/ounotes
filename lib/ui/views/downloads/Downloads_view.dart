import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/downloads/Downloads_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';

class DownLoadView extends StatefulWidget {
  const DownLoadView({Key key}) : super(key: key);

  @override
  _DownLoadViewState createState() => _DownLoadViewState();
}

class _DownLoadViewState extends State<DownLoadView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DownLoadViewModel>.reactive(
      onModelReady: (model) {
        model.getUser();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('My Downloads',
              style: Theme.of(context).appBarTheme.textTheme.headline6),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: buildDownloadList(model),
      ),
      viewModelBuilder: () => DownLoadViewModel(),
    );
  }

  Widget buildDownloadList(DownLoadViewModel model) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: Hive.box('downloads').listenable(),
          builder: (context, donwloadsBox, widget) {
            return Container(
              height: model.user?.isPremiumUser ?? false
                  ? App(context).appHeight(1)
                  : App(context).appHeight(0.18)*donwloadsBox.length,
              child: ListView.builder(
                itemCount: donwloadsBox.length,
                itemBuilder: (context, index) {
                  final download = donwloadsBox.getAt(index) as Download;
                  return GestureDetector(
                    onTap: () {
                      model.navigateToPDFScreen(download);
                    },
                    child: FractionallySizedBox(
                      widthFactor: 0.99,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: AppStateNotifier.isDarkModeOn
                            ? Constants.mdecoration.copyWith(
                                color: Theme.of(context).colorScheme.background,
                                boxShadow: [],
                              )
                            : Constants.mdecoration.copyWith(
                                color: Theme.of(context).colorScheme.background,
                              ),
                        child: DownloadListTile(
                          download: download,
                          index: index,
                          onDeletePressed: () {
                            model.deleteDownload(index, download.path);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        model.user?.isPremiumUser ?? false
            ? Container()
            : Container(
                decoration: Constants.mdecoration,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Note:",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: primary),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(),
                      child: Text(
                        "Only 3 notes can be stored offline in the app. Unlock unlimited offline downloads in the app by becoming a Pro Member.",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: primary),
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.all(10),
                      width: App(context).appWidth(0.45),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.teal.shade500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onPressed: () {
                          model.buyPremium();
                        },
                        child: Row(
                          children: [
                            Text("Buy Premium"),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              MdiIcons.crown,
                              color: Colors.amber,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
      ],
    );
  }
}

Widget noDownloadsOverlay(BuildContext context) {
  return Stack(
    children: <Widget>[
      Align(
        alignment: Alignment.center,
        child: Lottie.asset('assets/lottie/learn.json'),
      ),
      Positioned(
        top: App(context).appHeight(0.55),
        left: 60,
        right: 50,
        child: Text(
          "Your downloads will appear here",
          style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 17),
        ),
      ),
    ],
  );
}

class DownloadListTile extends StatelessWidget {
  final Download download;
  final int index;
  final Function onDeletePressed;

  const DownloadListTile(
      {Key key, this.download, this.index, this.onDeletePressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.onPrimary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final String title =
        download.title != null ? download.title.toUpperCase() : "title";
    final String author =
        download.author != null ? download.author.toUpperCase() : "author";
    final date = download.uploadDate;
    var format = new DateFormat("dd/MM/yy");
    var dateString = format.format(date);
    final int view = download.view;
    final String size = download.size.toString();
    var theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.delete,
                  size: 30,
                  color: theme.primaryColor,
                ),
                onPressed: onDeletePressed,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 25),
                    height: App(context).appScreenHeightWithOutSafeArea(0.11),
                    width: App(context).appScreenWidthWithOutSafeArea(0.2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/pdf.png',
                        ),
                        // colorFilter: ColorFilter.mode(
                        //     Colors.black.withOpacity(0.1), BlendMode.dstATop),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(maxWidth: 180),
                                child: Text(
                                  title,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Author :$author",
                            style: TextStyle(
                                color: primary,
                                fontSize: 13,
                                letterSpacing: .3)),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Upload Date :$dateString",
                            style: TextStyle(
                                color: primary,
                                fontSize: 13,
                                letterSpacing: .3)),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.remove_red_eye,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          view.toString(),
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          size,
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
