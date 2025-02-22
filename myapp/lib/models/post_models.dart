class Post {
  int? id;
  String title;
  String body;

  Post({this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'body': body};
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(id: map['id'], title: map['title'], body: map['body']);
  }
}
