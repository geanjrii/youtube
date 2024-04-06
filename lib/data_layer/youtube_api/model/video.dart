import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final String id;
  final String titulo;
  final String imagem;
  final String canal;
  final String descricao;

  const Video({
    required this.id,
    required this.titulo,
    required this.imagem,
    required this.canal,
    required this.descricao,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id']['videoId'],
      titulo: json['snippet']['title'],
      imagem: json['snippet']['thumbnails']['high']['url'],
      canal: json['snippet']['channelId'],
      descricao: json['snippet']['description'],
    );
  }

  @override
  List<Object?> get props => [id, titulo, imagem, canal, descricao];
}
