part of 'widgets.dart';

class Reedmore extends StatelessWidget {
  const Reedmore(
    this.titel,
    this.ontap,
  );
  final String titel;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    TextStyle styletext = const TextStyle(
        fontWeight: FontWeight.w900, color: kColorPrimary, fontSize: 15);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        border: Border.all(
          color: kColorPrimary,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          TextButton(
              onPressed: ontap,
              child: Text(
                "المزيد",
                style: styletext,
              )),
          Spacer(),
          Text(
            titel,
            style: styletext,
          ),
        ],
      ),
    );
  }
}

class displaymovie extends StatefulWidget {
  final String catyId;

  const displaymovie({Key? key, required this.catyId}) : super(key: key);

  @override
  State<displaymovie> createState() => _displaymovieState();
}

class _displaymovieState extends State<displaymovie>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  String keySearch = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<ChannelsBlocmovie>().add(GetLiveChannelsEvent(
          typeCategory: TypeCategory.movies,
          catyId: widget.catyId,
        ));

    _scrollTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_scrollController.hasClients) {
        double maxScrollExtent = _scrollController.position.maxScrollExtent;
        double currentScrollOffset = _scrollController.offset;

        if (currentScrollOffset < maxScrollExtent) {
          _scrollController.animateTo(
            currentScrollOffset + 2,
            duration: Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        } else {
          _scrollController.jumpTo(0);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height:
          MediaQuery.of(context).size.height * (isTablet(context) ? 0.5 : 0.3),
      child: BlocBuilder<ChannelsBlocmovie, ChannelsState>(
        builder: (context, state) {
          if (state is ChannelsLoading) {
            return Center(
                child: LoadingAnimationWidget.inkDrop(
                    color: kColorPrimary, size: 25));
          } else if (state is ChannelsMovieSuccess) {
            final channels = state.channels;
            List<ChannelMovie> searchList = channels
                .where((element) =>
                    element.name!.toLowerCase().contains(keySearch))
                .toList();
            return GridView.builder(
              // reverse: true,
              key: ValueKey(channels),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              itemCount:
                  keySearch.isEmpty ? channels.length : searchList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.6,
              ),
              itemBuilder: (_, i) {
                final model = keySearch.isEmpty ? channels[i] : searchList[i];
                return CardChannelMovieItem(
                  title: model.name,
                  image: model.streamIcon,
                  onTap: () {
                    if (model.streamId != null) {
                      Get.to(() => MovieContent(
                          channelMovie: model, videoId: model.streamId!));
                    }
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class displayseries extends StatefulWidget {
  final String catyId;

  const displayseries({Key? key, required this.catyId}) : super(key: key);

  @override
  State<displayseries> createState() => _displayseriesState();
}

class _displayseriesState extends State<displayseries>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  String keySearch = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<ChannelsBloseries>().add(GetLiveChannelsEvent(
          typeCategory: TypeCategory.series,
          catyId: widget.catyId,
        ));

    _scrollTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_scrollController.hasClients) {
        double maxScrollExtent = _scrollController.position.maxScrollExtent;
        double currentScrollOffset = _scrollController.offset;

        if (currentScrollOffset < maxScrollExtent) {
          _scrollController.animateTo(
            currentScrollOffset + 2,
            duration: Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        } else {
          _scrollController.jumpTo(0);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height:
          MediaQuery.of(context).size.height * (isTablet(context) ? 0.5 : 0.3),
      child: BlocBuilder<ChannelsBloseries, ChannelsState>(
        builder: (context, state) {
          if (state is ChannelsLoading) {
            return Center(
                child: LoadingAnimationWidget.inkDrop(
                    color: kColorPrimary, size: 25));
          } else if (state is ChannelsSeriesSuccess) {
            final channels = state.channels;
            final List<ChannelSerie> searchList = channels
                .where((element) =>
                    element.name!.toLowerCase().contains(keySearch))
                .toList();
            if (channels.isEmpty) {
              return const Center(
                child: Text('لا توجد مسلسلات متاحة.',
                    style: TextStyle(color: Colors.white)),
              );
            }

            return GridView.builder(
              reverse: true,
              key: ValueKey(channels),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              itemCount:
                  keySearch.isEmpty ? channels.length : searchList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.6,
              ),
              itemBuilder: (_, i) {
                final model = searchList[i];
                return CardChannelMovieItem(
                  title: model.name ?? "",
                  image: model.cover ?? "",
                  onTap: () {
                    Get.to(() => SerieContent(
                            channelSerie: model,
                            videoId: model.seriesId ?? ''))!
                        .then((value) async {});
                  },
                );
              },
            );
          } else if (state is ChannelsError) {
            return Center(
              child: Text('حدث خطأ: ${state.message}'),
            );
          } else {
            return const Center(
              child: Text('لا توجد بيانات متاحة.',
                  style: TextStyle(color: Colors.white)),
            );
          }
        },
      ),
    );
  }
}

class HomeImageAnimated extends StatefulWidget {
  final bool isTv;
  const HomeImageAnimated({Key? key, this.isTv = false}) : super(key: key);

  @override
  State<HomeImageAnimated> createState() => _HomeImageAnimatedState();
}

class _HomeImageAnimatedState extends State<HomeImageAnimated> {
  bool isImage = true;
  ScrollController controller = ScrollController();

  _startAnimation() async {
    const int second = 27;

    await Future.delayed(const Duration(milliseconds: 400));

    if (controller.hasClients) {
      await controller.animateTo(
        isImage ? controller.position.maxScrollExtent : 0,
        duration: const Duration(seconds: second),
        curve: Curves.linear,
      );

      if (mounted) {
        setState(() {
          isImage = !isImage;
        });
        await _startAnimation();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = getSize(context).height / (widget.isTv ? 1 : 2);
    return SizedBox(
      height:
          MediaQuery.of(context).size.height * (isTablet(context) ? 0.2 : 0.3),
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: getSize(context).width,
              height: height,
              child: SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                child: Image.asset(
                  kImageIntro,
                  fit: BoxFit.cover,
                  width: getSize(context).width + 140,
                ),
              ),
            ),
            Opacity(
              opacity: widget.isTv ? 0 : .5,
              child: Container(
                width: getSize(context).width,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.isTv ? [Kmoon1] : [Kmoon2, Kmoon3],
                  ),
                ),
              ),
            ),
           
              
               Expanded(
                 child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Image.asset(
                         kIconSplash,
                         height: 120,
                         width: 150,
                       ),
                       const SizedBox(height: 3),
                       Container(
                         width: MediaQuery.of(context).size.height *
                             (isTablet(context) ? 0.5 : 0.3),
                         decoration: BoxDecoration(
                             borderRadius: const BorderRadius.only(
                                 bottomRight: Radius.circular(15),
                                 topLeft: Radius.circular(15)),
                             border: Border.all(
                               color: kColorPrimary,
                               width: 0.5,
                             ),
                             color: Colors.black),
                         child: BlocBuilder<AuthBloc, AuthState>(
                           builder: (context, state) {
                             if (state is AuthSuccess) {
                               final userInfo = state.user.userInfo;
                               return Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text(
                                       dateNowWelcome(),
                                       style: Get.textTheme.titleSmall!
                                           .copyWith(color: kColorPrimary),
                                     ),
               
                                     Row(
                                       mainAxisAlignment:
                                           MainAxisAlignment.center,
                                       children: [
                                         Text(
                                           "Expiration:",
                                           style: Get.textTheme.titleSmall!
                                               .copyWith(
                                                   color: kColorPrimary,
                                                   fontWeight: FontWeight.w900),
                                         ),
                                         Text(
                                           " ${expirationDate(userInfo!.expDate)}",
                                           style: Get.textTheme.titleSmall!
                                               .copyWith(
                                             color: Colors.red,
                                           ),
                                         ),
                                       ],
                                     ),
                                  
                                   ],
                                 ),
                               );
                             }
                                         
                             return const SizedBox();
                           },
                         ),
                       )
                     ]),
               ),
           
          ],
        ),
      ),
    );
  }
}

