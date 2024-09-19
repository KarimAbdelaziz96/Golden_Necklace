part of 'screens.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String keySearch = "";

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding:
                EdgeInsets.all(screenWidth * 0.03),    
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeImageAnimated(),
                SizedBox(height: screenHeight * 0.02), 
                Reedmore("الافلام", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieCategoriesScreen()),
                  );
                }),
                SizedBox(height: screenHeight * 0.01),
                const displaymovie(
                  catyId: "",
                ),
                SizedBox(height: screenHeight * 0.02), 
                Reedmore("مسلسلات", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SeriesCategoriesScreen()),
                  );
                }),
                SizedBox(height: screenHeight * 0.01), 
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
