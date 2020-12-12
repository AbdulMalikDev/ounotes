import 'package:FSOUNotes/ui/widgets/dumb_widgets/TextFieldView.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/bottom_sheet/bottom_sheet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

void setUpBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.floating: (context, sheetRequest, completer) =>
        _FloatingBoxBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.floating2: (context, sheetRequest, completer) =>
        _FloatingBoxBottomSheet2(request: sheetRequest, completer: completer),
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
              SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () => completer(
                        SheetResponse(
                          confirmed: true,
                          responseData: {
                            "checkBox": model.ischecked,
                            "buttonText": request.secondaryButtonTitle,
                          },
                        ),
                      ),
                      child: Text(
                        request.secondaryButtonTitle,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () => completer(
                        SheetResponse(
                          confirmed: true,
                          responseData: {
                            "checkBox": model.ischecked,
                            "buttonText": request.mainButtonTitle,
                          },
                        ),
                      ),
                      child: Text(
                        request.mainButtonTitle,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
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
