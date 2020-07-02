import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/downloads/notes/Downloadednotes_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DownloadedNotesView extends StatelessWidget {
  const DownloadedNotesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<DownloadedNotesViewModel>.reactive(
      onModelReady: (model) => model.fetchAndSetListOfNotesInDownloads(),
      builder: (context, model, child) => Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: model.isBusy
            ? circularProgress()
            : ListView.builder(
                itemCount: model.notes.length,
                itemBuilder: (context, index) {
                  final item = model.notes[index].filename;
                  return FractionallySizedBox(
                    widthFactor: 0.99,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: theme.colorScheme.background,
                        boxShadow: AppStateNotifier.isDarkModeOn
                            ? []
                            : [
                                BoxShadow(
                                    offset: Offset(10, 10),
                                    color: theme.cardTheme.shadowColor,
                                    blurRadius: 25),
                                BoxShadow(
                                    offset: Offset(-10, -10),
                                    color: theme.cardTheme.color,
                                    blurRadius: 25)
                              ],
                      ),
                      child: Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          model
                              .removeNoteFromDownloads(model.notes[index].path);
                          // Then show a snackbar.
                          showSnackBar(context, item);
                        },
                        background: Container(
                          //margin: EdgeInsets.symmetric(horizontal:10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: AlignmentDirectional.centerStart,
                          child: Icon(
                            Icons.block,
                            color: Colors.white,
                          ),
                        ),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                          //color: Colors.yellow,
                          height: 80,
                          child: ListTile(
                            title: Container(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(
                                model.notes[index].filename,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            leading: Container(
                              margin: EdgeInsets.only(right: 3),
                              height: App(context)
                                  .appScreenHeightWithOutSafeArea(0.12),
                              width: App(context)
                                  .appScreenWidthWithOutSafeArea(0.2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                //color: Colors.yellow,
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/pdf.png',
                                  ),
                                  // colorFilter: ColorFilter.mode(
                                  //     Colors.black.withOpacity(0.1), BlendMode.dstATop),
                                ),
                              ),
                            ),
                            onTap: () {
                              model.onTap(
                                  PDFpath: model.notes[index].path,
                                  notesName: model.notes[index].filename);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ),
      viewModelBuilder: () => DownloadedNotesViewModel(),
    );
  }
}

void showSnackBar(
    BuildContext context,
    String item,
  ) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Container(
          constraints: BoxConstraints(maxWidth: 300),
          child: Text(
            "REMOVED $item",
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(fontSize: 15, color: Colors.black),
          ),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }