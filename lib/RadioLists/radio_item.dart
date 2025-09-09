class RadioItem {

  final String id;
  final String nameOfStation;
  final String urlLink;

  RadioItem({required this.id, required this.nameOfStation, required this.urlLink});

  factory RadioItem.fromJson(Map<String, dynamic> json) {
        return RadioItem(
          id: json['id'],
          nameOfStation: json['nameOfStation'],
          urlLink: json['urllink'],
        );
      }


}