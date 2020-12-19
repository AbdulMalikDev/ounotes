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
    BottomSheetType.confirm: (context, sheetRequest, completer) =>
        _FloatingBoxConfirmBottomSheet(request: sheetRequest, completer: completer),
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
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:3.0),
                child: Text(request.description),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex:2,
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
                      child: FittedBox(
                                              child: Text(
                          request.secondaryButtonTitle,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    flex:3,
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
                      child: FittedBox(
                                              child: Text(
                          request.mainButtonTitle,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
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
            padding: const EdgeInsets.symmetric(horizontal:18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.description,
                  style: TextStyle(color: Colors.grey),
                ),
                 SizedBox(height: 15),
                 Text("Your Version : "+request.customData[1]+"+",style: TextStyle(color: Colors.grey),),
                 SizedBox(height: 10),
                 Text("Latest Version : "+request.customData[1]+"+",style: TextStyle(color: Colors.grey),),
                 SizedBox(height: 10),
                 if(request.customData[2].length > 0)Text(request.customData[2],style: TextStyle(color: Colors.grey),),
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
