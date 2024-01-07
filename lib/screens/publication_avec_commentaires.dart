import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fo_proprete_atalian/widgets/appbar_custom.dart';
import 'package:http/http.dart' as http;

class PublicationAvecCommentaires extends StatefulWidget {
  @override
  _PublicationAvecCommentairesState createState() => _PublicationAvecCommentairesState();
}

class _PublicationAvecCommentairesState extends State<PublicationAvecCommentaires> {
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

  Future<List<Comment>> fetchComments(int postId) async {
    final response = await http.get(Uri.parse('https://fo-atalian.kitra-consulting.fr/wp-json/wp/v2/comments?post=$postId'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => Comment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load comments');
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
          onTap: () async {
            List<Comment> postComments = await fetchComments(post.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailScreen(post: post, comments: postComments),
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
  final int id;
  final String title;
  final String content;
  final String imageUrl;

  Post({required this.id, required this.title, required this.content, required this.imageUrl});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title']['rendered'],
      content: json['excerpt']['rendered'],
      imageUrl: json['_embedded']['wp:featuredmedia'][0]['source_url'],
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final Post post;
  final List<Comment> comments;

  PostDetailScreen({required this.post, required this.comments});

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '').replaceAll("&#8217;", "").replaceAll("&#8230;", "");
  }

  @override
  Widget build(BuildContext context) {
    List<Comment> postComments = comments
        .where((comment) => comment.postId == post.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la publication'),
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
            CommentSection(comments: postComments),
            CommentForm(postId: post.id), // Pass the post ID to CommentForm
          ],
        ),
      ),
    );
  }
}

class Comment {
  final int postId;
  final String content;

  Comment({required this.postId, required this.content});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: json['post'],
      content: json['content']['rendered'],
    );
  }
}

class CommentSection extends StatelessWidget {
  final List<Comment> comments;

  CommentSection({required this.comments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Commentaires',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(comments[index].content),
            );
          },
        ),
      ],
    );
  }
}

class CommentForm extends StatefulWidget {
  final int postId;

  CommentForm({required this.postId});

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final TextEditingController _commentController = TextEditingController();

  Future<String> getToken() async {
    final String apiUrl = 'https://fo-atalian.kitra-consulting.fr/wp-json/jwt-auth/v1/token';

    final String username = 'fo_create_user';
    final String password = 'nuWs 7k1j rKjV 0Nyw CGah vbDZ';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'].containsKey('token')) {
          String token = data['data']['token'];
          return token;
        }

        throw Exception('Token not found in response data');
      } else {
        throw Exception('Failed to obtain JWT token. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error obtaining token: $error');
      throw Exception('An error occurred while obtaining the token. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ajouter un commentaire',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _commentController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Votre commentaire...',
          ),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            submitComment(_commentController.text);
          },
          child: Text('Soumettre'),
        ),
      ],
    );
  }

  Future<void> submitComment(String commentText) async {
    try {
      final String token = await getToken();
      final String apiUrl = 'https://fo-atalian.kitra-consulting.fr/wp-json/wp/v2/comments';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'content': commentText,
          'post': widget.postId, // Utilize the post ID from the widget property
        }),
      );

      print('Comment submission response status code: ${response.statusCode}');
      print('Comment submission response body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Commentaire soumis avec succès'),
          ),
        );
        // Optionally, refresh comments or update UI
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de la soumission du commentaire'),
          ),
        );
      }
    } catch (error) {
      print('Error submitting comment: $error');
    }
  }
}
