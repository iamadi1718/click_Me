import 'package:click_me/Models/FollowingModel/FollowingModel.dart';
import 'package:click_me/services/FollowingServices/FollowingServices.dart';
import 'package:flutter/material.dart';
 

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  late Future<FollowingModel> future;

  final String imageBaseUrl = "https://your-domain.com";

  @override
  void initState() {
    super.initState();
    future = FollowingService().getFollowingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Following",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: FutureBuilder<FollowingModel>(
        future: future,
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
              snapshot.data!.data == null ||
              snapshot.data!.data!.following == null) {
            return const Center(
              child: Text("No Following Found"),
            );
          }

          List<Following> users =
              snapshot.data!.data!.following!;

          return Column(
            children: [

              /// Search Bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search chat here",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              /// Following List
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {

                    final user = users[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8),
                      child: Row(
                        children: [

                          /// Profile Image
                          CircleAvatar(
                            radius: 23,
                            backgroundImage:
                                user.profilePicture != null
                                    ? NetworkImage(
                                        imageBaseUrl +
                                            user.profilePicture!)
                                    : null,
                            child: user.profilePicture ==
                                    null
                                ? const Icon(Icons.person)
                                : null,
                          ),

                          const SizedBox(width: 12),

                          /// Name
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  user.fullName ?? "",
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  "@${user.username}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Message Button
                          SizedBox(
                            width: 90,
                            height: 34,
                            child: ElevatedButton(
                              onPressed: () {

                              },
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.deepPurple,
                                padding: EdgeInsets.zero,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          8),
                                ),
                              ),
                              child: const Text(
                                "Message",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// Unfollow Button
                          SizedBox(
                            width: 95,
                            height: 34,
                            child: ElevatedButton(
                              onPressed: () {

                              },
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.grey,
                                padding: EdgeInsets.zero,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          8),
                                ),
                              ),
                              child: const Text(
                                "Unfollow",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}