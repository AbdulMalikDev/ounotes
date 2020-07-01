import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';

class TermsAndConditionView extends StatelessWidget {
  const TermsAndConditionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildheading(String heading) {
      return Column(
        children: <Widget>[
          Text(
            heading,
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 22),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      );
    }

    Widget buildParagraph(String paragraph) {
      return Text(
        paragraph,
        style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and conditions"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildheading("1.	Introduction"),
              buildParagraph(
                  "These App Standard Terms and Conditions written on this App shall manage your use of this App. These Terms will be applied fully and affect to your use of this App. By using this App, you agreed to accept all terms and conditions written in here. You must not use this App if you disagree with any of these App Standard Terms and Conditions.\n"),
              buildheading("2.	Intellectual Property Rights"),
              buildParagraph(
                  "OU Notes is a registered trademark of OU Notes. All the assets including but not limited to the name and logo are the intellectual property of OU Notes. Unauthorized usage of the name 'OU Notes' and its logo will be treated as illegal and the violator shall be treated as specified under the Trademark laws. Other than the content you own, under these Terms, OU Notes and/or its licencors own all the intellectual property rights and materials contained in this App.\n" +
                      "You are granted limited license only for purposes of viewing the material contained on this App.\n"),
              buildheading("3.	Restrictions"),
              buildParagraph("You are specifically restricted from all of the following\n\n" +
                  "•	publishing any App material in any other media;\n" +
                  "•	selling, sublicensing and/or otherwise commercializing any App material;\n" +
                  "•	publicly performing and/or showing any App material;\n" +
                  "•	using this App in any way that is or may be damaging to this App;\n"
                      "•	using this App in any way that impacts user access to this App;\n" +
                  "•	using this App contrary to applicable laws and regulations, or in any way may cause harm to the App, or to any person or business entity;\n"
                      "•	engaging in any data mining, data harvesting, data extracting or any other similar activity in relation to this App;\n"
                      "•	using this App to engage in any advertising or marketing.\n\n" +
                  "Certain areas of this App are restricted from being access by you and OU Notes may further restrict access by you to any areas of this App, at any time, in absolute discretion. Any user ID and password you may have for this App are confidential and you must maintain confidentiality as well.\n\n" +
                  "Anything that is contributed to OU Notes via The OU Notes WhatsApp Community, Google Drives/Dropbox etc. is the intellectual property of OU Notes. The contributor contributes on his own discretion and the validity of the material being uploaded is the sole responsibility of the contributor.\n\n" +
                  "OU Notes doesn’t allow any form of distribution of the material (soft/hard copy) without a formal dialogue and agreement between the distribution party and OU Notes. Any form of distribution, be it in printed form or non-printed form is illegal, if done without permission. The distributor is then eligible to face legal action.\n"),
              buildheading("4.	Your Content"),
              buildParagraph(
                  "In these App Standard Terms and Conditions, “Your Content” shall mean any audio, video text, images or other material you choose to display on this App. By displaying Your Content, you grant OU Notes a non-exclusive, worldwide irrevocable, sub licensable license to use, reproduce, adapt, publish, translate and distribute it in any and all media.\n\n" +
                      "Your Content must be your own and must not be invading any third-party’s rights. OU Notes reserves the right to remove any of Your Content from this App at any time without notice.\n"),
              buildheading("5.	No warranties"),
              buildParagraph(
                  "This App is provided “as is,” with all faults, and OU Notes express no representations or warranties, of any kind related to this App or the materials contained on this App. Also, nothing contained on this App shall be interpreted as advising you.\n"),
              buildheading("6.	Limitation of liability"),
              buildParagraph(
                  "In no event shall OU Notes, nor any of its officers, directors and employees, shall be held liable for anything arising out of or in any way connected with your use of this App whether such liability is under contract.  OU Notes, including its officers, directors and employees shall not be held liable for any indirect, consequential or special liability arising out of or in any way related to your use of this App.\n"),
              buildheading("7.	Indemnification"),
              buildParagraph(
                  "You hereby indemnify to the fullest extent OU Notes from and against any and/or all liabilities, costs, demands, causes of action, damages and expenses arising in any way related to your breach of any of the provisions of these Terms.\n"),
              buildheading("8.	Severability"),
              buildParagraph(
                  "If any provision of these Terms is found to be invalid under any applicable law, such provisions shall be deleted without affecting the remaining provisions herein.\n"),
              buildheading("9.	Variation of Terms"),
              buildParagraph(
                  "OU Notes is permitted to revise these Terms at any time as it sees fit, and by using this App you are expected to review these Terms on a regular basis.\n"),
              buildheading("10.	Assignment"),
              buildParagraph(
                  "The OU Notes is allowed to assign, transfer, and subcontract its rights and/or obligations under these Terms without any notification. However, you are not allowed to assign, transfer, or subcontract any of your rights and/or obligations under these Terms.\n"),
              buildheading("11.	Entire Agreement"),
              buildParagraph(
                  "These Terms constitute the entire agreement between OU Notes and you in relation to your use of this App, and supersede all prior agreements and understandings.\n"),
              buildheading("12.	Governing Law & Jurisdiction"),
              buildParagraph(
                  "These Terms will be governed by and interpreted in accordance with the laws of the State of Telangana, and you submit to the non-exclusive jurisdiction of the state and federal courts located in Telangana for the resolution of any disputes.\n\n"),
            ],
          ),
        ),
      ),
    );
  }
}
