class CardStudent {
  String? name;
  String? id;
  String? imgUrl;
  StudentState state = StudentState.empty;
  int? groupIndex;

  CardStudent(
      {this.name,
      this.id,
      this.state = StudentState.empty,
      this.imgUrl,
      this.groupIndex});

  CardStudent.fromFireBase(dynamic rowData) {
    // TODO : Change data from firebase
    name = rowData['name'].toString();
    id = rowData['lastID'].toString();
    state = {
      "Done": StudentState.registered,
      "problem": StudentState.notRegistered,
      "new": StudentState.newStudent,
      "NULL": StudentState.empty
    }[rowData['state'].toString()]!;

    imgUrl = rowData['imgUrl'].toString();
    if (imgUrl!.contains("drive.google.com")) {
      imgUrl =
          "https://drive.google.com/uc?export=view&id=" + imgUrl!.split('/')[5];
    }
    groupIndex = int.parse(rowData['groupIndex']);
  }

  CardStudent copyWith(
      {String? name,
      String? id,
      StudentState? state,
      String? imgUrl,
      int? groupIndex}) {
    return CardStudent(
      name: name ?? this.name,
      id: id ?? this.id,
      state: state ?? this.state,
      imgUrl: imgUrl ?? this.imgUrl,
      groupIndex: groupIndex ?? this.groupIndex,
    );
  }
}

enum StudentState { registered, notRegistered, newStudent, empty, loading }
//                                                                     "new"
