class TopuplistModel {
  List<DataTransaksi>? dataTransaksi;

  TopuplistModel({this.dataTransaksi});

  TopuplistModel.fromJson(Map<String, dynamic> json) {
    if (json['DataTransaksi'] != null) {
      dataTransaksi = <DataTransaksi>[];
      json['DataTransaksi'].forEach((v) {
        dataTransaksi!.add(new DataTransaksi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataTransaksi != null) {
      data['DataTransaksi'] =
          this.dataTransaksi!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataTransaksi {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? status;
  String? idUser;
  String? nominal;
  String? seconduser;
  String? topupDate;

  DataTransaksi(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.status,
      this.idUser,
      this.nominal,
      this.seconduser,
      this.topupDate});

  DataTransaksi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    status = json['status'];
    idUser = json['id_user'];
    nominal = json['nominal'];
    seconduser = json['seconduser'];
    topupDate = json['topup_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    data['status'] = this.status;
    data['id_user'] = this.idUser;
    data['nominal'] = this.nominal;
    data['seconduser'] = this.seconduser;
    data['topup_date'] = this.topupDate;
    return data;
  }
}
