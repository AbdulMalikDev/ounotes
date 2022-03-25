import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/TextFieldView.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/bottom_sheet/bottom_sheet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

void setUpBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.floating: (context, sheetRequest, completer) =>
        _FloatingBoxBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.floating2: (context, sheetRequest, completer) =>
        _FloatingBoxBottomSheet2(request: sheetRequest, completer: completer),
    BottomSheetType.confirm: (context, sheetRequest, completer) =>
        _FloatingBoxConfirmBottomSheet(
            request: sheetRequest, completer: completer),
    BottomSheetType.filledStacks: (context, sheetRequest, completer) =>
        _FilledStacksFloatingBoxBottomSheet(
            request: sheetRequest, completer: completer),
    BottomSheetType.premium: (context, sheetRequest, completer) =>
        PremiumBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.downloadPdf: (context, sheetRequest, completer) =>
        DownloadPdfBottomSheet(request: sheetRequest, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}

class _FloatingBoxBottomSheet2 extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  _FloatingBoxBottomSheet2({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomSheetViewModel>.reactive(
      builder: (context, model, child) => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(25),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                request.title,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text("Remember My Choice"),
                value: model.ischecked,
                onChanged: (newValue) {
                  model.changeCheckMark(newValue);
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 3.0),
              //   child: Text(request.description),
              // ),
              // SizedBox(height: 15),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => completer(
                        SheetResponse(
                          confirmed: true,
                          data: {
                            "checkBox": model.ischecked,
                            "buttonText": request.mainButtonTitle,
                          },
                        ),
                      ),
                      child: FittedBox(
                        child: Text(
                          request.mainButtonTitle ?? "YES",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).canvasColor,
                        side: BorderSide(
                            width: 2.0, color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () => completer(
                        SheetResponse(
                          confirmed: true,
                          data: {
                            "checkBox": model.ischecked,
                            "buttonText": request.secondaryButtonTitle,
                          },
                        ),
                      ),
                      child: FittedBox(
                        child: Text(
                          request.secondaryButtonTitle ?? "NO",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => BottomSheetViewModel(),
    );
  }
}

class _FloatingBoxBottomSheet extends StatelessWidget {
  final TextEditingController textFieldController1 = TextEditingController();
  final SheetRequest request;
  final Function(SheetResponse) completer;
  _FloatingBoxBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomSheetViewModel>.reactive(
      builder: (context, model, child) => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(25),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                model.errorText ?? request.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: model.errorText == null
                      ? FontWeight.bold
                      : FontWeight.w300,
                ),
              ),
              SizedBox(height: 10),
              TextFieldView(
                  heading: "",
                  labelText: request.description,
                  textFieldController: textFieldController1),
              SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () => completer(
                        SheetResponse(confirmed: false, responseData: null)),
                    child: Text(
                      request.secondaryButtonTitle,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FlatButton(
                    onPressed: () =>
                        model.response(completer, textFieldController1.text),
                    child: Text(
                      request.mainButtonTitle,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    color: Theme.of(context).primaryColor,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => BottomSheetViewModel(),
    );
  }
}

class _FloatingBoxConfirmBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const _FloatingBoxConfirmBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            request.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.description,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 15),
                Text(
                  "Your Version : " + request.customData[0] + "+",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text(
                  "Latest Version : " + request.customData[1] + "+",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                if (request.customData[2].length > 0)
                  Text(
                    request.customData[2],
                    style: TextStyle(color: Colors.grey),
                  ),
                SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () => completer(SheetResponse(confirmed: false)),
                child: Text(
                  request.secondaryButtonTitle,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              FlatButton(
                onPressed: () => completer(SheetResponse(confirmed: true)),
                child: Text(
                  request.mainButtonTitle,
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
              )
            ],
          )
        ],
      ),
    );
  }
}

class _FilledStacksFloatingBoxBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  _FilledStacksFloatingBoxBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isFileUploadSheet = false;
    bool isDownloadSheet = false;
    if (request.customData != null &&
        request.customData.runtimeType.toString() ==
            "_InternalLinkedHashMap<String, bool>") {
      if (request.customData["file_upload"] != null &&
          request.customData["file_upload"]) {
        isFileUploadSheet = true;
      } else if (request.customData["download"] != null &&
          request.customData["download"]) {
        isDownloadSheet = true;
      }
    }
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          isDownloadSheet
              ? IconButton(
                  icon: Icon(Icons.file_download, size: 40, color: Colors.teal),
                  onPressed: () {})
              : Text(
                  request.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
          SizedBox(height: 25),
          if (!isFileUploadSheet)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                request.description,
                style: TextStyle(color: Colors.grey, fontSize: 19),
              ),
            ),
          SizedBox(height: 30),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: isFileUploadSheet
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.spaceBetween,
            children: [
              if (!isFileUploadSheet)
                Expanded(
                  flex: 4,
                  child: MaterialButton(
                    onPressed: () => completer(SheetResponse(confirmed: false)),
                    child: Text(
                      request.secondaryButtonTitle,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              if (isFileUploadSheet)
                Expanded(
                  flex: 4,
                  child: FlatButton(
                    // padding: EdgeInsets.symmetric(horizontal:0,vertical:13),
                    onPressed: () => completer(SheetResponse(confirmed: false)),
                    child: Text(
                      request.secondaryButtonTitle,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 4,
                child: FlatButton(
                  // padding: EdgeInsets.symmetric(horizontal:30,vertical:13),
                  onPressed: () => completer(SheetResponse(confirmed: true)),
                  child: Text(
                    request.mainButtonTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class PremiumBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  PremiumBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Text(
                  request.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                MdiIcons.crown,
                color: Colors.amber,
                size: 30,
              ),
            ],
          ),
          SizedBox(height: 25),
          Text(
            request.customData["price"] != null
                ? request.customData["price"]
                : "₹100",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          Text(
            "per year",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 2,
            width: App(context).appWidth(0.6),
            color: Colors.amber,
          ),
          SizedBox(
            height: 30,
          ),
          buildPremiumOffer(
            "No Annoying Ads",
            Icon(
              Icons.highlight_off,
              color: Colors.red,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // buildPremiumOffer(
          //   "Save and Read Offline",
          //   Icon(
          //     Icons.import_contacts,
          //     color: Colors.teal,
          //   ),
          // ),
          SizedBox(
            height: 40,
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Container(
              height: 40,
              child: RaisedButton(
                onPressed: () => completer(SheetResponse(confirmed: true)),
                textColor: Colors.white,
                color: Colors.amber.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: new Text(
                  "Support Us",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class DownloadPdfBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  DownloadPdfBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Text(
                  request.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                MdiIcons.crown,
                color: Colors.amber,
                size: 30,
              ),
            ],
          ),
          SizedBox(height: 25),
          Text(
            ((request.customData != null && request.customData["price"] != null)
                ? request.customData["price"]
                : "₹10"),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          Text(
            "per download",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 2,
            width: App(context).appWidth(0.6),
            color: Colors.amber,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Why are we charging ₹10 per download?",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.teal.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Routes.whyToPayForDownloadView,
                );
              },
              child: Text("Know here"),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: Container(
              height: 40,
              child: RaisedButton(
                onPressed: () => completer(SheetResponse(confirmed: true)),
                textColor: Colors.white,
                color: Colors.amber.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: new Text(
                  "Download now",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

Widget buildPremiumOffer(String offer, Icon widget) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      widget,
      SizedBox(
        width: 20,
      ),
      Text(
        "$offer",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    ],
  );
}
