import 'package:get/get.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'add_personal_info.dart';

class ChooseWhomToDate extends StatefulWidget {
  final bool isFromSignup;
  const ChooseWhomToDate({Key? key, required this.isFromSignup}) : super(key: key);


  @override
  State<ChooseWhomToDate> createState() => _ChooseWhomToDateState();
}

class _ChooseWhomToDateState extends State<ChooseWhomToDate> {
  List<String> genders = ['Open to all', 'Male', 'Female'];
  int? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Heading3Text(
              likeToDateHeaderString.tr,

            ).setPadding(top: 100),
            Heading4Text(
              likeToDateSubHeaderString.tr,

            ).setPadding(top: 20),
            ListView.builder(
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, int index) =>
                  addOption(index).setPadding(top: 15),
            ).setPadding(top: 30),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: AppThemeButton(
                      cornerRadius: 25,
                      text: nextString.tr,
                      onPress: () {
                        Get.to(() =>  AddPersonalInfo(isFromSignup: widget.isFromSignup));
                      })),
            ).setPadding(top: 100),
          ],
        ).hP25,
      ),
    );
  }

  Widget addOption(int index) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Heading4Text(genders[index],
              color: AppColorConstants.grayscale100,),
          ThemeIconWidget(
              selectedGender == index
                  ? ThemeIcon.circle
                  : ThemeIcon.circleOutline,
              color: AppColorConstants.iconColor),
        ],
      ).hP25.ripple(() {
        setState(() {
          selectedGender = index;
        });
      }),
    ).borderWithRadius(
        color: Theme.of(context).disabledColor,
        radius: 15,
        value: 1);
  }
}
