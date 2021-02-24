class PackagesListModel {
  int id;
  String name;
  String description;
  int amount;
  int no_of_days_validity;
  dynamic status;

  PackagesListModel(this.id, this.name, this.description, this.amount,
      this.no_of_days_validity, this.status);

  PackagesListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    amount = json['amount'];
    no_of_days_validity = json['no_of_days_validity'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['no_of_days_validity'] = this.no_of_days_validity;
    data['status'] = this.status;
    return data;
  }
}
