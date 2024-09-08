import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goldennecklace/helpers/helpers.dart';
import 'package:goldennecklace/repository/models/channel_movie.dart';

import '../../../../repository/api/api.dart';
import '../../../../repository/models/channel_live.dart';
import '../../../../repository/models/channel_serie.dart';

part 'channels_event.dart';
part 'channels_state.dart';

class ChannelsBloc extends Bloc<ChannelsEvent, ChannelsState> {
  final IpTvApi api;
  ChannelsBloc(this.api) : super(ChannelsLoading()) {
    on<GetLiveChannelsEvent>((event, emit) async {
      emit(ChannelsLoading());
      print(
          'Fetching channels for category: ${event.typeCategory} and ID: ${event.catyId}');
      if (event.typeCategory == TypeCategory.live) {
        final result = await api.getLiveChannels(event.catyId);
        emit(ChannelsLiveSuccess(result));
        print('Fetched live channels: ${result.length}');
      } else if (event.typeCategory == TypeCategory.movies) {
        final result = await api.getMovieChannels(event.catyId);
        emit(ChannelsMovieSuccess(result));
        print('Fetched movies channels: ${result.length}');
      } else if (event.typeCategory == TypeCategory.series) {
        final result = await api.getSeriesChannels(event.catyId);
        emit(ChannelsSeriesSuccess(result));
        print('Fetched series channels: ${result.length}');
      }
    });
  }
}

class ChannelsBlocmovie extends Bloc<ChannelsEvent, ChannelsState> {
  final IpTvApi api;
  ChannelsBlocmovie(this.api) : super(ChannelsLoading()) {
    on<GetLiveChannelsEvent>((event, emit) async {
      emit(ChannelsLoading());
      print(
          'Fetching channels for category: ${event.typeCategory} and ID: ${event.catyId}');
      if (event.typeCategory == TypeCategory.movies) {
        final result = await api.getMovieChannels(event.catyId);
        emit(ChannelsMovieSuccess(result));
        print('Fetched movies channels: ${result.length}');
      } 
    });
  }
}

class ChannelsBloseries extends Bloc<ChannelsEvent, ChannelsState> {
  final IpTvApi api;
  ChannelsBloseries(this.api) : super(ChannelsLoading()) {
    on<GetLiveChannelsEvent>((event, emit) async {
      emit(ChannelsLoading());
      print(
          'Fetching channels for category: ${event.typeCategory} and ID: ${event.catyId}');
     if (event.typeCategory == TypeCategory.series) {
        final result = await api.getSeriesChannels(event.catyId);
        emit(ChannelsSeriesSuccess(result));
        print('Fetched series channels: ${result.length}');
      }
    });
  }
}