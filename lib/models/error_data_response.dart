class ErrorDataResponse {
  String errorCodeType;

  ErrorDataResponse({this.errorCodeType});

  factory ErrorDataResponse.fromJson(Map<String, dynamic> json) {
    return ErrorDataResponse(errorCodeType: json['errorCodeType']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCodeType'] = this.errorCodeType;
    return data;
  }
}
