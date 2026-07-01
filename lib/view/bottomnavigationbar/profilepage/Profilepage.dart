import 'package:click_me/view/editprofilepage/Editprofilepage.dart';
import 'package:click_me/view/followersScreen/FollowersScreen.dart';
import 'package:click_me/view/followingScreen.dart/FollowingScreen.dart';
import 'package:click_me/view/postswidget/Postswidget.dart';
import 'package:click_me/view/savedwidget/Savedwidget.dart';
import 'package:flutter/material.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:click_me/controller/profileController/ProfileController.dart';
import 'package:get/get.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final ProfileController profileController =
    Get.put(ProfileController());

  int selectedtab = 0;
  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Obx(() {

      if (profileController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (profileController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Text(
            profileController.errorMessage.value,
          ),
        );
      }

      if (profileController.profile.value == null) {
        return const Center(
          child: Text("No Profile Found"),
        );
      }

      final profile = profileController.profile.value!;
       
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundImage: NetworkImage(
                        "${Api.baseUrl}${profile.profileImage}",
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            profile.username ?? "",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _profilestat(
                                profile.totalPosts.toString(),
                                "Posts",
                                () {},
                              ),
                              _profilestat(
                                profile.followersCount.toString(),
                                "Followers",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const FollowersScreen(),
                                    ),
                                  );
                                },
                              ),
                              _profilestat(
                                profile.followingCount.toString(),
                                "Following",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const FollowingScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "${profile.firstName ?? ""} ${profile.lastName ?? ""}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(profile.bio ?? ""),
                SizedBox(height: height * 0.03),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Editprofilepages(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(114, 111, 220, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                InkWell(
                  onTap: () {
                    
                  },
                  child: CircleAvatar(radius: 26, child: Center(child: Icon(Icons.add)))),
                Text('highlights'),
                Divider(thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                        selectedtab = 0;
                      },
                      child: Icon(
                        Icons.grid_view,
                        size: 34,
                        color:
                            selectedtab == 0
                                ? Color.fromRGBO(85, 13, 155, 1)
                                : Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                        selectedtab = 1;
                      },

                      child: Icon(
                        Icons.movie_creation_outlined,
                        size: 34,
                        color:
                            selectedtab == 1
                                ? Color.fromRGBO(85, 13, 155, 1)
                                : Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                        selectedtab = 2;
                      },
                      child: Icon(
                        Icons.person_add_alt_1_outlined,
                        size: 34,
                        color:
                            selectedtab == 2
                                ? Color.fromRGBO(85, 13, 155, 1)
                                : Colors.black,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 1),
                Expanded(
                  child:
                      selectedtab == 0
                          ? Postswidget()
                          : selectedtab == 1
                          ? Savedwidget()
                          : Postswidget(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _profilestat(String value, String title, VoidCallback? onTaps) {
  return InkWell(
    onTap: onTaps,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 15, color: Colors.black)),
      ],
    ),
  );
}
