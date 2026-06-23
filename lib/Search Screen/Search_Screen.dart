import 'package:flutter/material.dart';
import 'package:click_me/Search Screen/People_Search_Screen.dart';
import 'package:click_me/Search Screen/Reel_Search_Screen.dart';
import 'Post_Pages_Search_Screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController(
    text: 'word',
  );
  String _searchQuery = 'word';
  bool _isPeopleSelected = false;

  final List<SearchItem> _peopleItems = [
    SearchItem(title: "Word", isSearchIcon: true),
    SearchItem(title: "Word_word", isSearchIcon: true),
    SearchItem(title: "worrrd", isSearchIcon: true),
    SearchItem(title: "wooord", isSearchIcon: true),
    SearchItem(title: "wordddd", isSearchIcon: true),
    SearchItem(
      title: "word_in",
      isSearchIcon: true,
      imagePath: "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != 0) {
        setState(() {
          _isPeopleSelected = false;
        });
      } else {
        setState(() {});
      }
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<SearchItem> _getFilteredItems(List<SearchItem> items) {
    if (_searchQuery.isEmpty) return items;
    return items
        .where(
          (item) =>
              item.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
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
                      Navigator.pop(context);
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
                              controller: _searchController,
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
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              onTap: (index) {
                if (index == 0) {
                  setState(() {
                    _isPeopleSelected = true;
                  });
                } else {
                  setState(() {
                    _isPeopleSelected = false;
                  });
                }
              },
              tabs: [
                Tab(
                  child: Text(
                    "People",
                    style: TextStyle(
                      color:
                          _isPeopleSelected
                              ? const Color(0xff550D9B)
                              : Colors.grey[600],
                      fontWeight:
                          _isPeopleSelected ? FontWeight.w500 : FontWeight.w400,
                      fontSize: 15,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Reels",
                    style: TextStyle(
                      color:
                          _tabController.index == 1
                              ? const Color(0xff550D9B)
                              : Colors.grey[600],
                      fontWeight:
                          _tabController.index == 1
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
                      color:
                          _tabController.index == 2
                              ? const Color(0xff550D9B)
                              : Colors.grey[600],
                      fontWeight:
                          _tabController.index == 2
                              ? FontWeight.w500
                              : FontWeight.w400,
                      fontSize: 15,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _isPeopleSelected
                      ? PeopleScreen(searchQuery: _searchQuery)
                      : _buildResultsList(_peopleItems),
                  const ReelScreen(),
                  const PostPagesSearchScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(List<SearchItem> items) {
    final filtered = _getFilteredItems(items);
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No results found for '$_searchQuery'",
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
            _searchController.text = item.title;
            _searchController.selection = TextSelection.fromPosition(
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
