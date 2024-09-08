part of '../screens.dart';

class MovieContent extends StatefulWidget {
  const MovieContent(
      {Key? key, required this.videoId, required this.channelMovie})
      : super(key: key);
  final String videoId;
  final ChannelMovie channelMovie;

  @override
  State<MovieContent> createState() => _MovieContentState();
}

class _MovieContentState extends State<MovieContent> {
  late Future<MovieDetail?> future;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
 
    ]);
    future = IpTvApi.getMovieDetails(widget.videoId);
    super.initState();
  }

  @override
  void dispose() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Ink(
          decoration: kDecorBackground,
          child: SingleChildScrollView(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthSuccess) {
                  final userAuth = state.user;
                  return Stack(
                    children: [
                      FutureBuilder<MovieDetail?>(
                        future: future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!snapshot.hasData) {
                            return const Center(
                              child: Text("Could not load data"),
                            );
                          }
            
                          final movie = snapshot.data;
            
                          return Stack(
                            children: [
                              CardMovieImagesBackground(
                                listImages: movie!.info!.backdropPath ??
                                    [
                                      movie.info!.movieImage ?? "",
                                    ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10.h, left: 10, right: 10, bottom: 10),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(25),
                                                child: CardMovieImageRate(
                                                  image:
                                                      movie.info!.movieImage ??
                                                          "",
                                                  rate:
                                                      movie.info!.rating ?? "0",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      movie.movieData!.name ?? "",
                                      style: Get.textTheme.displaySmall,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (movie.info!.youtubeTrailer !=
                                                null &&
                                            movie.info!.youtubeTrailer!
                                                .isNotEmpty)
                                          CardButtonWatchMovie(
                                            title: "watch trailer",
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (builder) =>
                                                      DialogTrailerYoutube(
                                                          thumb: movie
                                                                  .info!
                                                                  .backdropPath!
                                                                  .isNotEmpty
                                                              ? movie
                                                                  .info!
                                                                  .backdropPath!
                                                                  .first
                                                              : null,
                                                          trailer: movie.info!
                                                                  .youtubeTrailer ??
                                                              ""));
                                            },
                                          ),
                                        SizedBox(width: 3.w),
                                        CardButtonWatchMovie(
                                          title: "watch Now",
                                          isFocused: true,
                                          onTap: () {
                                            final link =
                                                "${userAuth.serverInfo!.serverUrl}/movie/${userAuth.userInfo!.username}/${userAuth.userInfo!.password}/${movie.movieData!.streamId}.${movie.movieData!.containerExtension}";
            
                                            Get.to(() => FullVideoScreen(
                                                      link: link,
                                                      title: movie.movieData!
                                                              .name ??
                                                          "",
                                                    ))!
                                                .then((slider) {
                                              debugPrint("DATA: $slider");
                                              if (slider != null) {
                                                var model = WatchingModel(
                                                  sliderValue: slider[0],
                                                  durationStrm: slider[1],
                                                  stream: link,
                                                  title: widget
                                                          .channelMovie.name ??
                                                      "",
                                                  image: widget.channelMovie
                                                          .streamIcon ??
                                                      "",
                                                  streamId: widget
                                                      .channelMovie.streamId
                                                      .toString(),
                                                );
                                                context
                                                    .read<WatchingCubit>()
                                                    .addMovie(model);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CardInfoMovie(
                                                  icon: FontAwesomeIcons.film,
                                                  hint: 'النوع:',
                                                  title:
                                                      movie.info!.genre ?? "",
                                                ),
                                              ),
                                              Spacer(),
                                              // const SizedBox(width: 15),
                                              Expanded(
                                                child: CardInfoMovie(
                                                  icon: FontAwesomeIcons.clock,
                                                  hint: 'المدة',
                                                  title: movie.info!.duration ??
                                                      "",
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              CardInfoMovie(
                                                icon: FontAwesomeIcons
                                                    .clapperboard,
                                                hint: 'المخرج',
                                                title:
                                                    movie.info!.director ?? "",
                                              ),
                                              Spacer(),
                                              CardInfoMovie(
                                                icon: FontAwesomeIcons
                                                    .calendarDay,
                                                hint: 'تاريخ الاصدار',
                                                title: expirationDate(
                                                    movie.info!.releasedate),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Column(
                                            children: [
                                              CardInfoMovie(
                                                icon: FontAwesomeIcons
                                                    .solidClosedCaptioning,
                                                hint: 'الملخص:',
                                                title: movie.info!.plot ?? "",
                                                isShowMore: true,
                                              ),
                                              const SizedBox(height: 15),
                                              CardInfoMovie(
                                                icon: FontAwesomeIcons.users,
                                                hint: 'فريق العمل',
                                                isShowMore: true,
                                                title: movie.info!.cast ?? "",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, state) {
                            final isLiked = state.movies
                                .where((movie) =>
                                    movie.streamId ==
                                    widget.channelMovie.streamId)
                                .isNotEmpty;
                            return AppBarMovie(
                              isLiked: isLiked,
                              top: 2.h,
                              onFavorite: () {
                                context.read<FavoritesCubit>().addMovie(
                                    widget.channelMovie,
                                    isAdd: !isLiked);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
            
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
