class ThemeModel {
  int id;
  String name;
  String cover;
  String month;
  String coverurl;
  List<dynamic> months;
  ThemeModel(this.id, this.name, this.cover, month);

  ThemeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    // created_at = json['created_at'];
    // updated_at = json['updated_at'];
    // deleted_at = json['deleted_at'];
    month = json['month'];
    coverurl = json['cover_url'];
    months = json['months'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cover'] = this.cover;

    data['month'] = this.month;
    data['cover_url'] = this.coverurl;
    data['months'] = this.months;
    return data;
  }
}
