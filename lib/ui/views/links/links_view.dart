import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'links_viewmodel.dart';

class LinksView extends StatefulWidget {
  final String subjectName;
  final String path;
  const LinksView({@required this.subjectName, this.path, Key key})
      : super(key: key);

  @override
  _LinksViewState createState() => _LinksViewState();
}

class _LinksViewState extends State<LinksView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<LinksViewModel>.reactive(
        onModelReady: (model) => model.fetchLinks(widget.subjectName),
        builder: (context, model, child) => SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10),
                width: double.infinity,
                child: model.isBusy
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : model.linksList.length == 0
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: App(context).appHeight(0.15),
                                ),
                                Container(
                                  height: 200,
                                  width: 200,
                                  child:
                                      Image.asset('assets/images/study4.jpg'),
                                ),
                                Text(
                                  "Resources/Links are empty!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "why don't you upload some?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: model.linkTiles,
                          ),
              ),
            ),
        viewModelBuilder: () => LinksViewModel());
  }

  @override
  bool get wantKeepAlive => true;
}
