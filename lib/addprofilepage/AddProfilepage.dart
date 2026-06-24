import 'package:click_me/custombackground/Custombackground.dart';
import 'package:click_me/custombutton/Custombutton.dart';
import 'package:click_me/customtextfield/CustomTextfield.dart';
import 'package:click_me/interestspage/Interestspage.dart';
import 'package:flutter/material.dart';

class AddProfilepage extends StatefulWidget {
  const AddProfilepage({super.key});

  @override
  State<AddProfilepage> createState() => _AddProfilepageState();
}

class _AddProfilepageState extends State<AddProfilepage> {
  String? selectedGender;
  final namecontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final birthcontroller = TextEditingController();
  final typecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Custombackground(
        widget: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.1),
              Text(
                'Set Up your profile',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(85, 13, 155, 1),
                ),
              ),
              SizedBox(height: height * 0.05),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[600],
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.account_circle, size: 100, color: Colors.grey),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey[800],
                        child: Icon(Icons.add, size: 18, color: Colors.white),
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
              Customtextfield(second: 'Type', controller: typecontroller),
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
              Custombutton(
                text: 'Next',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Interestspage()),
                  );
                },
                buttoncolor: Color.fromRGBO(85, 13, 155, 1),
                bordercolor: Color.fromRGBO(85, 13, 155, 1),
                textcolor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
