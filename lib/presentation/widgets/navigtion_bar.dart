
part of 'widgets.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    const LiveCategoriesScreen(),
    const MovieCategoriesScreen(),
    const SeriesCategoriesScreen(),
    const FavouriteScreen(),  // شاشة المفضلة
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        curveSize: 25,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        color: Colors.white,
        activeColor: const Color.fromRGBO(0, 0, 0, 0),
        items: <TabItem>[
          TabItem(
            icon: SvgPicture.asset(
              IconHome,
              color: kColorPrimary,
              height: 24.0,
              width: 24.0,
            ),
            title: 'الرئيسية',
          ),
          TabItem(
            icon: SvgPicture.asset(
              IconLive,
              color: kColorPrimary,
              height: 24.0,
              width: 24.0,
            ),
            title: 'بث مباشر',
          ),
          TabItem(
            icon: SvgPicture.asset(
              IconMovies,
              color: kColorPrimary,
              height: 24.0,
              width: 24.0,
            ),
            title: 'افلام',
          ),
          TabItem(
            icon: SvgPicture.asset(
              IconSeries,
              color: kColorPrimary,
              height: 24.0,
              width: 24.0,
            ),
            title: 'مسلسلات',
          ),
          TabItem(
            icon: Icon(
              FontAwesomeIcons.heart,
              color: kColorPrimary,
              size: 26.0,
            ),
            title: 'المفضلة',
          ),
          TabItem(
            icon: SvgPicture.asset(
              IconSetting,
              color: kColorPrimary,
              height: 24.0,
              width: 24.0,
            ),
            title: 'الاعدادات',
          ),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
