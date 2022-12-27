class RembugData {
  List<Rembug>? rembug;

  RembugData({this.rembug});

  RembugData.fromJson(Map<String, dynamic> json) {
    if (json['rembug'] != null) {
      rembug = <Rembug>[];
      json['rembug'].forEach((v) {
        rembug!.add(new Rembug.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rembug != null) {
      data['rembug'] = this.rembug!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rembug {
  int? id;
  String? idUser;
  String? deskripsi;
  String? image;
  String? createdAt;
  String? updatedAt;
  Users? users;

  Rembug(
      {this.id,
      this.idUser,
      this.deskripsi,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.users});

  Rembug.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    deskripsi = json['deskripsi'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.idUser;
    data['deskripsi'] = this.deskripsi;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    return data;
  }
}

class Users {
  int? id;
  String? name;
  String? imageUser;

  Users({this.id, this.name, this.imageUser});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUser = json['image_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_user'] = this.imageUser;
    return data;
  }
}
