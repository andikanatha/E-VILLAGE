class PembayaranModelGet {
  List<DataTransaksi>? dataTransaksi;

  PembayaranModelGet({this.dataTransaksi});

  PembayaranModelGet.fromJson(Map<String, dynamic> json) {
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
  String? idUser;
  String? trxName;
  String? seconduser;
  String? trxDate;
  String? datefor;
  String? status;
  String? totalTrx;
  String? description;
  String? createdAt;
  String? updatedAt;

  DataTransaksi(
      {this.id,
      this.idUser,
      this.trxName,
      this.seconduser,
      this.trxDate,
      this.datefor,
      this.status,
      this.totalTrx,
      this.description,
      this.createdAt,
      this.updatedAt});

  DataTransaksi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    trxName = json['trx_name'];
    seconduser = json['seconduser'];
    trxDate = json['trx_date'];
    datefor = json['datefor'];
    status = json['status'];
    totalTrx = json['total_trx'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
