import 'package:FSOUNotes/ui/widgets/smart_widgets/links_tile_view/links_tile_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';

class LinksViewModel extends BaseViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  List<Link> _links = [];
  List<Link> get linksList => _links;

  List<Widget> _linkTiles = [];

  List<Widget> get linkTiles => _linkTiles;

  Future fetchLinks(String subjectName) async {
    setBusy(true);
    var links = await _firestoreService.loadLinksFromFirebase(subjectName);
    if (links is String) {
      await Fluttertoast.showToast(
          msg:
              "You are facing an error in loading the links.If you are facing this error more than once, please let us know by using the 'feedback' option in the app drawer.");
      setBusy(false);
    } else {
      _links = links;
    }
    for (int i = 0; i < links.length; i++) {
      Link link = links[i];
      _linkTiles.add(_addInkWellWidget(link));
    }
    notifyListeners();
    setBusy(false);
  }

  Widget _addInkWellWidget(
    Link link,
  ) {
    return InkWell(
      child: LinksTileView(
        link: link,
      ),
      onTap: () {},
    );
  }
}
