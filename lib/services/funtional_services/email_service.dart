import 'package:flutter/foundation.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class EmailService {
  static emailFunc({
    @required String subject,
    @required String body,
  }) async {
    final MailOptions mailOptions = MailOptions(
      body: body,
      subject: subject,
      recipients: ['ounotesplatform@gmail.com'],
      isHTML: true,
    );
    await FlutterMailer.send(mailOptions);
  }
}
