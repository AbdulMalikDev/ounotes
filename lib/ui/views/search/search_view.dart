import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/views/all_documents/all_documents_view.dart';
import 'package:FSOUNotes/ui/views/search/search_viewmodel.dart';
import 'package:FSOUNotes/ui/views/search/suggestion_list/suggestion_list_view.dart';
import 'package:flutter/material.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:stacked/stacked.dart';

class SearchView extends SearchDelegate<Subject> {
  // final String sub;
  final Path path;
  SearchView({this.path});

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      textTheme: theme.textTheme,
      primaryIconTheme: theme.primaryIconTheme,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return AllDocumentsView(
      subjectName: this.query,
      path: 'search',
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => ValueListenableBuilder(
          valueListenable: model.allSubjects,
          builder: (context, allSubjects, child) {
            return SuggestionListView(
              query: this.query,
              suggestions: model.getSuggestions(this.query),
              path: path,
              onSelected: (String suggestion) {
                this.query = suggestion;
                path == Path.Dialog
                    ? model.onSelected(suggestion: suggestion)
                    : showResults(context);
              },
            );
          }),
      viewModelBuilder: () => SearchViewModel(),
    );
  }
}
