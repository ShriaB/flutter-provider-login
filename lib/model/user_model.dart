/// [token] Stores the authorization token fetched from the server after user log in

class UserModel {
  String? token;

  UserModel(this.token);

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    return data;
  }
}
