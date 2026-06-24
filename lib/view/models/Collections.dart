class Collection {
  final String image;
  final String title;

  Collection({required this.image, required this.title});
}

final List<Collection> collections = [
  Collection(image: 'assets/images/img1.png', title: 'All saved posts'),
  Collection(image: 'assets/images/img2.png', title: 'Saved Audios'),
  Collection(image: 'assets/images/img3.png', title: 'Collection1'),
  Collection(image: 'assets/images/img4.png', title: 'Collection2'),
  Collection(image: 'assets/images/img5.png', title: 'Collection3'),
];
