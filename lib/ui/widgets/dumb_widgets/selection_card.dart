import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class SelectionCard extends StatefulWidget {
  final String value;
  final List<String> items;
  final Function(String) onChange;
  final String title;
  final bool isExpanded;

  const SelectionCard({
    Key key,
    this.value,
    this.items,
    this.onChange,
    this.title,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  _SelectionCardState createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constants.kBoxDecorationStyle,
      height: App(context).appHeight(0.15),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Container(
              height: 35,
              width: widget.isExpanded ? 250 : 150,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 0.5,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  showMaterialScrollPicker(
                    context: context,
                    title: widget.title,
                    items: widget.items,
                    onChanged: widget.onChange,
                    selectedItem: widget.value,
                    showDivider: false,
                    maxLongSide: MediaQuery.of(context).size.height * 0.7,
                    cancelText: "",
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.value,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 15,
                            ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// DropdownButtonHideUnderline(
//               child: DropdownButton(
//                 isExpanded: widget.isExpanded,
//                 icon: Icon(
//                   Icons.keyboard_arrow_down,
//                   color: Theme.of(context).primaryColor,
//                 ),
//                 focusColor: Colors.transparent,
//                 style: Theme.of(context)
//                     .textTheme
//                     .subtitle1
//                     .copyWith(fontSize: 17),
//                 value: widget.value,
//                 items: widget.items,
//                 onChanged: widget.onChange,
//               ),
//             ),
