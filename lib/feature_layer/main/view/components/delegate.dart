import 'package:flutter/material.dart';
import 'package:youtube/domain_layer/youtube_repository.dart';

import '../../../../data_layer/youtube_api/youtube_api.dart';

class Delegate extends SearchDelegate<String> {
  final _controller = YoutubeRepository(api: YoutubeApi());

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _controller.getSuggestions(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: LoadingPage(),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(snapshot.data![index]),
                  leading: const Icon(
                    Icons.play_arrow,
                  ),
                  onTap: () {
                    close(context, snapshot.data![index]);
                  });
            },
            itemCount: snapshot.data!.length,
          );
        }
      },
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

 
