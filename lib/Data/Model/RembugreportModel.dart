class RembugReport {
  List<Laporan>? laporan;

  RembugReport({this.laporan});

  RembugReport.fromJson(Map<String, dynamic> json) {
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
  String? description;
  String? reportDate;
  String? idUser;
  String? idUserPosts;
  String? idPost;
  Posts? posts;
  Usersreport? usersreport;
  Usersposts? usersposts;

  Laporan(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.reportDate,
      this.idUser,
      this.idUserPosts,
      this.idPost,
      this.posts,
      this.usersreport,
      this.usersposts});

  Laporan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    reportDate = json['report_date'];
    idUser = json['id_user'];
    idUserPosts = json['id_user_posts'];
    idPost = json['id_post'];
    posts = json['posts'] != null ? new Posts.fromJson(json['posts']) : null;
    usersreport = json['usersreport'] != null
        ? new Usersreport.fromJson(json['usersreport'])
        : null;
    usersposts = json['usersposts'] != null
        ? new Usersposts.fromJson(json['usersposts'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    data['report_date'] = this.reportDate;
    data['id_user'] = this.idUser;
    data['id_user_posts'] = this.idUserPosts;
    data['id_post'] = this.idPost;
    if (this.posts != null) {
      data['posts'] = this.posts!.toJson();
    }
    if (this.usersreport != null) {
      data['usersreport'] = this.usersreport!.toJson();
    }
    if (this.usersposts != null) {
      data['usersposts'] = this.usersposts!.toJson();
    }
    return data;
  }
}

class Posts {
  String? image;
  int? id;
  String? createdDate;
  String? deskripsi;

  Posts({this.image, this.id, this.createdDate, this.deskripsi});

  Posts.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    createdDate = json['created_date'];
    deskripsi = json['deskripsi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['created_date'] = this.createdDate;
    data['deskripsi'] = this.deskripsi;
    return data;
  }
}

class Usersreport {
  int? id;
  String? name;
  String? imageUser;
  String? username;

  Usersreport({this.id, this.name, this.imageUser, this.username});

  Usersreport.fromJson(Map<String, dynamic> json) {
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

class Usersposts {
  int? id;
  String? name;
  String? imageUser;
  String? username;

  Usersposts({this.id, this.name, this.imageUser, this.username});

  Usersposts.fromJson(Map<String, dynamic> json) {
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
