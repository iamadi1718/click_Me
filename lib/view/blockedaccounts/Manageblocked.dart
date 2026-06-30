import 'package:click_me/Models/Blocked_users_model/Blocked_users_model.dart';
import 'package:click_me/services/BlockedusersServices/BlockedUsersServices.dart';

import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:flutter/material.dart';

class Manageblocked extends StatefulWidget {
  const Manageblocked({super.key});

  @override
  State<Manageblocked> createState() => _ManageblockedState();
}

class _ManageblockedState extends State<Manageblocked> {

  final BlockedUsersServices _services = BlockedUsersServices();

 Future<BlockedUsersModel>? blockedUsersFuture;

  @override
  void initState() {
    super.initState();
    blockedUsersFuture = _services.getBlockData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Blocklist"),
      ),
      body: FutureBuilder<BlockedUsersModel>(
        future: blockedUsersFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.data?.blockedUsers == null ||
              snapshot.data!.data!.blockedUsers!.isEmpty) {
            return const Center(
              child: Text("No Blocked Users"),
            );
          }

          final blockedUsers = snapshot.data!.data!.blockedUsers!;

          return Column(
            children: [

              Expanded(
                child: ListView.builder(
                  itemCount: blockedUsers.length,
                  itemBuilder: (context, index) {

                    final user = blockedUsers[index];

                    return ListTile(

                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: user.profileImage != null
                            ? NetworkImage(user.profileImage!)
                            : const AssetImage("assets/images/img1.png")
                                as ImageProvider,
                      ),

                      title: Text(
                        user.fullName ?? "",
                      ),

                      subtitle: Text(
                        user.bio ?? "No Bio",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      trailing: ElevatedButton(
                        onPressed: () {

                          // Call unblock API here

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(114, 111, 220, 1),
                        ),
                        child: const Text(
                          "Unblock",
                          style: TextStyle(
                            color: Colors.white,
                          ),
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
                    text: "Done",
                    onTap: () {
                      Navigator.pop(context);
                    },
                    buttoncolor: const Color.fromRGBO(85, 13, 155, 1),
                    bordercolor: const Color.fromRGBO(85, 13, 155, 1),
                    textcolor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }
}