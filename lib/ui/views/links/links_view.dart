import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/links_tile_view/links_tile_view.dart';
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
                height: widget.path != null
                    ? MediaQuery.of(context).size.height * 0.86
                    : MediaQuery.of(context).size.height * 0.78,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    model.isloading
                        ? linearProgress()
                        : SizedBox(height: 0, width: 0),
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          height: widget.path != null
                              ? model.isloading
                                  ? MediaQuery.of(context).size.height *
                                      0.84 //chota
                                  : MediaQuery.of(context).size.height *
                                      0.86 //bada
                              : model.isloading
                                  ? MediaQuery.of(context).size.height *
                                      0.68 //chota
                                  : MediaQuery.of(context).size.height *
                                      0.73, //bada
                          width: double.infinity,
                          child: model.isBusy
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              :  model.linksList.length == 0
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Resources/Links are empty!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                      color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                                    fontWeight:
                                                        FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    )
                                  :ListView.builder(
                                  itemCount: model.linksList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Link link = model.linksList[index];
                                    return InkWell(
                                        child: LinksTileView(
                                          link: link,
                                          index: index,
                                        ),
                                        onTap: () {});
                                  }),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => LinksViewModel());
  }

  @override
  bool get wantKeepAlive => true;
}
