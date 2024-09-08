part of '../screens.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        width: getSize(context).width,
        height: getSize(context).height,
        decoration: kDecorBackground,
        child: Column(
          children: [
            const IntroImageAnimated(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5.h,
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    Text(
                      "شاهد الأفلام في أي مكان وفي أي وقت",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headlineLarge!.copyWith(
                        color: kColorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "استمتع بمشاهدة أفلامك المفضلة أينما ومتى شئت"
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: kColorPrimary,
                        fontWeight: FontWeight.normal,
                        fontSize: 15.sp,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: CardTallButton(
                        label: "اضافة مستخدم ",
                        onTap: () => Get.toNamed(screenRegister),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
