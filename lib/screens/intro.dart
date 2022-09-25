import 'package:flutter/material.dart';
import 'package:project_1/screens/GroupScreen.dart';

class IntroductionPage extends StatelessWidget {

  String phoneController;
  bool intro;
  IntroductionPage({this.phoneController, this.intro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("About SwapId", style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  child: Text("Please read the INSTRUCTIONS CAREFULLY", style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.black,
                  ),),
                ),
                SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.brightness_1, size: 12),
                      ),
                      Expanded(
                        child: Text("In SwapId you can create a group of atmost 10 members and "
                            "send a post or comment on a post by any member's Id.", style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.brightness_1, size: 12),
                      ),
                      Expanded(
                        child: Text("Remember this app is totally for fun and entertainment. So, "
                            "do not send any inappropriate message which could hurt anybody in the group. ", style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.brightness_1, size: 12),
                      ),
                      Expanded(
                        child: Text("In case, if any member sent something which is inappropriate for others, "
                            "then other member's can report that message. If all members have reported the message"
                            " except the one who sent it then the member (actual member, not the one whose Id has been used"
                            ") will be removed and he/she will never be able to join the group again. "
                            "This will also reveal his/her identity.", style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.brightness_1, size: 12),
                      ),
                      Expanded(
                        child: Text("All your posts will be deleted after 48 hours from the time it was sent.", style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.brightness_1, size: 12),
                      ),
                      Expanded(
                        child: Text("While registering, we did not verify your email Id (which means "
                            "you can use any email Id), so make sure you remember your login details or "
                            "you will not be able to recover your account.", style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.brightness_1, size: 12),
                      ),
                      Expanded( 
                        child: Text("In case you forgot your login details you can create a new account "
                            "and ask your friends to add you in their respective groups.", style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                intro ? GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => GroupScreen(userId: phoneController)
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Text("Get Started", style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),),
                    color: Colors.indigoAccent[700],
                  ),
                )
                    :
                    Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
