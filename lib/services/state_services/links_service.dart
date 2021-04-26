import 'package:FSOUNotes/models/link.dart';

class LinksService{
  
      List<Link> _links;

      List<Link> get links => _links;

      set setLinks(List<Link> links){_links = links;}

      bool get isLinksPresent => _links!=null;

      //* This Function will assign name accordingly
      //* in other words it handles duplicates
      assignNameToLinks({String title})
      {
        //Decide FileName
        String fileName = title;
        int count = _findNumberOfLinksByName(title: title);
        if (count != 0) {
          fileName = fileName + "No." + (count + 1).toString();
        }
        return fileName;
      }

      _findNumberOfLinksByName({String title})
      {
        int count = _links.where((c) => c.title.contains(title)).toList().length;
        return count;
      }
}