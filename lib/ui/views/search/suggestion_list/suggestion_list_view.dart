import 'package:FSOUNotes/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SuggestionListView extends StatelessWidget {
  final suggestions;
  final String query;
  final Path path;
  final ValueChanged<String> onSelected;

  const SuggestionListView(
      {Key key, this.suggestions, this.query, this.path, this.onSelected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 18);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions.elementAt(i);
        return ListTile(
          leading: path == Path.Dialog
              ? Icon(
                  Icons.add_circle,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () async {
            print(suggestion);
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
