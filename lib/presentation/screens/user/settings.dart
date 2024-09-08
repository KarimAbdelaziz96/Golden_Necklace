part of '../screens.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
      body: SingleChildScrollView(
        child: Ink(
          width: 100.w,
          height: 100.h,
          decoration: kDecorBackground,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                final userInfo = state.user;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppBarSettings(),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kColorCardLight,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dateNowWelcome(),
                                  style: Get.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                if (userInfo.userInfo!.expDate != null)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Expiration:",
                                        style: Get.textTheme.titleSmall!
                                            .copyWith(
                                                color: kColorPrimary,
                                                fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        " ${expirationDate(userInfo.userInfo!.expDate)}",
                                        style:
                                            Get.textTheme.titleSmall!.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                // Text(
                                //   "Expiration: ${expirationDate(userInfo.userInfo!.expDate)}",
                                //   style: Get.textTheme.titleSmall!.copyWith(
                                //     color: kColorHint,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kColorCardLight,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "name: ${userInfo.userInfo!.username}",
                                  style: Get.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "password: ${userInfo.userInfo!.password}",
                                  style: Get.textTheme.titleSmall,
                                ),
                                // const SizedBox(height: 5),
                                // Text(
                                //   "Url: ${userInfo.serverInfo!.serverUrl}",
                                //   style: Get.textTheme.titleSmall,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          CardButtonWatchMovie(
                            isFocused: true,
                            title: "تحديث جميع البينات",
                            onTap: () {
                              context
                                  .read<LiveCatyBloc>()
                                  .add(GetLiveCategories());
                              context
                                  .read<MovieCatyBloc>()
                                  .add(GetMovieCategories());
                              context
                                  .read<SeriesCatyBloc>()
                                  .add(GetSeriesCategories());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomeScreen()),
                              );
                            },
                          ),
                          SizedBox(height: 5.h),
                          CardButtonWatchMovie(
                            title: "اضافة مستخدم جديد",
                            onTap: ()async {
                              context.read<AuthBloc>().add(AuthLogOut());
                              Get.offAllNamed("/");
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              await Get.deleteAll();
                              GetStorage().erase();
                            },
                          ),
                          SizedBox(height: 5.h),
                          CardButtonWatchMovie(
                            title: "تسجيل خروج",
                            onTap: () async {
                              context.read<AuthBloc>().add(AuthLogOut());
                              Get.offAllNamed("/");
                              Get.reload();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              GetStorage().erase();
                                  await Get.deleteAll();

                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      textDirection: TextDirection.rtl,
                      "تابعنا او اطلب تجديد اشتراكك",
                      style: TextStyle(
                        color: kColorPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SocialMediaRowWithText(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'CreatedBy:',
                          style: Get.textTheme.titleSmall!.copyWith(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            _launchURL('https://wa.me/966568291178');
                          },
                          child: Text(
                            ' @ Karim Abdelaziz',
                            style: Get.textTheme.titleSmall!.copyWith(
                              fontSize: 14.sp,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class SocialMediaRowWithText extends StatelessWidget {
  const SocialMediaRowWithText({Key? key}) : super(key: key);

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _launchURL(
                            'https://www.instagram.com/nahv187/'); // ضع رابط إنستجرام هنا
                      },
                      icon: Icon(
                        FontAwesomeIcons.instagram,
                        color: Colors.purple,
                        size: 30,
                      ),
                    ),
                    Text('Instagram',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.purple,
                        )),
                  ],
                ),
              ),

              const SizedBox(width: 20), // مسافة بين الأيقونات

              // أيقونة واتس آب مع النص
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _launchURL(
                            'https://api.whatsapp.com/send/?phone=966500976395&text&type=phone_number&app_absent=0'); // ضع رابط واتس آب هنا
                      },
                      icon: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                    Text('WhatsApp',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.green,
                        )),
                  ],
                ),
              ),

              SizedBox(width: 20), // مسافة بين الأيقونات

              // أيقونة سناب شات مع النص
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _launchURL(
                            'https://www.snapchat.com/add/ksa_r2024?invite_id=fdWwQHj7&locale=en_US&share_id=E1xf7zojTnCVgaxOgw036Q&sid=e6b5ca66c73e49448b935f0f37e2a150'); // ضع رابط سناب شات هنا
                      },
                      icon: Icon(
                        FontAwesomeIcons.snapchat,
                        color: Colors.yellow,
                        size: 30,
                      ),
                    ),
                    Text('Snapchat',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.yellow,
                        )),
                  ],
                ),
              ),

              SizedBox(width: 20), // مسافة بين الأيقونات

              // أيقونة تليجرام مع النص
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _launchURL(
                            'https://t.me/gold54652'); // ضع رابط تليجرام هنا
                      },
                      icon: Icon(
                        FontAwesomeIcons.telegram,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    Text('Telegram',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.blue,
                        )),
                  ],
                ),
              ),

              SizedBox(width: 20), // مسافة بين الأيقونات

              // أيقونة الموقع الإلكتروني مع النص
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _launchURL(
                            'https://contrac55t.com/'); // ضع رابط الموقع الإلكتروني هنا
                      },
                      icon: Icon(
                        FontAwesomeIcons.globe,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text('Store',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
