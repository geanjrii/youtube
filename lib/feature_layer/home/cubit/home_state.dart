part of 'home_cubit.dart';

enum LoadingStatus { loading, error, success }

class HomeState extends Equatable {
  final LoadingStatus loadingStatus;

  final List<Video> videos;

  const HomeState({
    this.loadingStatus = LoadingStatus.loading,
    this.videos = const [],
  });

  HomeState copyWith({
    LoadingStatus? loadingStatus,
    List<Video>? videos,
  }) {
    return HomeState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      videos: videos ?? this.videos,
    );
  }

  @override
  List<Object?> get props => [loadingStatus, videos];
}
