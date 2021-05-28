class Observation {
  String id;
  String content;
  String author;
  DateTime dateTime;

  String get getId => this.id;
  set setId(String id) => this.id = id;

  get getContent => this.content;
  set setContent(content) => this.content = content;

  get getAuthor => this.author;
  set setAuthor(author) => this.author = author;

  get getDateTime => this.dateTime;
  set setDateTime(dateTime) => this.dateTime = dateTime;
}
