import 'dart:async';

import 'package:flutter/services.dart';
import 'package:goldennecklace/logic/blocs/categories/channels/channels_bloc.dart';
import 'package:goldennecklace/repository/models/channel_live.dart';
import 'package:goldennecklace/repository/models/channel_movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pod_player/pod_player.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../helpers/helpers.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/cubits/video/video_cubit.dart';
import '../../logic/cubits/watch/watching_cubit.dart';
import '../../repository/models/channel_serie.dart';
import '../../repository/models/serie_details.dart';
import '../../repository/models/watching.dart';
import '../screens/screens.dart';

part 'dialog.dart';
part 'live.dart';
part 'movie.dart';
part 'user.dart';
part 'welcome.dart';
part 'watching.dart';
part 'navigtion_bar.dart';
part 'home_widget.dart';
