class CommentRembugModel {
  List<Comments>? comments;

  CommentRembugModel({this.comments});

  CommentRembugModel.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? comment;
  String? idUser;
  String? idPost;
  String? commentdate;
  Users? users;

  Comments(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.comment,
      this.idUser,
      this.idPost,
      this.commentdate,
      this.users});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    comment = json['comment'];
    idUser = json['id_user'];
    idPost = json['id_post'];
    commentdate = json['commentdate'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['comment'] = this.comment;
    data['id_user'] = this.idUser;
    data['id_post'] = this.idPost;
    data['commentdate'] = this.commentdate;
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

class Modelpostcomment {
  int? id;
  String? comment;
  String? commentdate;
  int? id_post;
  int? id_user;

  Modelpostcomment(
      {this.id, this.comment, this.commentdate, this.id_user, this.id_post});

  factory Modelpostcomment.fromJson(Map<String, dynamic> json) {
    return Modelpostcomment(
      id: json['comments']['id'],
      comment: json['comments']['description'],
      id_user: json['comments']['nominal'],
      id_post: json['comments']['seconduser'],
    );
  }
}
