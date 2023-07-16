import 'package:mavencliq/Models/Auth/generic_response.dart';

class CommonVerifyEmailResponseSuccess extends MavenAPIResponse {
  String? data;
  CommonVerifyEmailResponseSuccess({
    required this.data,
    required String message,
    required int statusCode,
  }) : super(statusCode: statusCode, message: message);
  CommonVerifyEmailResponseSuccess.fromJson(
      Map<String, dynamic> json, int statusCode)
      : data = json['data'],
        super(statusCode: statusCode, message: json['message']);
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['message'] = message;
    return data;
  }
}

class CommonVerifyEmailResponseFailed extends MavenAPIResponse {
  String? error;
  int? status;
  CommonVerifyEmailResponseFailed({
    this.status,
    this.error,
    required String message,
  }) : super(statusCode: 401, message: message);

  CommonVerifyEmailResponseFailed.fromJson(Map<String, dynamic> json)
      : super(statusCode: 401, message: json['message']) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['error'] = error;
    data['message'] = message;
    return data;
  }
}
