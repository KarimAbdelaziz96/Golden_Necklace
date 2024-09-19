part of 'helpers.dart';

const String kAppName = "العقد الذهبي";

//TODO: SHow Ads ( true / false )
const bool showAds = false;
//  bool isTaplet = false;

bool isTablet(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.shortestSide;
  return deviceWidth > 600; // إذا كان عرض الجهاز أكبر من 600 بكسل، يعتبر تابلت
}

const String kIconLive = "assets/images/live-stream.png";
const String kIconSeries = "assets/images/clapperboard.png";
const String kIconMovies = "assets/images/film-reel.png";
const String kIconSplash = "assets/images/logo.png";
const String kImageIntro = "assets/images/intro h.jpeg";


const String IconMovies = "assets/icons/movie.svg";
const String IconSeries = "assets/icons/series.svg";
const String IconLive = "assets/icons/livestream.svg";
const String IconHome = "assets/icons/home.svg";
const String IconSetting = "assets/icons/setting.svg";







const String kPrivacy = "https://www.freeprivacypolicy.com/live/7ee9e7b0-ed3b-4a8f-8bf6-46641098e34d";
const String kContact = "";

const double sizeTablet = 950;

enum TypeCategory {
  all,
  live,
  movies,
  series,
}

Size getSize(BuildContext context) => MediaQuery.of(context).size;

bool isTv(BuildContext context) {
  return MediaQuery.of(context).size.width > sizeTablet;
}
