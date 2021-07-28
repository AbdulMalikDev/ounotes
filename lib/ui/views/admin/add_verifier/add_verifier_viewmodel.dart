import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/models/verifier.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddVerifierViewModel extends BaseViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  User user;
  TextEditingController emailController;
  TextEditingController nameController;
  TextEditingController branchController;
  TextEditingController semesterController;
  TextEditingController collegeController;
  Verifier verifier;

  get downloadProgress => null;

  get isloading => null;

  init(
      Verifier verifierToAdd,
      TextEditingController emailController,
      TextEditingController nameController,
      TextEditingController branchController,
      TextEditingController semesterController,
      TextEditingController collegeController) {

    this.emailController = emailController;
    this.nameController = nameController;
    this.branchController = branchController;
    this.semesterController = semesterController;
    this.collegeController = collegeController;
    verifier = verifierToAdd;

  }

  getVerifierDetails() async {

    // SheetResponse response = await _bottomSheetService.showBottomSheet(title: "Are you sure you want to retreive user?");
    // if(response==null || !response.confirmed)return;

    String email = emailController.text.trim();

    user = await _firestoreService.getUserByEmail(email);
    
    nameController.text = user.username;
    branchController.text = user.branch;
    semesterController.text = user.semester;
    collegeController.text = user.college;
    notifyListeners();
  }

  addVerifier() async {

    if (user == null)return;
    SheetResponse response = await _bottomSheetService.showBottomSheet(title: "Are you sure you want to add this person as a verifier?");
    log.e(response);
    log.e(response.confirmed);
    if(response==null || !response.confirmed)return;

    verifier = Verifier.fromUser(user);

    await _firestoreService.addVerifier(verifier);
  }
}
