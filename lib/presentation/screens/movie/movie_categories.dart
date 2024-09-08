part of '../screens.dart';

class MovieCategoriesScreen extends StatefulWidget {
  const MovieCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<MovieCategoriesScreen> createState() => _MovieCategoriesScreenState();
}

class _MovieCategoriesScreenState extends State<MovieCategoriesScreen> {
  final ScrollController _hideButtonController = ScrollController();
  bool _hideButton = true;
  String keySearch = "";

  @override
  void initState() {
        SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_hideButton == true) {
          setState(() {
            _hideButton = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_hideButton == false) {
            setState(() {
              _hideButton = true;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: !_hideButton,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _hideButtonController.animateTo(0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.ease);
              _hideButton = true;
            });
          },
          backgroundColor: kColorPrimaryDark,
          child: const Icon(
            FontAwesomeIcons.chevronUp,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderImageAnimated(title: "استمتع بأجدد الافلام",),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Ink(
                  width: 100.w,
                  height: 100.h,
                  decoration: kDecorBackground,
                  child: NestedScrollView(
                    controller: _hideButtonController,
                    headerSliverBuilder: (_, ch) {
                      return [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          flexibleSpace: FlexibleSpaceBar(
                            background: AppBarMovie(
                              onSearch: (String value) {
                                setState(() {
                                  keySearch = value.toLowerCase();
                                });
                              },
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<MovieCatyBloc, MovieCatyState>(
                        builder: (context, state) {
                          if (state is MovieCatyLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is MovieCatySuccess) {
                            final categories = state.categories;
            
                            List<CategoryModel> searchList = categories
                                .where((element) => element.categoryName!
                                    .toLowerCase()
                                    .contains(keySearch))
                                .toList();
            
                            return GridView.builder(
                              shrinkWrap :false,
                              itemCount: keySearch.isEmpty
                                  ? categories.length
                                  : searchList.length,
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 15,
                                bottom: 100,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 5,
                              ),
                              itemBuilder: (_, i) {
                                final model = keySearch.isEmpty
                                    ? categories[i]
                                    : searchList[i];
            
                                return CardLiveItem(
                                  title: model.categoryName ?? "",
                                  onTap: () {
                                    // OPEN Channels
                                    Get.to(() => MovieChannels(
                                            catyId: model.categoryId ?? ''))!
                                        .then((value) async {});
                                  },
                                );
                              },
                            );
                          }
            
                          return const Center(
                            child: Text("Failed to load data..."),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
