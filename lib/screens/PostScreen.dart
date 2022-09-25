import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_1/Extras/Classes.dart';
import 'package:project_1/Extras/helperFunctions.dart';
import 'package:project_1/firebase/database.dart';
import 'package:project_1/screens/captionPost.dart';
import 'package:project_1/screens/loadMore.dart';

class PostScreen extends StatefulWidget {
  final String postScreenId, groupCreatorId, userId, groupName;
  final Stream userStream, postStream;

  PostScreen({this.postScreenId, this.userStream, this.postStream,
    this.groupCreatorId, this.userId, this.groupName});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  bool backPressed = false;
  bool pressed = false;
  File _imageFile;
  PickedFile pickedFile;
  bool i = true;

  final keyOne = GlobalKey();

  String displayPhone, caption;
  Stream imageStream;
  var currentTime = DateTime.now().millisecondsSinceEpoch;

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ImagePicker _picker = ImagePicker();

  TextEditingController _typeController = TextEditingController();
  Database database = Database();
  UserTile userTile = UserTile();

  delete(){

    return Container();
  }

  Widget _postList() {
    return StreamBuilder(
      stream: widget.postStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return currentTime-snapshot.data.documents[index].data()["timeId"] < 172800000 ?
                   Post(
                  count: snapshot.data.documents[index].data()["comments"],
                  commentTime: snapshot.data.documents[index].data()["commentTime"],
                  text: snapshot.data.documents[index].data()["textPost"],
                  caption: snapshot.data.documents[index].data()["caption"],
                  image: snapshot.data.documents[index].data()["url"],
                  commentSender: snapshot.data.documents[index].data()["lastCommentSender"],
                  userStream: widget.userStream,
                  postScreenId: widget.postScreenId,
                  postId: snapshot.data.documents[index].data()["postId"],
                  groupCreatorId: widget.groupCreatorId,
                  memberPhone: snapshot.data.documents[index].data()["sendByName"],
                  memberName: snapshot.data.documents[index].data()["nameSent"],
                  userId: widget.userId,
                  groupName: widget.groupName,
                  time: snapshot.data.documents[index].data()["time"],
                  day: snapshot.data.documents[index].data()["day"],
                  realUserId: snapshot.data.documents[index].data()["realUser"],
                  )
                      :
                      Container();
                })
            : Container();
      },
    );
  }

  Widget _userList() {
    return StreamBuilder(
      stream: widget.userStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return UserTile(
                    userName:snapshot.data.documents[index].data()["userName"],
                    userPhone: snapshot.data.documents[index].data()["userEmail"],
                  );
                })
            : Container();
      },
    );
  }

  _sendTextPost() async{
    if(formKey.currentState.validate()){

      String textPostId = "${DateTime.now().millisecondsSinceEpoch}";
      dynamic time = DateFormat.jm().format(DateTime.now());
      var day = DateFormat('EEEE').format(DateTime.now());

      displayPhone = await HelperFunctions.getMemberPhoneSharedPreference();
      var memberName = await HelperFunctions.getMemberNameSharedPreference();

      if (_typeController != null) {
        Map<String, dynamic> textPostMap = {
          "textPost": _typeController.text,
          "url": "",
          "timeId": DateTime.now().millisecondsSinceEpoch,
          "postId": textPostId,
          "realUser": widget.userId,
          "sendByName": displayPhone,
          "nameSent": memberName,
          "comments": 0,
          "time": time,
          "day": day,
        };

        Map<String, dynamic> notificationMap = {
          "groupCreatorId": widget.groupCreatorId,
          "groupName": widget.groupName,
          "sender": memberName,
        };

        await database.addTextPost(
          groupCreatorId: widget.groupCreatorId,
          textPostMap: textPostMap,
          textPostId: textPostId,
          userId: widget.userId,
        );

        await database.addNotification(notificationMap);

        await database.updateLastSender(groupCreatorId: widget.groupCreatorId, val: memberName);

        _typeController.text = "";
        textPostId = "";
      }


    }
  }

  _upload(BuildContext context) async {

    displayPhone = await HelperFunctions.getMemberPhoneSharedPreference();
    caption = await HelperFunctions.getCaptionSharedPreference();


    await database.uploadImagePost(
      groupName: widget.groupName,
      groupCreatorId: widget.groupCreatorId,
      file: _imageFile,
      userId: widget.userId,
      memberPhone: displayPhone,
      caption: caption,
    );

    _imageFile = null;
  }

  allPost() async{

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => LoadPosts(
          userId: widget.userId,
          userStream: widget.userStream,
          postScreenId: widget.postScreenId,
          groupCreatorId: widget.groupCreatorId,
        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigoAccent[700],
        title: Text(
          "Posts",
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20)),
        actions: [
          IconButton(
            onPressed: (){
              allPost();
            },
            icon: Icon(Icons.dashboard, color: Colors.white),
          )
        ],
      ),
      body: Container(
          color: Colors.grey[300],
          child: _postList(),
        ),//_buildBody(context),
      floatingActionButton: Builder(
        builder: (snackContext) => FloatingActionButton(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Icon(Icons.question_answer, color: Colors.indigoAccent[400]),
          onPressed: () {
            _box();
          },
        ),
      )
    );
  }

  _box() {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: "Label",
        transitionDuration: Duration(milliseconds: 10),
        context: context,
        pageBuilder: (context, a1, a2) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                child: Material(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.indigoAccent[700],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    height: 95,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            height: 55,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 11,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 3),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          i = true;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(40),
                                          //border: Border.all(color: Colors.grey[900], width: 2),
                                          color: Colors.white,
                                        ),
                                        child: Form(
                                          key: formKey,
                                          child: Center(
                                            child: TextFormField(
                                              controller: _typeController,
                                              validator: (val) {
                                                return val.isEmpty
                                                    ? "message field can't be empty"
                                                    : null;
                                              },
                                              keyboardType: TextInputType.multiline,
                                              maxLines: null,
                                              expands: true,
                                              cursorColor: Colors.grey[900],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Type ...",
                                                isDense: true,
                                                hintStyle: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 55,
                                    padding: EdgeInsets.only(left: 3, top: 5, bottom: 3),
                                    child: GestureDetector(
                                      onTap: () {
                                        gallery();
                                        setState(() {
                                          i = false;
                                        });
                                      },
                                      child: Icon(Icons.photo,
                                            size: 33, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 55,
                                    padding: EdgeInsets.only(right: 3, left: 3, top: 5, bottom: 3),
                                    child: GestureDetector(
                                      onTap: () {
                                        camera();
                                        setState(() {
                                          i = false;
                                        });
                                      },
                                      child: Icon(Icons.camera_alt,
                                            size: 33, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      i ? _sendTextPost() : _upload(context);
                                      i = true;
                                    },
                                    child: Container(
                                      height: 50,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 7),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white,
                                          ),
                                          child: Icon(Icons.send, color: Colors.indigoAccent, size: 25)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 3, bottom: 5),
                            height: 40,
                            child: _userList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom)),
          );
        },
        transitionBuilder: (context, a1, a2, child) {
          return SlideTransition(
            position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(a1),
            child: child,
          );
        });
  }

  Future gallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        this._imageFile = File(pickedFile.path);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Caption(imageFile: _imageFile)
        ));
      }
    });

  }

  Future camera() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        this._imageFile = File(pickedFile.path);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Caption(imageFile: _imageFile)
        ));
      }
    });
  }

}



