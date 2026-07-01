import 'package:click_me/controller/blockedUserController/BlockedUsersController.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Manageblocked extends StatefulWidget {
  const Manageblocked({super.key});

  @override
  State<Manageblocked> createState() => _ManageblockedState();
}

class _ManageblockedState extends State<Manageblocked> {

  final BlockedUsersController controller =
      Get.put(BlockedUsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Blocklist"),
      ),

      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(controller.errorMessage.value),
          );
        }

        if (controller.blockedUsers.isEmpty) {
          return const Center(
            child: Text("No Blocked Users"),
          );
        }

        final blockedUsers = controller.blockedUsers;

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
                          : const AssetImage(
                              "assets/images/img1.png",
                            ) as ImageProvider,
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
                        // Unblock API
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
                  buttoncolor:
                      const Color.fromRGBO(85, 13, 155, 1),
                  bordercolor:
                      const Color.fromRGBO(85, 13, 155, 1),
                  textcolor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        );
      }),
    );
  }
}