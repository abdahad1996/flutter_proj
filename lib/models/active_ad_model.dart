class AdsModel {
  String attachment_url;

  AdsModel(this.attachment_url);

  AdsModel.fromJson(Map<String, dynamic> json) {
    attachment_url = json['attachment_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attachment_url'] = this.attachment_url;
    return data;
  }
}
