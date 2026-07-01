import 'package:click_me/controller/likecontroller/manage_blocked_controller.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Manageblocked extends StatelessWidget {
  Manageblocked({super.key});

  final controller = Get.put(ManageBlockedController());

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

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(controller.errorMessage.value),
          );
        }

        if (controller.rxBlocked.value == null ||
            controller.rxBlocked.value!.data?.blockedUsers == null ||
            controller.rxBlocked.value!.data!.blockedUsers!.isEmpty) {
          return const Center(
            child: Text("No Blocked Users"),
          );
        }

        final blockedUsers = controller.rxBlocked.value!.data!.blockedUsers!;

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
                        controller.unblockUser(user.id ?? "");
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
                    Get.back();
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
      }),
    );
  }
}