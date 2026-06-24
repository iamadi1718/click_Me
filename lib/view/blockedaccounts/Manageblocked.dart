import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:flutter/material.dart';

class Manageblocked extends StatefulWidget {
  const Manageblocked({super.key});

  @override
  State<Manageblocked> createState() => _ManageblockedState();
}

class _ManageblockedState extends State<Manageblocked> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Blocklist')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/img1.png'),
                  ),
                  title: Text('Full Name'),
                  subtitle: Text(
                    'username',
                    style: TextStyle(color: Colors.red),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(114, 111, 220, 1),
                    ),
                    child: Text(
                      'Unblock',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
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
    );
  }
}
