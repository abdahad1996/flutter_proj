class AdsModel {
  String attachment_url;
  String url;
  AdsModel(this.attachment_url, this.url);

  AdsModel.fromJson(Map<String, dynamic> json) {
    attachment_url = json['attachment_url'];

    url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attachment_url'] = this.attachment_url;
    data["url"] = this.url;
    return data;
  }
}
