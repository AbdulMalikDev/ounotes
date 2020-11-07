import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key key}) : super(key: key);

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
        title: Text("Privacy policy"),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildParagraph("OU Notes is an Android app that contains Notes (PDF, e-books etc.), Previous Question Papers, Syllabus, Resources (helpful links for learning online). The OU Notes app is a Free app. This SERVICE is provided by at no cost and is intended for use as is.\n\n" +
                  "This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.\n\n" +
                  "If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.\n\n"
                      "The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at OU Notes unless otherwise defined in this Privacy Policy.\n"),
              buildheading("Information Collection and Use"),
              buildParagraph(
                  "For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to Internet access ,Read and Write data to SD CARD/Internal Storage. The information that I request will be retained on your device and is not collected by me in any way.\n\n" +
                      "The app does use third party services that may collect information used to identify you.\n\n" +
                      "Link to privacy policy of third party service providers used by the app\n\n" +
                      "•	Google Play Service\n" +
                      "•	Firebase Analytics\n"),
              buildheading("Log Data"),
              buildParagraph(
                  "I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.\n"),
              buildheading("Cookies"),
              buildParagraph(
                  "Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the Apps that you visit and are stored on your device's internal memory.\n\n" +
                      "This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.\n"),
              buildheading("Service Providers"),
              buildParagraph(
                  "I may employ third-party companies and individuals due to the following reasons:\n\n" +
                      "To facilitate our Service; To provide the Service on our behalf; To perform Service-related services; or To assist us in analyzing how our Service is used.\n\n" +
                      "I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.\n"),
              buildheading("Security"),
              buildParagraph(
                  "I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.\n"),
              buildheading("Links to Other Sites"),
              buildParagraph(
                  "This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these Apps. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.\n"),
              buildheading("Children’s Privacy"),
              buildParagraph(
                  "These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do necessary actions.\n"),
              buildheading("Changes to This Privacy Policy"),
              buildParagraph(
                  "I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.\n"),
              buildheading("Contact Us"),
              buildParagraph(
                  "If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact us at ounotesplatform@gmail.com .\n\n"),
            ],
          ),
        ),
      ),
    );
  }
}
