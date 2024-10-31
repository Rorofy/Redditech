class Post {
  final String sub;
  final String user;
  final String title;
  final String body;
  final String fullname;
  final String image;
  final num width;
  final num height;
  final String isImage;

  Post({
    required this.sub,
    required this.user,
    required this.title,
    required this.body,
    required this.fullname,
    required this.image,
    required this.width,
    required this.height,
    required this.isImage,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String _image = "false";
    var imageSource;
    String imageUrl = "";
    num _width = 100;
    num _height = 100;
    var imagesInfo;
    var data = json['data'];
    if (data?['post_hint'] == "image") {
      print("HEHEHEHE HOHOHO IMAGE IMAGE \n\n");
      _image = "true";
      imageSource = data?["preview"];
      imagesInfo = imageSource?['images'];
      imageUrl = imagesInfo[0]['source']['url'];
      //if (imageUrl.contains('?')) {
      //imageUrl =
      //    imageUrl.replaceRange(imageUrl.indexOf('?'), imageUrl.length, '');
      //}
      _height = imagesInfo[0]['source']['height'];
      _width = imagesInfo[0]['source']['width'];
      //print(
      //    "\n The data for this image post is: \t$imageUrl\nWidth: $_width\nHeight: $_height");
    }

    return Post(
      sub: data['subreddit'],
      user: data['author'],
      title: data['title'],
      body: data['selftext'],
      fullname: data['name'],
      image: _image == "true" ? imageUrl : data['selftext'],
      width: _width,
      height: _height,
      isImage: _image,
    );
  }

  static List<Post> parseList(List<dynamic> list) {
    return list.map((i) => Post.fromJson(i)).toList();
  }
}
