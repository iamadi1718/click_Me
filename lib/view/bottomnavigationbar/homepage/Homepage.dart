import 'package:click_me/Models/Homemodel/Homemodel.dart';
import 'package:click_me/controller/likecontroller/Likecontroller.dart';
import 'package:click_me/services/Homeservices/Homeservices.dart';
import 'package:click_me/view/AddStory/AddStoryCard.dart';
import 'package:click_me/view/customposts/Customposts.dart';
import 'package:click_me/view/customstory/Customstory.dart';
import 'package:flutter/material.dart';
import 'package:click_me/view/Saved%20Audio/Saved_Audio.dart';
import 'package:click_me/view/NotificationScreen/Notification.dart';
import 'package:click_me/view/Chat_QueueScreen/Chat_Queue.dart';
import 'package:click_me/view/settingspage/Settingspage.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
   final LikeController likeController = Get.put(LikeController());
  Future<HomeModel>? futureHome;
  @override
  void initState() {
    super.initState();
    futureHome = HomeService().getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/clickME.png',
                      width: 92,
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SavedAudio(),
                          ),
                        );
                      },
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                    SizedBox(width: width * 0.35),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.notification_add,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatQueue(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.chat,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.menu,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Color.fromRGBO(222, 222, 222, 1),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10),
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search your vibe',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 0,
                  ),
                  child: Divider(thickness: 2),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Addstorycard(),
                      SizedBox(width: width * 0.05),
                      Customstory(
                        bgimage: AssetImage('assets/images/story2.jpg'),
                        text: 'Erica Greens',
                      ),
                      SizedBox(width: width * 0.05),
                      Customstory(
                        bgimage: AssetImage('assets/images/red.jpg'),
                        text: 'Olive Smith',
                      ),
                      SizedBox(width: width * 0.05),
                      Customstory(
                        bgimage: AssetImage('assets/images/story2.jpg'),
                        text: 'Erica Greens',
                      ),
                      SizedBox(width: width * 0.05),
                      Customstory(
                        bgimage: AssetImage('assets/images/red.jpg'),
                        text: 'Olive Smith',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.03),
                FutureBuilder<HomeModel>(
                  future: futureHome,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: Text("No Data"));
                    }

                    final posts = snapshot.data!.data!.posts!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        likeController.initialize(
  index,
  post.likesCount ?? 0,
);

                        return Customposts(
                          index: index,
                          title:
                              "${post.userId?.firstName ?? ""} ${post.userId?.lastName ?? ""}",

                          time: post.createdAt ?? "",

                          image: NetworkImage(
                            "http://103.207.183.10:5000${post.media![0].url}",
                          ),

                          iconno: post.likesCount.toString(),

                          comment: post.commentsCount.toString(),

                          send: post.sharesCount.toString(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
