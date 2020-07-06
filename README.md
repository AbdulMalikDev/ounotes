## <img src="https://github.com/AbdulMalikDev/OU-Notes-Stacked-Architecture/blob/master/assets/images/Applogo.jpg?raw=true" width="48">OU Notes [Osmania University (O.U)] [![GitHub stars](https://img.shields.io/github/stars/AbdulMalikDev/ounotes?style=social)](https://github.com/login?return_to=%2FTheAlphamerc%flutter_twitter_clone) ![GitHub forks](https://img.shields.io/github/forks/AbdulMalikDev/ounotes?style=social) 
![Dart CI](https://github.com/TheAlphamerc/flutter_twitter_clone/workflows/Dart%20CI/badge.svg) ![GitHub pull requests](https://img.shields.io/github/issues-pr/AbdulMalikDev/ounotes) ![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed/AbdulMalikDev/ounotes) ![GitHub last commit](https://img.shields.io/github/last-commit/AbdulMalikDev/ounotes)  ![GitHub issues](https://img.shields.io/github/issues-raw/AbdulMalikDev/ounotes) [![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)](https://github.com/Thealphamerc/flutter_twitter_clone) 


**For the Students , By the Students.** <br/>
An Application for Osmania University students to access educational material at one place built with the famous **Stacked Architecture** in Flutter.


## Download App
<a href="https://play.google.com/store/apps/details?id=com.notes.ounotes"><img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" width="200"></img></a>

## Content
👉 O.U Notes<br/>
👉 O.U Previous Question Papers<br/>
👉 O.U Syllabus<br/>
👉 O.U Resources<br/>

## Features
👉 Access documents directly within app using inbuilt PDF viewer<br/>
👉 Ability to save documents in downloads<br/>
👉 Report documents for admins to review<br/>
👉 Notifications about events and other information related to the university<br/>

 :boom: Now any user can upload documents ! :boom:
* Please read the guidelines and contribution guide for beginners.



## Dependencies
<details>
     <summary> Click to expand </summary>
     
* [intl](https://pub.dev/packages/intl)
* [cuid](https://pub.dev/packages/cuid)
* [stacked](https://pub.dev/packages/stacked)
* [share](https://pub.dev/packages/share)
* [stacked_services](https://pub.dev/packages/stacked_services)
* [url_launcher](https://pub.dev/packages/url_launcher)
* [google_fonts](https://pub.dev/packages/google_fonts)
* [file_picker](https://pub.dev/packages/file_picker)
* [firebase_auth](https://pub.dev/packages/firebase_auth)
* [google_sign_in](https://pub.dev/packages/google_sign_in)
* [firebase_analytics](https://pub.dev/packages/firebase_analytics)
* [firebase_database](https://pub.dev/packages/firebase_database)
* [shared_preferences](https://pub.dev/packages/shared_preferences)
* [path_provider](https://pub.dev/packages/path_provider)
     
</details>

## Contributing

If you wish to contribute a change to any of the existing feature or add new in this repo,
please review our [contribution guide](https://github.com/AbdulMalikDev/OU-Notes-Stacked-Architecture/blob/master/CONTRIBUTING.md),
and send a [pull request](https://github.com/AbdulMalikDev/OU-Notes-Stacked-Architecture/pulls). I welcome and encourage all pull requests. It usually will take me within 24-48 hours to respond to any issue or request.

## Created & Maintained By

[Abdul Malik](https://github.com/AbdulMalikDev) And [Syed Wajid](https://github.com/syedwajid01)

## Screenshots

![](/screenshots/7.png?raw=true)    ![](/screenshots/3.png?raw=true)![](/screenshots/8.png?raw=true)  ![](/screenshots/4.png?raw=true)

  
![](/screenshots/2.png?raw=true)    ![](/screenshots/6.png?raw=true)![](/screenshots/9.png?raw=true)  ![](/screenshots/21.png?raw=true)


![](/screenshots/24.png?raw=true)    ![](/screenshots/23.png?raw=true)![](/screenshots/22.png?raw=true)  ![](/screenshots/25.png?raw=true)

    
![](/screenshots/28.png?raw=true)    ![](/screenshots/27.png?raw=true)![](/screenshots/26.png?raw=true)  ![](/screenshots/32.png?raw=true)      
![](/screenshots/31.png?raw=true)    ![](/screenshots/30.png?raw=true)![](/screenshots/29.png?raw=true)  ![](/screenshots/20.png?raw=true)

    
![](/screenshots/17.png?raw=true)    ![](/screenshots/14.png?raw=true)![](/screenshots/12.png?raw=true)  ![](/screenshots/1.png?raw=true)

   
![](/screenshots/36.png?raw=true)    ![](/screenshots/35.png?raw=true)![](/screenshots/34.png?raw=true)  ![](/screenshots/33.png?raw=true)




## Getting started 
* Project setup instructions coming soon.

## Directory Structure
<details>
     <summary> Click to expand [Stacked Architecture ] </summary>
  
```

|-- lib
|   |-- AppTheme
|   |   |-- AppStateNotifier.dart
|   |   '-- AppTheme.dart
|   |-- CustomIcons
|   |   '-- custom_icons.dart
|   |-- app
|   |   |-- locator.dart
|   |   |-- locator.iconfig.dart
|   |   |-- logger.dart
|   |   |-- router.dart
|   |   '-- router.gr.dart
|   |-- enums
|   |   |-- constants.dart
|   |   '-- enums.dart
|   |-- main.dart
|   |-- models
|   |   |-- course_info.dart
|   |   |-- document.dart
|   |   |-- download.dart
|   |   |-- syllabus.dart
|   |   |-- user.dart
|   |   '-- vote.dart
|   |-- services
|   |   |-- funtional_services
|   |   |   |-- authentication_service.dart
|   |   |   |-- cloud_storage_service.dart
|   |   |   |-- db_service.dart
|   |   |   |-- email_service.dart
|   |   |   |-- firestore_service.dart
|   |   |   |-- sharedpref_service.dart
|   |   |   '-- third_party_services_module.dart
|   |   '-- state_services
|   |       |-- download_service.dart
|   |       |-- links_service.dart
|   |       |-- notes_service.dart
|   |       |-- question_paper_service.dart
|   |       |-- report_service.dart
|   |       |-- subjects_service.dart
|   |       |-- syllabus_service.dart
|   |       '-- vote_service.dart
|   |-- ui
|   |   |-- shared
|   |   |   |-- app_config.dart
|   |   |   |-- shared_styles.dart
|   |   |   '-- ui_helper.dart
|   |   |-- views
|   |   |   |-- FilterDocuments
|   |   |   |   |-- FD_DocumentDisplay
|   |   |   |   |   |-- fd_documentview.dart
|   |   |   |   |   '-- fd_documentviewmodel.dart
|   |   |   |   |-- FD_InputScreen
|   |   |   |   |   |-- fd_inputView.dart
|   |   |   |   |   '-- fd_inputViewmodel.dart
|   |   |   |   '-- FD_subjectdisplay
|   |   |   |       |-- fd_subjectview.dart
|   |   |   |       '-- fd_subjectviewmodel.dart
|   |   |   |-- Profile
|   |   |   |   |-- profile_view.dart
|   |   |   |   '-- profile_viewmodel.dart
|   |   |   |-- about_us
|   |   |   |   '-- about_us_view.dart
|   |   |   | (8 more...)
|   |   |   |-- search
|   |   |   |   |-- search_view.dart
|   |   |   |   |-- search_viewmodel.dart
|   |   |   |   '-- suggestion_list
|   |   |   |       '-- suggestion_list_view.dart
|   |   |   |-- splash
|   |   |   |   |-- spash_view.dart
|   |   |   |   '-- splash_viewmodel.dart
|   |   |   '-- syllabus
|   |   |       |-- syllabus_view.dart
|   |   |       '-- syllabus_viewmodel.dart
|   |   '-- widgets
|   |       |-- dumb_widgets
|   |       |   |-- SaveButtonView.dart
|   |       |   |-- TextFieldView.dart
|   |       |   |-- drawer_header.dart
|   |       |   |-- expantion_list.dart
|   |       |   |-- nav_item.dart
|   |       |   |-- no_subjects_overlay.dart
|   |       |   '-- progress.dart
|   |       '-- smart_widgets
|   |           |-- FilterSubjects_view
|   |           |   |-- filtersubjects_view.dart
|   |           |   '-- filtersubjects_viewmodel.dart
|   |           |-- drawer
|   |           |   |-- drawer_view.dart
|   |           |   '-- drawer_viewmodel.dart
|   |           |-- links_tile_view
|   |           |   |-- links_tile_view.dart
|   |           |   '-- links_tile_viewmodel.dart
|   |           |-- notes_tile
|   |           |   |-- notes_tile_view.dart
|   |           |   '-- notes_tile_viewmodel.dart
|   |           |-- question_paper_tile
|   |           |   |-- question_paper_tile_view.dart
|   |           |   '-- question_paper_tile_viewmodel.dart
|   |           |-- subjects_dialog
|   |           |   |-- subjects_dialog_view.dart
|   |           |   '-- subjects_dialog_viewmodel.dart
|   |           |-- syllabus_tile.dart
|   |           |   |-- syllabus_tile_view.dart
|   |           |   '-- syllabus_tile_viewmodel.dart
|   |           '-- user_subject_list
|   |               |-- user_subject_list_view.dart
|   |               '-- user_subject_list_viewmodel.dart
|   '-- utils
|       '-- file_picker_service.dart
|-- pubspec.yaml

```

</details>
     
