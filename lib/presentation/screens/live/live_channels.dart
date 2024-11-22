// ignore_for_file: use_super_parameters, deprecated_member_use

part of '../screens.dart';

class LiveChannelsScreen extends StatefulWidget {
  const LiveChannelsScreen({super.key, required this.catyId});
  final String catyId;

  @override
  State<LiveChannelsScreen> createState() => _ListChannelsScreen();
}

class _ListChannelsScreen extends State<LiveChannelsScreen> {
  VlcPlayerController? _vlcPlayerController;

  int? selectedVideo;
  String? selectedStreamId;
  ChannelLive? channelLive;
  double lastPosition = 0.0;
  String keySearch = "";
  final FocusNode _remoteFocus = FocusNode();
  final String pageTitle = "Live Screen";
  bool isBuffering = true; 

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    Wakelock.enable();

    context.read<ChannelsBloc>().add(GetLiveChannelsEvent(
          catyId: widget.catyId,
          typeCategory: TypeCategory.live,
        ));
  }

  void _initializePlayer(String link) {
    _vlcPlayerController = VlcPlayerController.network(
      link,
      autoPlay: true,
      options: VlcPlayerOptions(
        extras: [
          '--network-caching=1500',
          '--file-caching=1500',   
          '--live-caching=3000',  
        ],
      ),
      onInit: () {
        setState(() {
          isBuffering = true;
        });
      },
    );

    _vlcPlayerController!.addListener(() {
      if (_vlcPlayerController!.value.isBuffering) {
        setState(() {
          isBuffering = true; 
        });
      } else {
        setState(() {
          isBuffering = false;
        });
      }
    });
  }

  void _stopPreviousVideo() async {
    if (_vlcPlayerController != null &&
        _vlcPlayerController!.value.isInitialized) {
      await _vlcPlayerController!.stop();
      await _vlcPlayerController!.dispose();
      _vlcPlayerController = null;
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    _remoteFocus.dispose();
if (_vlcPlayerController != null && _vlcPlayerController!.value.isInitialized) {
  _vlcPlayerController!.dispose();
  _vlcPlayerController = null;
}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, stateVideo) {
        return WillPopScope(
          onWillPop: () async {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
              context.read<VideoCubit>().changeUrlVideo(false);
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, stateAuth) {
              if (stateAuth is AuthSuccess) {
                final userAuth = stateAuth.user;

                return Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Builder(
                            builder: (context) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 3.h),
                                  BlocBuilder<FavoritesCubit, FavoritesState>(
                                    builder: (context, state) {
                                      final isLiked = channelLive == null
                                          ? false
                                          : state.lives
                                              .where((live) =>
                                                  live.streamId ==
                                                  channelLive!.streamId)
                                              .isNotEmpty;
                                      return AppBarLive(
                                        isLiked: isLiked,
                                        onLike: channelLive == null
                                            ? null
                                            : () {
                                                context
                                                    .read<FavoritesCubit>()
                                                    .addLive(channelLive,
                                                        isAdd: !isLiked);
                                              },
                                        onSearch: (String value) {
                                          setState(() {
                                            keySearch = value;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              );
                            },
                          ),
                          if (selectedVideo != null)
                            Container(
                              height:  MediaQuery.of(context).size.height * (isTablet(context) ? 0.5 : 0.3),
                              child: Stack(
                                children: [
                                  VlcPlayer(
                                    controller: _vlcPlayerController!,
                                    aspectRatio: 16 / 9,
                                    placeholder: Center(
                                      child: isBuffering
                                          ? CircularProgressIndicator()
                                          : const SizedBox(),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 30,
                                    right: 10,
                                    child: IconButton(
                                      icon: Icon(Icons.fullscreen,
                                          color: Colors.white, size: 30),
                                      onPressed: () {
                                        final link =
                                            "${userAuth.serverInfo!.serverUrl}/${userAuth.userInfo!.username}/${userAuth.userInfo!.password}/${channelLive!.streamId}";
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FullVideoScreen(
                                              link: link,
                                              title: "",
                                              isLive: true,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Ink(
                                width: 100.w,
                                height: 100.h,
                                decoration: kDecorBackground,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              return Expanded(
                                                child: BlocBuilder<ChannelsBloc,
                                                    ChannelsState>(
                                                  builder: (context, state) {
                                                    if (state
                                                        is ChannelsLoading) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    } else if (state
                                                        is ChannelsLiveSuccess) {
                                                      final categories =
                                                          state.channels;

                                                      List<ChannelLive>
                                                          searchList =
                                                          categories
                                                              .where((element) => element
                                                                  .name!
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      keySearch))
                                                              .toList();

                                                      return GridView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        itemCount: keySearch
                                                                .isEmpty
                                                            ? categories.length
                                                            : searchList.length,
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount:
                                                              selectedVideo ==
                                                                      null
                                                                  ? 1
                                                                  : 1,
                                                          mainAxisSpacing: 10,
                                                          crossAxisSpacing:
                                                              selectedVideo ==
                                                                      null
                                                                  ? 10
                                                                  : 0,
                                                          childAspectRatio: 7,
                                                        ),
                                                        itemBuilder: (_, i) {
                                                          final model =
                                                              keySearch.isEmpty
                                                                  ? categories[
                                                                      i]
                                                                  : searchList[
                                                                      i];

                                                          final link =
                                                              "${userAuth.serverInfo!.serverUrl}/${userAuth.userInfo!.username}/${userAuth.userInfo!.password}/${model.streamId}";

                                                          return CardLiveItem(
                                                            title: model.name ??
                                                                "",
                                                            image: model
                                                                .streamIcon,
                                                            link: link,
                                                            isSelected:
                                                                selectedVideo ==
                                                                        null
                                                                    ? false
                                                                    : selectedVideo ==
                                                                        i,
                                                            onTap: () async {
                                                              try {
                                                                if (selectedVideo ==
                                                                        i &&
                                                                    _vlcPlayerController !=
                                                                        null) 
                                                                        {
                                                                  // final link =
                                                                  //     "${userAuth.serverInfo!.serverUrl}/${userAuth.userInfo!.username}/${userAuth.userInfo!.password}/${model.streamId}";
                                                                  // // Navigator
                                                                  //     .push(
                                                                  //   context,
                                                                  //   MaterialPageRoute(
                                                                  //     builder:
                                                                  //         (context) =>
                                                                  //             FullVideoScreen(
                                                                  //       link:
                                                                  //           link,
                                                                  //       title: model.name ??
                                                                  //           "",
                                                                  //       isLive:
                                                                  //           true,
                                                                  //     ),
                                                                  //   ),
                                                                  // );
                                                                } else {
                                                                  _stopPreviousVideo();
                                                                  await Future.delayed(const Duration(
                                                                          milliseconds:
                                                                              100))
                                                                      .then(
                                                                          (value) {
                                                                    selectedVideo =
                                                                        i;
                                                                    _initializePlayer(
                                                                        link);
                                                                    setState(
                                                                        () {
                                                                      channelLive =
                                                                          model;
                                                                      selectedStreamId =
                                                                          model
                                                                              .streamId;
                                                                    });
                                                                  });
                                                                }
                                                              } catch (e) {
                                                                debugPrint(
                                                                    "خطأ: $e");
                                                                setState(() {
                                                                  channelLive =
                                                                      model;
                                                                  selectedStreamId =
                                                                      model
                                                                          .streamId;
                                                                });
                                                              }
                                                            },
                                                          );
                                                        },
                                                      );
                                                    }

                                                    return  const  Center(
                                                      child: Text(
                                                          "فشل في تحميل البيانات..."),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Scaffold();
            },
          ),
        );
      },
    );
  }
}
