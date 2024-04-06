// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube/data_layer/data_layer.dart';
import 'package:youtube/domain_layer/youtube_repository.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.pesquisa});

  final String pesquisa;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(api: YoutubeRepository(api: YoutubeApi()))
        ..buscarVideos(pesquisa),
      child: HomeView(pesquisa: pesquisa),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.pesquisa,
  });
  final String pesquisa;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pesquisa != oldWidget.pesquisa) {
      context.read<HomeCubit>().buscarVideos(widget.pesquisa);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return switch (state.loadingStatus) {
          LoadingStatus.loading => const LoadingPage(),
          LoadingStatus.error => const ErrorPage(),
          LoadingStatus.success => SuccessPage(list: state.videos),
        };
      },
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Nenhum dado a ser exibido!'),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({
    super.key,
    required this.list,
  });

  final List<Video> list;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        Video video = list[index];
        return ListItem(video: video);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 2,
          color: Colors.grey,
        );
      },
      itemCount: list.length,
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.video,
  });

  final Video video;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        YoutubePlayerController controller = YoutubePlayerController(
          initialVideoId: video.id,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(video.imagem),
            )),
          ),
          ListTile(
            title: Text(video.titulo),
            subtitle: Text(video.canal),
          )
        ],
      ),
    );
  }
}
