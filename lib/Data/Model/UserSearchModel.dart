class UserSearchModel {
  List<Users>? users;

  UserSearchModel({this.users});

  UserSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? email;
  String? imageUser;
  String? username;
  String? name;
  String? pin;
  Null? emailVerifiedAt;
  String? akses;
  String? saldo;
  String? createdAt;
  String? updatedAt;

  Users(
      {this.id,
      this.email,
      this.imageUser,
      this.username,
      this.name,
      this.pin,
      this.emailVerifiedAt,
      this.akses,
      this.saldo,
      this.createdAt,
      this.updatedAt});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    imageUser = json['image_user'];
    username = json['username'];
    name = json['name'];
    pin = json['pin'];
    emailVerifiedAt = json['email_verified_at'];
    akses = json['akses'];
    saldo = json['saldo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['image_user'] = this.imageUser;
    data['username'] = this.username;
    data['name'] = this.name;
    data['pin'] = this.pin;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['akses'] = this.akses;
    data['saldo'] = this.saldo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
