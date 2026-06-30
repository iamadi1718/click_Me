import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/controller/likecontroller/search_screen_controller.dart';
import 'package:click_me/view/Search%20Screen/People_Search_Screen.dart';
import 'package:click_me/view/Search%20Screen/Reel_Search_Screen.dart';
import 'Post_Pages_Search_Screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.put(SearchScreenController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    controller.tabController = _tabController;
    _tabController.addListener(() {
      if (_tabController.index != 0) {
        controller.isPeopleSelected.value = false;
      } else {
        // Let user toggle people vs suggestions if needed
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Row: Back Button + Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECECEC),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(Icons.search, color: Colors.grey[600], size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Search...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          Obx(() {
                            if (controller.searchQuery.value.isNotEmpty) {
                              return IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  controller.searchController.clear();
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Obx(() => TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              onTap: (index) {
                if (index == 0) {
                  controller.isPeopleSelected.value = true;
                } else {
                  controller.isPeopleSelected.value = false;
                }
              },
              tabs: [
                Tab(
                  child: Text(
                    "People",
                    style: TextStyle(
                      color: controller.isPeopleSelected.value
                          ? const Color(0xff550D9B)
                          : Colors.grey[600],
                      fontWeight: controller.isPeopleSelected.value
                          ? FontWeight.w500
                          : FontWeight.w400,
                      fontSize: 15,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Reels",
                    style: TextStyle(
                      color: _tabController.index == 1
                          ? const Color(0xff550D9B)
                          : Colors.grey[600],
                      fontWeight: _tabController.index == 1
                          ? FontWeight.w500
                          : FontWeight.w400,
                      fontSize: 15,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Posts/Pages",
                    style: TextStyle(
                      color: _tabController.index == 2
                          ? const Color(0xff550D9B)
                          : Colors.grey[600],
                      fontWeight: _tabController.index == 2
                          ? FontWeight.w500
                          : FontWeight.w400,
                      fontSize: 15,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            )),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),

            Expanded(
              child: Obx(() => TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  controller.isPeopleSelected.value
                      ? PeopleScreen(searchQuery: controller.searchQuery.value)
                      : _buildResultsList(controller.peopleItems),
                  const ReelScreen(),
                  const PostPagesSearchScreen(),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(List<SearchItem> items) {
    final filtered = controller.getFilteredItems(items);
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No results found for '${controller.searchQuery.value}'",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return InkWell(
          onTap: () {
            controller.searchController.text = item.title;
            controller.searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: item.title.length),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                if (item.isSearchIcon)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF9E9E9E),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[700],
                      size: 24,
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(item.imagePath!),
                  ),
                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchItem {
  final String title;
  final bool isSearchIcon;
  final String? imagePath;

  SearchItem({required this.title, required this.isSearchIcon, this.imagePath});
}
