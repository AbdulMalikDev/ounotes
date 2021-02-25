import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';

class DropDownButtonView extends StatelessWidget {
  final Function changedDropDownItem;
  final List<DropdownMenuItem<String>> dropDownMenuItems;
  final String selectedItem;
  final Color dropDownColor;
  final BorderRadius borderRadius;

  const DropDownButtonView({
    Key key,
    this.changedDropDownItem,
    this.dropDownMenuItems,
    this.selectedItem,
    @required this.dropDownColor,
    this.borderRadius,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 30, 10),
        padding: const EdgeInsets.fromLTRB(10, 0, 8, 0),
        width: App(context).appWidth(0.38),
        height: App(context).appHeight(0.05),
        decoration: BoxDecoration(
          borderRadius:
              borderRadius != null ? borderRadius : BorderRadius.circular(25),
          border: Border.all(
            width: 1.5,
            color: dropDownColor,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            child: DropdownButton(
              isExpanded: true,
              elevation: 8,
              items: dropDownMenuItems,
              onChanged: changedDropDownItem,
              value: selectedItem,
              iconSize: 25,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: dropDownColor,
              ),
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 15,
                    color: dropDownColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
