class ModelLapor {
  List<DataTransaksi>? dataTransaksi;

  ModelLapor({this.dataTransaksi});

  ModelLapor.fromJson(Map<String, dynamic> json) {
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
  String? createdAt;
  String? updatedAt;
  Null? image;
  String? deskripsi;
  String? tempatKejadian;
  String? createdDate;

  DataTransaksi(
      {this.id,
      this.idUser,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.deskripsi,
      this.tempatKejadian,
      this.createdDate});

  DataTransaksi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    deskripsi = json['deskripsi'];
    tempatKejadian = json['tempat_kejadian'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.idUser;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['deskripsi'] = this.deskripsi;
    data['tempat_kejadian'] = this.tempatKejadian;
    data['created_date'] = this.createdDate;
    return data;
  }
}
