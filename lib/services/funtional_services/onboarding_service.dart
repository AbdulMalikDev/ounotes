

import 'dart:math';

class OnboardingService{
  static const String floating_action_button_to_add_subjects = "floating_action_button_to_add_subjects";
  static const String drawer_hamburger_icon_to_access_other_features = "drawer_hamburger_icon_to_access_other_features";
  static const String feedback_tile_to_give_feedback = "feedback_tile_to_give_feedback";
  static const String rate_us_to_rate_app = "rate_us_to_rate_app";

  //Every 10 times upload prompt to be shown
  static int number_of_time_document_view_opened = 0;

  static const List<Map<String,String>> uploadPrompts = [
    {'Don\'t forget to Upload Notes 📗, Question Papers📝, Syllabus📜 or YouTube Channel links🔗 which you have found helpful' : "Finish"},
    {"Upload some Notes na ! 🥺" : "No i won't 😠"},
    {"Notes upload karo na bhayya please" : "Nai hota ustaad dam nakko karo"},
    {"You have a chance to help 10,000+ students 📝 worldwide by uploading the best notes you have !" : "No, i dont want to help 😤"},
    {"Upload important questions ! 📝 " : "Finish"},
    {"UPLOAD NOTES ! 📗📘" : "OKAY"},
  ];

  static const List<Map<String,String>> drawerPrompts = [
    {'It took us months of work 😓 to build this app, we would be really thankful if you donate a 5 🌟 😇 !!' : "Okayy !"},
    {'You can always reach out to us if you face any problem, have any feedback or just want to say something !\nWe\'re always there for you 😇 !!' : "Okayy !"},
  ];

  static List<String> getUploadPrompt() {
    var rand = new Random();
    Map<String,String> randomMap = uploadPrompts[rand.nextInt(uploadPrompts.length)];
    return randomMap.keys.toList() + randomMap.values.toList(); 
  }
}