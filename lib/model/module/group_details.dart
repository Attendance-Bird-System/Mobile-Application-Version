class GroupDetails {
  String name;
  String id;
  List<String>? studentNames;
  List<String>? columnNames;

  GroupDetails(
      {required this.name,
      required this.id,
      this.studentNames,
      this.columnNames});
}
