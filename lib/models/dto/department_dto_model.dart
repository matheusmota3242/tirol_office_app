class DepartmentDTO {
  String _id;
  String _name;

  DepartmentDTO(String id, String name) {
    _id = id;
    _name = name;
  }

  get id => this._id;
  set id(String value) => this._id = value;

  get name => this._name;
  set name(value) => this._name = value;
}
