import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService{

  FirebaseFunctions functions = FirebaseFunctions.instance;


  Future<void> grantVerifierRole(adminId,email,id) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('grantVerifierRole',options:HttpsCallableOptions(timeout: Duration(seconds: 20)));
      await callable({'admin_id':adminId,'verifier_email': email,'verifier_id': id});
    } catch (e) {
      print(e);
    }
  }

}