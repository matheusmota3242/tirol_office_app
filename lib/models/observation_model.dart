class Observation {
  String _id;
  String _title;
  String _content;
  String _author;
  DateTime _dateTime;

  Observation();

  Map<String, dynamic> toJson() => {
        'title': _title,
        'content': _content,
        'author': _author,
        'dateTime': _dateTime,
      };

  Observation.fromJson(Map<String, dynamic> json)
      : _title = json['title'],
        _content = json['content'],
        _author = json['author'],
        _dateTime = DateTime.parse(json['dateTime'].toDate().toString());

  get id => this._id;
  set id(String id) => this._id = id;
  get title => this._title;
  set title(String title) => this._title = title;
  get content => this._content;
  set content(content) => this._content = content;
  get author => this._author;
  set author(author) => this._author = author;
  get dateTime => this._dateTime;
  set dateTime(dateTime) => this._dateTime = dateTime;
}
