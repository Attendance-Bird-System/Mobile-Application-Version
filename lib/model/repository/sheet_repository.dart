// import 'dart:convert';
//
// import 'package:auto_id/bloc/cubit.dart';
// import 'package:http/http.dart' as http;
//
// import '../../shared/widgets/toast_helper.dart';
//
// class SheetRepository {
//   Future<bool> deleteUser(int userIndex, int groupIndex) async {
//     String urlBase =
//         "https://script.google.com/macros/s/AKfycbxx3WO2ZZQ0jSInhHwsl6p3ZvnM4NAVP-ka0ecbqkZJRnOlj8G7qTyvZcZdknsQGvk/exec?";
//     Uri url = Uri.parse(urlBase +
//         "fun=remove&group=$groupIndex&person_id=$userIndex&userName=${AppCubit.appUser.id}");
//     try {
//       http.Response response = await http.get(url);
//       if (response.body.trim() == "Done") {
//         return true;
//       } else {
//         return false;
//       }
//     } catch (err) {
//       return false;
//     }
//   }
//
//   Future<bool> sendEditData(int groupIndex, String id, Map dataToSent) async {
//     String baseUrl =
//         "https://script.google.com/macros/s/AKfycbxx3WO2ZZQ0jSInhHwsl6p3ZvnM4NAVP-ka0ecbqkZJRnOlj8G7qTyvZcZdknsQGvk/exec?";
//     var url = Uri.parse(baseUrl +
//         "fun=edit" +
//         "&group=$groupIndex" +
//         "&user_data=$dataToSent" +
//         "&person_id=$id" +
//         "&userName=${AppCubit.appUser.id}");
//     try {
//       http.Response response = await http.get(url);
//       if (response.body.trim() == "Done") {
//         return true;
//       } else {
//         return false;
//       }
//     } catch (err) {
//       return false;
//     }
//
//     // if (currentUserState == "notfound" && currentUserId == id) {
//     //   currentUserState = "new";
//     //   lastUserName = dataToSent['Name'];
//     //   lastUserGroupIndex = activeGroup;
//     //   currentUserGroupImageUrl = "";
//     //   dataBase.child(appUser.id).update({
//     //     "lastID": "$currentUserId,new",
//     //     "data": "g$groupIndex,$lastUserName,photo"
//     //   });
//     // }
//     // activeGroup = 0;
//   }
//
//   void goToUser(int groupIndex, int userIndex ) {
//     Map<String,dynamic> userData = {};
//     var url = Uri.parse(
//         "https://script.google.com/macros/s/AKfycbzAWq8QxQDISfOGFEougyd4gK29jQr3SWRUbDBgAR4Q6E-rekQbHqkrouqkidbG5SY/exec?" +
//             "userName=${AppCubit.appUser.id}" +
//             "&group=$groupIndex" +
//             "&index=${userIndex + 1}");
//     http.read(url).catchError((err) {
//     }).then((value) {
//       if (!value.startsWith('<!DOCTYPE')) {
//         value = '{"$value"}';
//         value = value.replaceAll(',', '","');
//         value = value.replaceAll('https":"', "https:");
//         value = value.replaceAll('http":"', "http:");
//         userData = json.decode(value);
//       }
//       String userImageUrl = "";
//       for (var v in userData.values) {
//         if (v.contains('drive.google.com')) {
//           print(v);
//           if (v.contains('id')) {
//             userImageUrl = v.toString();
//           } else {
//             try {
//               userImageUrl = "https://drive.google.com/uc?export=view&id=" +
//                   v.split('/')[5];
//             } catch (err) {
//               print(err);
//             }
//           }
//         }
//       }
//     });
//   }
//
//   void goToEditUser(int index) {
//     editUserController = [];
//     if (index != activeGroup) {
//       activeGroup = index;
//       activeGroupNames = [];
//       var url = Uri.parse(
//           "https://script.google.com/macros/s/AKfycbwCgPd0uvbcYCrn3D5v-4GsH_E9OhMUakXe2D3tY0phqN3nxivfWn3efJ4TE6ckqgXa/exec?" +
//               "userName=${AppCubit.appUser.id}" +
//               "&group=$index");
//       http.read(url).then((value) {
//         if (!value.startsWith('<!DOCTYPE')) {
//           var list = value.split("!");
//           activeGroupNames = list[0].split(',');
//           activeGroupColumns = list[1].split(',');
//         }
//       });
//
//   }
//
//   void getUserData(int groupIndex, int userIndex) {
//     Map<String,dynamic>userData = {};
//     var url = Uri.parse(
//         "https://script.google.com/macros/s/AKfycbzAWq8QxQDISfOGFEougyd4gK29jQr3SWRUbDBgAR4Q6E-rekQbHqkrouqkidbG5SY/exec?" +
//             "userName=${AppCubit.appUser.id}" +
//             "&group=$groupIndex" +
//             "&index=${userIndex + 1}");
//     http.read(url).catchError((err) {
//       print(err);
//     }).then((value) {
//       if (!value.startsWith('<!DOCTYPE')) {
//         value = '{"$value"}';
//         value = value.replaceAll(',', '","');
//         value = value.replaceAll('https":"', "https:");
//         value = value.replaceAll('http":"', "http:");
//         userData = json.decode(value);
//       }
//       emit(GetGroupPersonDone());
//     });
//   }
//
//   void getGroupNamesData(int index) {
//     if (index != activeGroup) {
//       activeGroup = index;
//       activeGroupNames = [];
//       var url = Uri.parse(
//           "https://script.google.com/macros/s/AKfycbwCgPd0uvbcYCrn3D5v-4GsH_E9OhMUakXe2D3tY0phqN3nxivfWn3efJ4TE6ckqgXa/exec?" +
//               "userName=${AppCubit.appUser.id}" +
//               "&group=$index");
//       http.read(url).catchError((err) {
//         print(err);
//       }).then((value) {
//         if (!value.startsWith('<!DOCTYPE')) {
//           var list = value.split("!");
//           activeGroupNames = list[0].split(',');
//           activeGroupColumns = list[1].split(',');
//         }
//       });
//     }
//   }
//
//   void addColumnNames(String id, String groupName) {
//     // run the script to make a column with the id
//     var url = Uri.parse(
//         "https://script.google.com/macros/s/AKfycbyDVddZV5IbMoj93yxZKY7tPdcyxG7pqjq5wkNTOxPHAKUsLZdvZoWZsjfmCJbhhO6NHA/exec?id=" +
//             id +
//             "&list=$renameRowsName");
//     http.read(url).catchError((err) {
//       print(err);
//     }).then((value) {
//       if (value.trim() == '1') {
//         createGroup(id, groupName, context);
//       }
//     });
//   }
//
//   Future<String> createSpreadSheet(String groupName) {
//     var url = Uri.parse(
//         "https://script.google.com/macros/s/AKfycbz3o9eqSWAGqFUf1C2Vk1waU6DgaqyVUjPtSyz9rw8ZQ-o_8U_aAwnnCaunX1Heo3Vn/exec?name=" +
//             AppCubit.appUser.id +
//             " " +
//             groupName);
//     return http.read(url);
//   }
//
//   void testLink( String groupName, String link) {
//
//     String id = link.split('/')[5];
//     var url = Uri.parse(
//         "https://script.google.com/macros/s/AKfycbzi7OBUEk5ZaBWeOjelTJMVMaJnK4zTU78UwB59qJW0GvJBnZ_daHmY_VPusN3xCZb0jw/exec?id=" +
//             id);
//     http.read(url).catchError((err) {
//       print(err);
//       showToast("Error happened while reading the data please try again");
//     }).then((value) {
//       if (value.trim() == '-1') {
//         showToast(
//           "Invalid sheet please make sure that the url is public and editor",
//         );
//       } else {
//         createGroup(id, groupName, context);
//       }
//     });
//   }
//
//   void useSheetRowAsNameCheckBox(String link) {
//     renameRowsName = [];
//     currentColumnToFill = 65;
//     if (useSheetRowAsName) {
//       useSheetRowAsName = !useSheetRowAsName;
//       String id = link.split('/')[5];
//       var url = Uri.parse(
//           "https://script.google.com/macros/s/AKfycbzi7OBUEk5ZaBWeOjelTJMVMaJnK4zTU78UwB59qJW0GvJBnZ_daHmY_VPusN3xCZb0jw/exec?id=" +
//               id);
//       http.read(url).catchError((err) {
//         print(err);
//         useSheetRowAsName = !useSheetRowAsName;
//         showToast("Error happened while reading the data please try again");
//       }).then((value) {
//         if (value.trim() == '-1') {
//           useSheetRowAsName = !useSheetRowAsName;
//           showToast(
//               "Invalid sheet please make sure that the url is public and editor");
//         } else {
//           createTable(value);
//         }
//       });
//     } else {
//       useSheetRowAsName = !useSheetRowAsName;
//     }
//   }
// }
