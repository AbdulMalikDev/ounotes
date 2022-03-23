class SubjectStats {
  int subjects;
  int notes;
  int questionPapers;
  int syllabus;
  int links;

  SubjectStats(
      {this.subjects,
      this.notes,
      this.questionPapers,
      this.syllabus,
      this.links});

  SubjectStats.fromJson(Map<String, dynamic> json) {
    subjects = json['subjects'];
    notes = json['notes'];
    questionPapers = json['questionPapers'];
    syllabus = json['syllabus'];
    links = json['links'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subjects'] = this.subjects;
    data['notes'] = this.notes;
    data['questionPapers'] = this.questionPapers;
    data['syllabus'] = this.syllabus;
    data['links'] = this.links;
    return data;
  }
}
