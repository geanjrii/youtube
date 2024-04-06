 

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube/feature_layer/home/view/home.dart';
import 'package:youtube/feature_layer/main/cubit/main_cubit.dart';
import 'package:youtube/feature_layer/main/view/components/folder.dart';
import 'package:youtube/feature_layer/main/view/components/subscriptions.dart';
import 'package:youtube/feature_layer/main/view/components/what_shot.dart';

import 'components/delegate.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainCubit(),
      child: const MainView(),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final indiceAtual =
        context.select((MainCubit cubit) => cubit.state.currentIndex);
    List<Widget> telas = [
      HomePage(
        pesquisa: context.select((MainCubit cubit) => cubit.state.result),
         
      ),
      const WhatShot(),
      const Subscriptions(),
      const Folder(),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        backgroundColor: Colors.white,
        title: Image.asset(
          'images/youtube.png',
          width: 98,
          height: 22,
        ),
        actions: [
          // video cam button
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.videocam,
            ),
          ),
          //search button
          IconButton(
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: Delegate(),
              ).then((value) {
                context.read<MainCubit>().changeResult(value ?? '');
                
              });
 
            },
            icon: const Icon(
              Icons.search,
            ),
          ),

          // account  button
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_circle,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(
          16,
        ),
        child: telas[indiceAtual],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indiceAtual,
        onTap: (indice) {
          context.read<MainCubit>().changePage(indice);
    
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: const [
          //home Button
          BottomNavigationBarItem(
            label: 'Início',
            icon: Icon(Icons.home),
          ),
          // what Shot button
          BottomNavigationBarItem(
            label: 'Em alta',
            icon: Icon(Icons.whatshot),
          ),
          //subscriptions button
          BottomNavigationBarItem(
            label: 'Inscrições',
            icon: Icon(Icons.subscriptions),
          ),
          //folder button
          BottomNavigationBarItem(
            label: 'Biblioteca',
            icon: Icon(Icons.folder),
          ),
        ],
      ),
    );
  }
}
