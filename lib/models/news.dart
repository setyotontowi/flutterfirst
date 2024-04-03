class News {
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  const News({this.id = 0, this.email = "", this.firstName = "", this.lastName = ""});

  factory News.fromJson(Map<String, dynamic> map) {
    return News(
        id: map["id"],
        email: map["email"],
        firstName: map["first_name"],
        lastName: map["last_name"]);
  }
}
