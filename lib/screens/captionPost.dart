import 'package:flutter/material.dart';
import 'package:project_1/Extras/helperFunctions.dart';

class Caption extends StatefulWidget {

  final imageFile;
  Caption({this.imageFile});

  @override
  _CaptionState createState() => _CaptionState();
}

class _CaptionState extends State<Caption> {


  TextEditingController _captionController = TextEditingController();

  getBackWithData() async{
    await HelperFunctions.saveCaptionSharedPreference(_captionController.text);
    print(_captionController.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Add a caption  ..."),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Container(
                    //height: 400,
                    color: Colors.black,
                    child: Image.file(widget.imageFile != null ? widget.imageFile : null, fit: BoxFit.fill),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[200],
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: TextField(
                          controller: _captionController,
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
                    FlatButton(
                      onPressed: (){
                        getBackWithData();
                      },
                      child: Text("Next", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),),
                    )
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
