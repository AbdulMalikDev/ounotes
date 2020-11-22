class NotesView {
  String time;
  //list of map<docid,viewcount>
  Map<String, dynamic> views;

  NotesView.fromData(Map<String, dynamic> data) {
    time = data['time'];
    views = data['views'];
  }

  Map<String, dynamic> toJson() {
    return {
      "time": time,
      "views": views,
    };
  }

  NotesView({this.time, this.views});
}
