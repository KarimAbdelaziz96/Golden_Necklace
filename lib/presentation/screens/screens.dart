import 'dart:async';
import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:better_player/better_player.dart';
import 'package:better_player/better_player.dart';
import 'package:better_player/better_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filling_slider/filling_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:http/http.dart' as http;
import 'package:cast/cast.dart';

import '../../helpers/helpers.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/categories/channels/channels_bloc.dart';
import '../../logic/blocs/categories/live_caty/live_caty_bloc.dart';
import '../../logic/blocs/categories/movie_caty/movie_caty_bloc.dart';
import '../../logic/blocs/categories/series_caty/series_caty_bloc.dart';
import '../../logic/cubits/favorites/favorites_cubit.dart';
import '../../logic/cubits/settings/settings_cubit.dart';
import '../../logic/cubits/video/video_cubit.dart';
import '../../logic/cubits/watch/watching_cubit.dart';
import '../../repository/api/api.dart';
import '../../repository/models/category.dart';
import '../../repository/models/channel_live.dart';
import '../../repository/models/channel_movie.dart';
import '../../repository/models/channel_serie.dart';
import '../../repository/models/epg.dart';
import '../../repository/models/movie_detail.dart';
import '../../repository/models/serie_details.dart';
import '../../repository/models/watching.dart';
import '../widgets/widgets.dart';

part 'live/live_categories.dart';
part 'live/live_channels.dart';
part 'movie/movie_categories.dart';
part 'movie/movie_channels.dart';
part 'movie/movie_details.dart';
part 'player/full_video.dart';
part 'player/player_video.dart';
part 'series/serie_details.dart';
part 'series/serie_seasons.dart';
part 'series/series_categories.dart';
part 'series/series_channels.dart';
part 'user/demo.dart';
part 'user/register.dart';
// part 'user/register_tv.dart';
part 'user/settings.dart';
part 'user/splash.dart';
part 'user/intro.dart';
part 'user/favourites.dart';
part 'welcome.dart';
part 'user/catch_up.dart';
part 'homescreen.dart';
 bool _istextFieldVisible = true;
