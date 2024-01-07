import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fo_proprete_atalian/widgets/appbar_custom.dart';
import 'package:http/http.dart' as http;

class PublicationVotes extends StatefulWidget {
  @override
  _PublicationVotesState createState() => _PublicationVotesState();
}

class _PublicationVotesState extends State<PublicationVotes> {
  late List<Post> posts_rhone_alpes = [];

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
    final response_rhone_alpes =
        await http.get(Uri.parse('https://fo-atalian.kitra-consulting.fr/wp-json/wp/v2/posts?_embed&categories=3'));
    if (response_rhone_alpes.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response_rhone_alpes.body);
      setState(() {
        posts_rhone_alpes = responseData.map((data) => Post.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load posts');
    }

  }

  @override
  Widget build(BuildContext context) {
    if (posts_rhone_alpes.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildListWithTitle(posts_rhone_alpes, '3'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListWithTitle(List<Post> posts, String category) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: posts.map((post) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(post: post),
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(post.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        removeAllHtmlTags(post.content),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
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

  PostDetailScreen({required this.post});

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '').replaceAll("&#8217;", "").replaceAll("&#8230;", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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
