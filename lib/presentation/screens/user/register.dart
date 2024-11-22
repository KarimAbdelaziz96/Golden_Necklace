part of '../screens.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _urlController = TextEditingController();
  bool _isPasswordVisible = false;
  String _Urlfirebase = "";
  bool _istextFieldVisible = true;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    firebasecontroller();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    context.read<ChannelsBlocmovie>().add(GetLiveChannelsEvent(
          typeCategory: TypeCategory.movies,
          catyId: "",
        ));
    context.read<ChannelsBloseries>().add(GetLiveChannelsEvent(
          typeCategory: TypeCategory.series,
          catyId: "",
        ));
    context.read<ChannelsBloc>().add(GetLiveChannelsEvent(
          typeCategory: TypeCategory.series,
          catyId: "",
        ));
    context.read<ChannelsBloc>().add(GetLiveChannelsEvent(
          typeCategory: TypeCategory.movies,
          catyId: "",
        ));
    context.read<ChannelsBloc>().add(GetLiveChannelsEvent(
          typeCategory: TypeCategory.live,
          catyId: "",
        ));
    context.read<LiveCatyBloc>().add(GetLiveCategories());
    context.read<MovieCatyBloc>().add(GetMovieCategories());
    context.read<SeriesCatyBloc>().add(GetSeriesCategories());
    await Future.delayed(Duration(seconds: 5));
  }

  void firebasecontroller() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('host')
          .doc('server_config')
          .get();
      setState(() {
        _Urlfirebase = document.get("url") ?? "";
        _istextFieldVisible = document["textFieldVisible"] as bool ?? true;
      });
      // print("======= URL FIREBASE======$_Urlfirebase=======");
    } catch (e) {
      // print('Error fetching data from Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Get.textTheme.bodyMedium!.copyWith(
      color: Colors.white,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: Ink(
        width: Get.width,
        height: Get.height,
        decoration: kDecorBackground,
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, stateSetting) {
            return SafeArea(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailed) {
                    showWarningToast(
                      context,
                      'Login failed.',
                      'Please check your IPTV credentials and try again.',
                    );
                  } else if (state is AuthSuccess) {
                    context.read<LiveCatyBloc>().add(GetLiveCategories());
                    context.read<MovieCatyBloc>().add(GetMovieCategories());
                    context.read<SeriesCatyBloc>().add(GetSeriesCategories());
                    Get.offAndToNamed(screenWelcome);
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return IgnorePointer(
                    ignoring: isLoading,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(
                                    FontAwesomeIcons.chevronLeft,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 2.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        kIconSplash,
                                        width: .7.dp,
                                        height: .7.dp,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'قم بتسجيل الدخول لاكتشاف جميع الأفلام والبرامج التلفزيونية والتلفزيون المباشر، واستمتع بمميزاتنا.',
                                    textAlign: TextAlign.center,
                                    style: Get.textTheme.bodyLarge!.copyWith(
                                      color: kColorPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _username,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            hintText: "اسم المستخدم",
                                            hintStyle: Get.textTheme.bodyMedium!
                                                .copyWith(
                                              color: Colors.grey,
                                            ),
                                            suffixIcon: const Icon(
                                              FontAwesomeIcons.solidUser,
                                              size: 18,
                                              color: kColorPrimary,
                                            ),
                                          ),
                                          style: style,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'الرجاء إدخال اسم المستخدم';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 15),
                                        TextFormField(
                                          controller: _password,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            hintText: "كلمة المرور",
                                            hintStyle: Get.textTheme.bodyMedium!
                                                .copyWith(
                                              color: Colors.grey,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _isPasswordVisible
                                                    ? FontAwesomeIcons.eyeSlash
                                                    : FontAwesomeIcons.eye,
                                                size: 18,
                                                color: kColorPrimary,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isPasswordVisible =
                                                      !_isPasswordVisible;
                                                });
                                              },
                                            ),
                                          ),
                                          style: style,
                                          obscureText: !_isPasswordVisible,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'الرجاء إدخال كلمة المرور';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 15),
                                        if (_istextFieldVisible == true)
                                          TextFormField(
                                            controller: _urlController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              hintText: "عنوان URL للخادم",
                                              hintStyle: Get
                                                  .textTheme.bodyMedium!
                                                  .copyWith(
                                                color: Colors.grey,
                                              ),
                                              suffixIcon: const Icon(
                                                FontAwesomeIcons.link,
                                                size: 18,
                                                color: kColorPrimary,
                                              ),
                                            ),
                                            style: style,

                                            // validator: (value) {
                                            //   if (value == null ||
                                            //       value.isEmpty) {
                                            //     return 'الرجاء إدخال عنوان URL للخادم';
                                            //   }
                                            //   if (!Uri.parse(value)
                                            //       .isAbsolute) {
                                            //     return 'الرجاء إدخال عنوان URL صحيح';
                                            //   }
                                            //   return null;
                                            // },
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.solidCircle,
                                            color: Colors.white70,
                                            size: 10.sp,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              var url = Uri.parse(kPrivacy);
                                              await launchUrl(url,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            },
                                            child: Text(
                                              'سياسة الخصوصية ',
                                              style: Get.textTheme.bodyMedium!
                                                  .copyWith(
                                                fontSize: 10,
                                                color: kColorPrimary
                                                    .withOpacity(.70),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'من خلال التسجيل فإنك توافق على شروطنا',
                                            style: Get.textTheme.bodyMedium!
                                                .copyWith(
                                              fontSize: 10,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: BlocListener<AuthBloc, AuthState>(
                              listener: (context, state) {
                                if (state is AuthSuccess) {
                                  _refreshData();
                                  context
                                      .read<LiveCatyBloc>()
                                      .add(GetLiveCategories());
                                  context
                                      .read<MovieCatyBloc>()
                                      .add(GetMovieCategories());
                                  context
                                      .read<SeriesCatyBloc>()
                                      .add(GetSeriesCategories());
                                  Get.offAndToNamed(screenWelcome);
                                } else if (state is AuthFailed) {
                                  showWarningToast(
                                    context,
                                    'Login failed.',
                                    'Please check your IPTV credentials and try again.',
                                  );
                                }
                              },
                              child: CardTallButton(
                                label: "تسجيل الدخول",
                                isLoading: isLoading,
                                onTap: () async {
                                  if (_istextFieldVisible == false) {
                                    if (_username.text.isNotEmpty &&
                                        _password.text.isNotEmpty) {
                                      context.read<AuthBloc>().add(AuthRegister(
                                            _username.text,
                                            _password.text,
                                            _Urlfirebase.toString(),
                                          ));
                                    }
                                  } 
                                  else {
                                    if (_username.text.isNotEmpty &&
                                        _password.text.isNotEmpty &&
                                        _urlController.text.isNotEmpty) {
                                      context.read<AuthBloc>().add(AuthRegister(
                                            _username.text,
                                            _password.text,
                                            _urlController.text,
                                          ));
                                    }
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
