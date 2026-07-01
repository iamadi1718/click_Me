class Collection {
  final String image;
  final String title;

  Collection({required this.image, required this.title});
}

final List<Collection> collections = [
  Collection(image: 'assets/images/img1.png', title: 'All saved posts'),
  Collection(image: 'assets/images/img2.png', title: 'Saved Audios'),
  
];
