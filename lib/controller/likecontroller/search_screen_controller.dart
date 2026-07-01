import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/view/Search Screen/Search_Screen.dart';

class SearchScreenController extends GetxController {
  final searchController = TextEditingController(text: 'word');
  final searchQuery = 'word'.obs;
  final isPeopleSelected = false.obs;
  late TabController tabController;

  final List<SearchItem> peopleItems = [
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
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    tabController.dispose();
    super.onClose();
  }

  List<SearchItem> getFilteredItems(List<SearchItem> items) {
    if (searchQuery.value.isEmpty) return items;
    return items
        .where(
          (item) =>
              item.title.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }
}
