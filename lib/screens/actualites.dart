import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fo_proprete_atalian/screens/postdetail.dart';

class Actualite extends StatefulWidget {
  @override
  _ActualiteState createState() => _ActualiteState();
}

class _ActualiteState extends State<Actualite> {
  late List<Post> posts_rhone_alpes = [];
  late List<Post> posts_nationale 	= [];

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '').replaceAll("&#8217;", "").replaceAll("&#8230;", "");
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final response_rhone_alpes 	= await http.get(Uri.parse('https://fo-atalian.kitra-consulting.fr/wp-json/wp/v2/posts?_embed&categories=3'));
    if (response_rhone_alpes.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response_rhone_alpes.body);
      setState(() {
        posts_rhone_alpes = responseData.map((data) => Post.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load posts');
    }

    final response_nationale 	= await http.get(Uri.parse('https://fo-atalian.kitra-consulting.fr/wp-json/wp/v2/posts?_embed&categories=5'));
    if (response_nationale.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response_nationale.body);
      setState(() {
        posts_nationale = responseData.map((data) => Post.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load posts');
    }


  }

  @override
  Widget build(BuildContext context) {
    if (posts_rhone_alpes == null && posts_nationale == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First ListView with title
            _buildListWithTitle('Actualité Auvergne Rhône Alpes', posts_rhone_alpes, '3'),

            // Second ListView with title
            _buildListWithTitle('Actualité Nationales', posts_nationale, '5'),
          ],
        ),
      ),
    );
  }

  Widget _buildListWithTitle(String title, List<Post> posts, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.redAccent, // Background color
              borderRadius: BorderRadius.circular(8.0), // Optional: add rounded corners
            ),
            child: Text(
              title,
              style: category == '3'
                  ? TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white, // Customize the color as needed
              )
                  : TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white, // Customize the color as needed
              ),

            ),
          ),
        ),
        Container(
          height: 300, // Adjust the height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle the tap event here, for example, navigate to the post detail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(post: posts[index]),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  child: Container(
                    width: 300,
                    height: 250, // Fixed height for each block
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          posts[index].imageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          posts[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          removeAllHtmlTags(posts[index].content),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Post {
  final String title;
  final String content;
  final String imageUrl;

  Post({required this.title, required this.content, required this.imageUrl});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title']['rendered'],
      content: json['excerpt']['rendered'],
      imageUrl: json['_embedded']['wp:featuredmedia'][0]['source_url'],
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final Post post;

  // Constructor to receive the selected post
  PostDetailScreen({required this.post});

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '').replaceAll("&#8217;", "").replaceAll("&#8230;", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 190.0,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              post.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              post.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              removeAllHtmlTags(post.content),
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}