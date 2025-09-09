class Playlist {

  final String id;
  final String playListName;
  final List<String> radioItemId;

  Playlist({required this.id, required this.playListName, required this.radioItemId});

  factory Playlist.fromJson(Map<String, dynamic> json) {
        return Playlist(
          id: json['id'],
          playListName: json['playListName'],
          radioItemId: json['radioItemId'],
        );
      }


}