import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1/Extras/Classes.dart';
import 'package:project_1/firebase/database.dart';

class LoadPosts extends StatefulWidget {

  String groupCreatorId, userId, postScreenId;
  Stream userStream;
  LoadPosts({this.groupCreatorId, this.userId, this.postScreenId, this.userStream});

  @override
  _LoadPostsState createState() => _LoadPostsState();
}

class _LoadPostsState extends State<LoadPosts> {

  int limit = 5;
  Query query;
  List<DocumentSnapshot> _posts = [];
  bool _loadingPosts = true;
  bool _gettingMorePosts = false;
  bool _morePostsAvailable = true;
  var currentTime = DateTime.now().millisecondsSinceEpoch;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();

  Database database = Database();

  getPosts() async{
    await database.loadPosts(groupCreatorId: widget.groupCreatorId, limit: limit).then((value){
      query = value;
    });

    setState(() {
      _loadingPosts = true;
    });
    QuerySnapshot querySnapshot = await query.get();
    _posts = querySnapshot.docs;
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

    setState(() {
      _loadingPosts = false;
    });

  }

  getMorePosts() async {

    _gettingMorePosts = true;

    await database.loadMorePosts(groupCreatorId: widget.groupCreatorId,
        limit: limit, documentSnapshot: _lastDocument)
        .then((value) {
        query = value;
    });

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.length < limit) {
      _morePostsAvailable = false;
    }

    _lastDocument = await querySnapshot.docs[querySnapshot.docs.length - 1];
    await _posts.addAll(querySnapshot.docs);

    setState(() {});

    _gettingMorePosts = false;
  }

  @override
  void initState() {
    super.initState();
    getPosts();

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double diff = MediaQuery.of(context).size.height * 0;

      if(maxScroll - currentScroll == diff){
        getMorePosts();
      }
    });
  }

  Widget _postList(){
    return _loadingPosts == true ? Container() : Container(
      child: _posts.length == 0 ? Center(
        child: Text("No posts yet !"),
      ) : ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length,
        itemBuilder: (BuildContext context, int index){
          return currentTime-_posts[index].data()["timeId"] < 172800000 ?
          Post(
            count: _posts[index].data()["comments"],
            text: _posts[index].data()["textPost"],
            time: _posts[index].data()["time"],
            day: _posts[index].data()["day"],
            caption: _posts[index].data()["caption"],
            commentTime: _posts[index].data()["commentTime"],
            commentSender: _posts[index].data()["lastCommentSender"],
            image: _posts[index].data()["url"],
            groupCreatorId: widget.groupCreatorId,
            userId: widget.userId,
            userStream: widget.userStream,
            realUserId: _posts[index].data()["realUser"],
            postId: _posts[index].data()["postId"],
            postScreenId: widget.postScreenId,
            memberName: _posts[index].data()["nameSent"],
            memberPhone: _posts[index].data()["sendByName"],
          ) : Container();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
        leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20)),
      ),
      body: _postList(),
    );
  }
}