class HeaderImageAnimated extends StatefulWidget {
  final String title;
  const HeaderImageAnimated({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<HeaderImageAnimated> createState() => _HeaderImageAnimatedState();
}

class _HeaderImageAnimatedState extends State<HeaderImageAnimated> {
  bool isImage = true;
  ScrollController controller = ScrollController();

  _startAnimation() async {
    const int second = 27;

    await Future.delayed(const Duration(milliseconds: 400));

    if (controller.hasClients) {
      await controller.animateTo(
        isImage ? controller.position.maxScrollExtent : 0,
        duration: const Duration(seconds: second),
        curve: Curves.linear,
      );

      if (mounted) {
        setState(() {
          isImage = !isImage;
        });
        await _startAnimation();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = getSize(context).height;
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SizedBox(
        height: MediaQuery.of(context).size.height *
            (isTablet(context) ? 0.2 : 0.3),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: getSize(context).width,
              height: height,
              child: SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                child: Image.asset(
                  kImageIntro,
                  fit: BoxFit.cover,
                  width: getSize(context).width + 140,
                ),
              ),
            ),
            Opacity(
              opacity: 0.9,
              child: Container(
                width: getSize(context).width,
                height: height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kColorCardDarkness, kColorCardDarkness],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      kIconSplash,
                      height: 120,
                      width: 150,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.title,
                      style: Get.textTheme.titleSmall!
                          .copyWith(color: kColorPrimary),
                    ),
                    Text(
                      "الترفية بين يديك",
                      style: Get.textTheme.titleSmall!
                          .copyWith(color: kColorPrimary),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
