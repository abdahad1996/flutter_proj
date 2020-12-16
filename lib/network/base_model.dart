class BaseModel {
  bool success;
  String message;
  var data;

  BaseModel(this.success, this.message,this.data);

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(json['success'], json['message'],
    json['data']);
  }

  @override
  String toString() {
    return 'BaseModel{status: $success, message: $message, data: $data}';
  }
}