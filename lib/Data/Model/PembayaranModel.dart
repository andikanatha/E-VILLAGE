class PembayaranModel {
  String? massage;
  Transaction? transaction;

  PembayaranModel({this.massage, this.transaction});

  PembayaranModel.fromJson(Map<String, dynamic> json) {
    massage = json['massage'];
    transaction = json['Transaction'] != null
        ? new Transaction.fromJson(json['Transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['massage'] = this.massage;
    if (this.transaction != null) {
      data['Transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}

class Transaction {
  String? trxName;
  String? status;
  String? description;
  String? totalTrx;
  String? trxDate;
  int? idUser;
  String? updatedAt;
  String? createdAt;
  int? id;

  Transaction(
      {this.trxName,
      this.status,
      this.description,
      this.totalTrx,
      this.trxDate,
      this.idUser,
      this.updatedAt,
      this.createdAt,
      this.id});

  Transaction.fromJson(Map<String, dynamic> json) {
    trxName = json['trx_name'];
    status = json['status'];
    description = json['description'];
    totalTrx = json['total_trx'];
    trxDate = json['trx_date'];
    idUser = json['id_user'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trx_name'] = this.trxName;
    data['status'] = this.status;
    data['description'] = this.description;
    data['total_trx'] = this.totalTrx;
    data['trx_date'] = this.trxDate;
    data['id_user'] = this.idUser;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
