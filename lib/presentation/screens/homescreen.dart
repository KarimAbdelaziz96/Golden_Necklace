part of 'screens.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String keySearch = "";

  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    super.initState();
  }

  @override
  void dispose() {
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
    context.read<LiveCatyBloc>().add(GetLiveCategories());
    context.read<MovieCatyBloc>().add(GetMovieCategories());
    context.read<SeriesCatyBloc>().add(GetSeriesCategories());
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // تمكين السحب

          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const HomeImageAnimated(),
                Reedmore("الافلام", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieCategoriesScreen()),
                  );
                }),
                const displaymovie(
                  catyId: "",
                ),
                Reedmore("مسلسلات", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SeriesCategoriesScreen()),
                  );
                }),
                const displayseries(
                  catyId: '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
