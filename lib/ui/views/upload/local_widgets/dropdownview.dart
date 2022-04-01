import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';

class DropDownView extends StatefulWidget {
  final String value;
  final List<DropdownMenuItem<String>> items;
  final Function(String) onChanged;
  final String title;
  final bool isExpanded;

  const DropDownView({
    Key key,
    this.value,
    this.items,
    this.onChanged,
    this.title,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  _DropDownViewState createState() => _DropDownViewState();
}

class _DropDownViewState extends State<DropDownView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 140,
          child: Text(
            "${widget.title}",
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontSize: 15,
                ),
          ),
        ),
        Container(
          height: App(context).appHeight(0.04),
          width: widget.isExpanded ? 250 : 150,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 0.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              child: DropdownButton(
                isExpanded: true,
                elevation: 8,
                items: widget.items,
                onChanged: widget.onChanged,
                value: widget.value,
                iconSize: 25,
                icon: Icon(
                  Icons.expand_more_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
