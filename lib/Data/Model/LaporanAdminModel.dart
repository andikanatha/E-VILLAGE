class LaporanAdminModel {
  List<Laporan>? laporan;

  LaporanAdminModel({this.laporan});

  LaporanAdminModel.fromJson(Map<String, dynamic> json) {
    if (json['Laporan'] != null) {
      laporan = <Laporan>[];
      json['Laporan'].forEach((v) {
        laporan!.add(new Laporan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.laporan != null) {
      data['Laporan'] = this.laporan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Laporan {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? nominal;
  String? date;
  String? idUser;
  String? description;
  String? keperluan;
  Users? users;

  Laporan(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.nominal,
      this.date,
      this.idUser,
      this.description,
      this.keperluan,
      this.users});

  Laporan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    nominal = json['nominal'];
    date = json['date'];
    idUser = json['id_user'];
    description = json['description'];
    keperluan = json['keperluan'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['nominal'] = this.nominal;
    data['date'] = this.date;
    data['id_user'] = this.idUser;
    data['description'] = this.description;
    data['keperluan'] = this.keperluan;
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
  String? username;

  Users({this.id, this.name, this.imageUser, this.username});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUser = json['image_user'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_user'] = this.imageUser;
    data['username'] = this.username;
    return data;
  }
}
