import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:project_1/Extras/helperFunctions.dart';

class Database {

  // userInfo
  Future<void> addUserInfo({userData, String userId}) async{
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }
  getUserInfo(String phone) async {
    return await FirebaseFirestore.instance
        .collection("users")
        //.where("userEmail", isEqualTo: phone)
    .doc(phone)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }
  checkIfUserExists(String email) async{
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .get();
    if(doc.exists){
      return true;
    }else{
      return false;
    }
  }
  createUserList({userEmail, String email}) async{
    FirebaseFirestore.instance
        .collection("ExistingUsers")
        .doc(email)
        .set(userEmail)
        .catchError((e) {
      print(e.toString());
    });
  }
  alreadyExistingEmail(String email) async{
    var doc = await FirebaseFirestore.instance
        .collection("ExistingUsers")
        .doc(email)
        .get();
    if(doc.exists){
      return true;
    }else{
      return false;
    }
  }
  update({String phone, val}) async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(phone)
        .update({
      "store" : val,
    });
  }


  //notifications
  addNotification(notificationMap) async{
    await FirebaseFirestore.instance
        .collection("notify")
        .add(notificationMap);
  }
  addCommentNotification(notificationMap) async{
    await FirebaseFirestore.instance
        .collection("notifyComments")
        .add(notificationMap);
  }
  updateFcmToken({String email, token}) async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .update({
      "userToken" : token,
    });
  }
  updateFcmTokenInMembers({String groupId, email, token}) async{
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupId)
        .collection("Members")
        .doc(email)
        .update({
      "userToken" : token,
    });
  }



  // posts...
  getPosts ({String groupCreatorId}) async{
    return FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("Posts")
        .orderBy("timeId",descending: true)
        .limit(6)
        .snapshots();
  }
  Future<QuerySnapshot> getAllPosts({int limit, String groupCreatorId, DocumentSnapshot startAfter}) async {
    final ref = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("Posts")
        .orderBy("time",descending: true)
        .limit(limit);

    if (startAfter == null) {
      return ref.get();
    } else {
      return ref.startAfterDocument(startAfter).get();
    }
  }
  loadPosts({String groupCreatorId, int limit}) async{
    return await FirebaseFirestore.instance.collection("Groups")
        .doc(groupCreatorId).collection("Posts").orderBy("timeId",descending: true)
        .limit(limit);
  }
  loadMorePosts({String groupCreatorId, int limit, DocumentSnapshot documentSnapshot}) async{
    return await FirebaseFirestore.instance.collection("Groups")
        .doc(groupCreatorId).collection("Posts").orderBy("timeId",descending: true)
        .startAfterDocument(documentSnapshot)
        .limit(limit);
  }
  addTextPost ({textPostMap, String textPostId, groupCreatorId, userId}) async{
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("Posts")
        .doc(textPostId+userId)
        .set(textPostMap).catchError((e) {
      print(e.toString());
    });
  }


  // Group ...
  addGroupName ({groupNameMap, String groupId}) async{
      await FirebaseFirestore.instance
          .collection("Groups")
          .doc(groupId)
          .set(groupNameMap).catchError((e){
            print(e.toString());
      });
    }
  addGroupNameToUser ({groupNameMap, String userId, String groupId}) async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("UserGroups")
        .doc(groupId)
        .set(groupNameMap).catchError((e){
      print(e.toString());
    });
  }
  addMembersInGroup({groupMemberMap, String id, phone}) async{
     await FirebaseFirestore.instance
        .collection("Groups")
        .doc(id)
        .collection("Members")
        .doc(phone)
        .set(groupMemberMap).catchError((e){
       print(e.toString());
     });
  }
  getMembersFromGroup({String id}) async{
     return await FirebaseFirestore.instance
        .collection("Groups")
        .doc(id)
        .collection("Members")
        .orderBy("time", descending: false)
        .snapshots();
  }
  addUsersInGroupArray({String id, phone}) async{
    DocumentReference docRef = FirebaseFirestore.instance.collection("Groups").doc(id);
    docRef.update({"users": FieldValue.arrayUnion([phone])});
  }
  checkIfReportedUserTriedToAddAgain ({String groupCreatorId, reportedUserId}) async{
    var snapshot = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("ReportedUsers")
        .doc(reportedUserId)
        .get();

    if(snapshot.exists){
      return true;
    }else{
      return false;
    }
  }
  updateLastSender({String groupCreatorId, val}) async{
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .update({
      "lastSender" : val,
    });
  }


  // member length
  memberDocLength(String groupCreatorId) async{
    return await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("Members")
        .get().then((QuerySnapshot querySnapshot) {
      int count = querySnapshot.docs.length ;
      return count;
    });
  }
  addInReportedCollection({reportedUserPhoneMap, String groupCreatorId, removeUserId}) async{
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("ReportedUsers")
        .doc(removeUserId)
        .set(reportedUserPhoneMap);
  }


  // remove from Group array
  removeUsersInGroupArray({String id, phone}) async{
    DocumentReference docRef = FirebaseFirestore.instance.collection("Groups").doc(id);
    docRef.update({"users": FieldValue.arrayRemove([phone])});
  }


  // delete post/comment
  Future<void> batchDelete(String groupId) {
    var currentTime = DateTime.now().millisecondsSinceEpoch;

    WriteBatch batch = FirebaseFirestore.instance.batch();
    return  FirebaseFirestore.instance.collection("Groups").doc(groupId).collection("Posts")
        .where("postId", isLessThan: (currentTime - 20000)).get().then((querySnapshot) {

      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
        print("deleted");
      });

      return batch.commit();
    });
  }
  deletePost({String groupCreatorId, postId, userId}) async{
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("Posts")
        .doc(postId+userId)
        .delete();
  }
  deleteComment({String groupCreatorId, postId, commentId, userId, realUserId}) async{
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("Posts")
        .doc(postId+realUserId)
        .collection("comments")
        .doc(commentId+userId)
        .delete();
  }


  // remove from Member
  removeUserFromMembers({String groupCreatorId, removeUser}) async{
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("Members")
        .doc(removeUser)
        .delete();
  }


  // Remove a user from textPost
  getRealPostSender({String groupCreatorId, postId, realUserId}) async{
    return await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("Posts")
        .doc(postId+realUserId)
        .get()
        .then((value){
         return value.data()["realUser"];
    });
  }
  reporterDocLength({String groupCreatorId, postId}) async{
    return await FirebaseFirestore.instance
        .collection("Reported")
        .doc(groupCreatorId)
        .collection("Posts")
        .doc(postId)
        .collection("reporter")
        .get().then((QuerySnapshot querySnapshot) {
          int count = querySnapshot.docs.length ;
          return count;
    });

  }
  checkIfUserHasAlreadyReportedPost({String groupCreatorId, postId, userId}) async{
    var snapshot = await FirebaseFirestore.instance
        .collection("Reported")
        .doc(groupCreatorId)
        .collection("Posts")
        .doc(postId)
        .collection("reporter")
        .doc(userId)
        .get();

    if(snapshot.exists){
      return true;
    }else{
      return false;
    }
  }
  addNewReporterPost({reporterMap, String groupCreatorId, postId, userId}) async{
    await FirebaseFirestore.instance.collection("Reported")
        .doc(groupCreatorId)
        .collection("Posts")
        .doc(postId)
        .collection("reporter")
        .doc(userId)
        .set(reporterMap).catchError((e){
      print(e.toString());
    });
  }


  // Remove a user from imagePost
  getRealImagePostSender({String groupCreatorId, imagePostId}) async{
    return await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("storage")
        .doc(imagePostId)
        .get()
        .then((value){
      return value.data()["realUser"];
    });
  }
  imageReporterDocLength({String groupCreatorId, imagePostId}) async{
    return await FirebaseFirestore.instance
        .collection("Reported")
        .doc(groupCreatorId)
        .collection("storage")
        .doc(imagePostId)
        .collection("reporter")
        .get().then((QuerySnapshot querySnapshot) {
      int count = querySnapshot.docs.length ;
      return count;
    });

  }
  checkIfUserHasAlreadyReportedImagePost({String groupCreatorId, imagePostId, userId}) async{
    var snapshot = await FirebaseFirestore.instance
        .collection("Reported")
        .doc(groupCreatorId)
        .collection("storage")
        .doc(imagePostId)
        .collection("reporter")
        .doc(userId)
        .get();

    if(snapshot.exists){
      return true;
    }else{
      return false;
    }
  }
  addNewReporterImagePost({reporterMap, String groupCreatorId, imagePostId, userId}) async{
    await FirebaseFirestore.instance.collection("Reported")
        .doc(groupCreatorId)
        .collection("storage")
        .doc(imagePostId)
        .collection("reporter")
        .doc(userId)
        .set(reporterMap).catchError((e){
      print(e.toString());
    });
  }


  // Remove a user from textComment
  getRealCommentSender({String groupCreatorId, postId, commentId}) async{
    return await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("textPosts")
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .get()
        .then((value){
      return value.data()["realUser"];
    });
  }
  commentReporterDocLength({String groupCreatorId, postId, commentId}) async{
    return await FirebaseFirestore.instance
        .collection("Reported")
        .doc(groupCreatorId)
        .collection("textComment")
        .doc(postId+ "+" +commentId)
        .collection("reporter")
        .get().then((QuerySnapshot querySnapshot) {
      int count = querySnapshot.docs.length ;
      return count;
    });

  }
  checkIfUserHasAlreadyReportedComment({String groupCreatorId, postId, commentId, userId}) async{
    var snapshot = await FirebaseFirestore.instance
        .collection("Reported")
        .doc(groupCreatorId)
        .collection("textComment")
        .doc(postId+ "+" +commentId)
        .collection("reporter")
        .doc(userId)
        .get();

    if(snapshot.exists){
      return true;
    }else{
      return false;
    }
  }
  addNewReporterComment({reporterMap, String groupCreatorId, postId, commentId, userId}) async{
    await FirebaseFirestore.instance
        .collection("Reported")
        .doc(groupCreatorId)
        .collection("textComment")
        .doc(postId+ "+" +commentId)
        .collection("reporter")
        .doc(userId)
        .set(reporterMap).catchError((e){
      print(e.toString());
    });
  }


  // Remove a user from imageComment
  getRealImageCommentSender({String groupCreatorId, imagePostId, commentId}) async{
    return await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("storage")
        .doc(imagePostId)
        .collection("comments")
        .doc(commentId)
        .get()
        .then((value){
      return value.data()["realUser"];
    });
  }
  imageCommentReporterDocLength({String groupCreatorId, imagePostId, commentId}) async{
    return await FirebaseFirestore.instance
        .collection("Reported")
        .doc(groupCreatorId)
        .collection("imageComment")
        .doc(imagePostId+ "+" +commentId)
        .collection("reporter")
        .get().then((QuerySnapshot querySnapshot) {
      int count = querySnapshot.docs.length ;
      return count;
    });

  }
  checkIfUserHasAlreadyReportedImageComment({String groupCreatorId, imagePostId, commentId, userId}) async{
    var snapshot = await FirebaseFirestore.instance
        .collection("Reported")
        .doc(groupCreatorId)
        .collection("imageComment")
        .doc(imagePostId+ "+" +commentId)
        .collection("reporter")
        .doc(userId)
        .get();

    if(snapshot.exists){
      return true;
    }else{
      return false;
    }
  }
  addNewReporterImageComment({reporterMap, String groupCreatorId, imagePostId, commentId, userId}) async{
    await FirebaseFirestore.instance
        .collection("Reported")
        .doc(groupCreatorId)
        .collection("imageComment")
        .doc(imagePostId+ "+" +commentId)
        .collection("reporter")
        .doc(userId)
        .set(reporterMap).catchError((e){
      print(e.toString());
    });
  }


  // Group name for users
  getGroupNameForUser (String userId) async{
    return await FirebaseFirestore.instance
        .collection("Groups")
        .where("users", arrayContains: userId)
        .snapshots();
  }
  updateGroupName ({String groupId, val}) async{
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupId)
        .update({
      "Group_Name" : val,
    });
  }
  getGroupName(String groupId) async{
    return await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupId)
        .get();
  }

  // add/get comments
  getComments ({String groupCreatorId, postId, realUserId}) async{
    return await FirebaseFirestore.instance
         .collection("Groups")
         .doc(groupCreatorId)
         .collection("Posts")
         .doc(postId+realUserId)
         .collection("comments")
         .orderBy("time",descending: true)
         .limit(25)
         .snapshots();
  }
  addComment ({commentMap, String groupCreatorId, postId, commentSender,
    commentId, userId, realUserId}) async{
     await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("Posts")
        .doc(postId+realUserId)
        .collection("comments")
        .doc(commentId+userId)
        .set(commentMap).catchError((e) {
      print(e.toString());
    }
      );
  }
  updateTotalComments({String groupCreatorId, postId, realUserId, count, commentSender}) async{

    int c;

    if(count < 15){
      c = count++;
    }
    else{
      c = 15;
    }
    dynamic commentTime = DateFormat.jm().format(DateTime.now());
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("Posts")
        .doc(postId+realUserId)
        .update({
      "comments" : c,
      "lastCommentSender" : commentSender,
      "timeId" : DateTime.now().millisecondsSinceEpoch,
      "commentTime" : commentTime,
    });
  }
  getImagePostComments ({String groupCreatorId, textPostId, realUserId}) async{
    return await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("storage")
        .doc(textPostId+realUserId)
        .collection("comments")
        .orderBy("time",descending: false)
        .limit(6)
        .snapshots();
  }
  addImagePostComment ({commentMap, String groupCreatorId, imagePostId, imageCommentId, userId, realUserId}) async{
   await FirebaseFirestore.instance
        .collection("Groups")
        .doc(groupCreatorId)
        .collection("storage")
        .doc(imagePostId+realUserId)
        .collection("comments")
        .doc(imageCommentId+userId)
        .set(commentMap).catchError((e) {
      print(e.toString());
    }
    );
  }


  // images
  addImage ({String text, groupCreatorId, caption, userId, memberPhone, groupName}) async{
    try {
      final ref = FirebaseStorage.instance.ref().child(text);
      var imageString = await ref.getDownloadURL();
      final String postId = "${DateTime.now().millisecondsSinceEpoch}";
      dynamic time = DateFormat.jm().format(DateTime.now());
      var day = DateFormat('EEEE').format(DateTime.now());

      var nameSent = await HelperFunctions.getMemberNameSharedPreference();

      await FirebaseFirestore.instance
          .collection("Groups")
          .doc(groupCreatorId)
          .collection("Posts")
          .doc(postId+userId)
          .set({
                 "location": text,
                 "textPost": "",
                 "comments":0,
                 "url": imageString ,
                 "timeId": DateTime.now().millisecondsSinceEpoch,
                 "postId": postId,
                 "realUser": userId,
                 "sendByName": memberPhone != null ? memberPhone : "",
                 "nameSent": nameSent != null ? nameSent : "",
                 "time": time,
                 "day": day,
                 "caption": caption,
      });

      Map<String, dynamic> notificationMap = {
        "groupCreatorId": groupCreatorId,
        "groupName": groupName,
        "sender": nameSent,
      };

      await addNotification(notificationMap);

      await updateLastSender(groupCreatorId: groupCreatorId, val: nameSent);

    }catch(e){
      print(e.toString());
    }



  }
  Future<void> uploadImagePost ({File file, String groupCreatorId, caption, userId, memberPhone, groupName}) async{

    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String imageLocation = 'images/$date/image${DateTime.now()}.jpg';

    Reference ref = FirebaseStorage.instance.ref().child(imageLocation);
    UploadTask uploadTask = ref.putFile(file);
    await uploadTask;
    addImage(text :imageLocation,caption: caption, groupName: groupName, groupCreatorId : groupCreatorId, userId: userId, memberPhone: memberPhone);
  }



}