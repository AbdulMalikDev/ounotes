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
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        width: App(context).appWidth(0.3),
        height: App(context).appHeight(0.05),
        decoration: BoxDecoration(
            // borderRadius:
            //     borderRadius != null ? borderRadius : BorderRadius.circular(10),
            // border: Border.all(
            //   width: 1.5,
            //   color: dropDownColor,
            // ),
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
                Icons.expand_more_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 15,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
