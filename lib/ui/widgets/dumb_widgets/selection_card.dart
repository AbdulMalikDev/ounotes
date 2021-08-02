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
      decoration: Constants.kBoxDecorationStyle.copyWith(
        color: Theme.of(context).canvasColor,
      ),
      height: App(context).appHeight(0.142),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 5,
                ),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Container(
                height: App(context).appHeight(0.04),
                width: widget.isExpanded ? 250 : 150,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
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
                      selectedValue: widget.value,
                      showDivider: false,
                      maxLongSide: MediaQuery.of(context).size.height * 0.7,
                      cancelText: "",
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.value,
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 15,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
