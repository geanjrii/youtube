import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youtube/domain_layer/youtube_repository.dart';

import '../../../data_layer/youtube_api/model/video.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.api}) : super(const HomeState());

  final YoutubeRepository api;

  Future<void> buscarVideos(String pesquisa) async {
    try {
      emit(state.copyWith(loadingStatus: LoadingStatus.loading));
      final search = await api.search(pesquisa);
      emit(state.copyWith(loadingStatus: LoadingStatus.success, videos: search));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(loadingStatus: LoadingStatus.error));
    }
  }
}

