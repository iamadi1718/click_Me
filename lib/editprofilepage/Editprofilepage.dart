import 'package:click_me/bottomnavigationbar/profilepage/Profilepage.dart';
import 'package:click_me/custombackground/Custombackground.dart';
import 'package:click_me/custombutton/Custombutton.dart';
import 'package:click_me/customtextfield/CustomTextfield.dart';
import 'package:click_me/interestspage/Interestspage.dart';
import 'package:click_me/settingspage/Settingspage.dart';
import 'package:flutter/material.dart';

class Editprofilepages extends StatefulWidget {
  const Editprofilepages({super.key});

  @override
  State<Editprofilepages> createState() => _EditprofilepagesState();
}

class _EditprofilepagesState extends State<Editprofilepages> {
  String? selectedGender;
  final namecontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final birthcontroller = TextEditingController();
  final biocontroller = TextEditingController();
  final linkcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: height * 0.05),

              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/img1.png'),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey[800],
                        child: Icon(Icons.edit, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.05),
              Customtextfield(
                first: 'Name',
                second: 'xxxxx',
                controller: namecontroller,
              ),
              Customtextfield(
                first: 'Username',
                second: 'xxxxx',
                controller: usernamecontroller,
                icon: Icon(Icons.edit),
              ),
              Customtextfield(
                first: 'Bio',
                second: 'xxxxx',
                controller: biocontroller,
                icon: Icon(Icons.edit),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedGender,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: const Text(' Gender'),
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(
                            value: 'Female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                    ),

                    Expanded(
                      child: Customtextfield(
                        first: 'Date of birth',
                        second: 'xx/xx/xxxx',
                        controller: birthcontroller,
                      ),
                    ),
                  ],
                ),
              ),
              Customtextfield(
                first: 'Add a link',
                second: 'xxxxx',
                controller: linkcontroller,
                icon: Icon(Icons.edit),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Color.fromRGBO(114, 111, 220, 1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'More Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(114, 111, 220, 1),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 120,
                  child: Custombutton(
                    text: 'Done',
                    onTap: () {},
                    buttoncolor: const Color.fromRGBO(85, 13, 155, 1),
                    bordercolor: const Color.fromRGBO(85, 13, 155, 1),
                    textcolor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
