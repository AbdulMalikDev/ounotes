class Vote {
  bool hasUpvoted;
  bool hasDownvoted;
  String notesName;
  String subname;
  Vote(
      {this.notesName,
      this.hasDownvoted = false,
      this.hasUpvoted = false,
      this.subname});
}
