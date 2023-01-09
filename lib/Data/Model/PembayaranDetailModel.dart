class DetailTrx {
  int? id;
  String? idUser;
  String? trxName;
  String? seconduser;
  String? trxDate;
  String? datefor;
  String? status;
  String? totalTrx;
  String? description;
  String? jenis;
  String? createdAt;
  String? updatedAt;
  Users? users;

  DetailTrx(
      {this.id,
      this.idUser,
      this.trxName,
      this.seconduser,
      this.trxDate,
      this.datefor,
      this.status,
      this.totalTrx,
      this.description,
      this.jenis,
      this.createdAt,
      this.updatedAt,
      this.users});

  DetailTrx.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    trxName = json['trx_name'];
    seconduser = json['seconduser'];
    trxDate = json['trx_date'];
    datefor = json['datefor'];
    status = json['status'];
    totalTrx = json['total_trx'];
    description = json['description'];
    jenis = json['jenis'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.idUser;
    data['trx_name'] = this.trxName;
    data['seconduser'] = this.seconduser;
    data['trx_date'] = this.trxDate;
    data['datefor'] = this.datefor;
    data['status'] = this.status;
    data['total_trx'] = this.totalTrx;
    data['description'] = this.description;
    data['jenis'] = this.jenis;
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
