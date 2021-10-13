class DepartmentDTO {
  String _id;
  String _name;
  String _unitName;

  DepartmentDTO(String id, String name, String unitName) {
    _id = id;
    _name = name;
    _unitName = unitName;
  }

  get id => this._id;
  set id(String value) => this._id = value;

  get name => this._name;
  set name(value) => this._name = value;

  String get unitName => this._unitName;
  set unitName(String value) => this._unitName = value;
}
