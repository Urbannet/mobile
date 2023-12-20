import 'package:flutter/material.dart';
import 'package:fo_proprete_atalian/screens/postdetail.dart';
import 'package:fo_proprete_atalian/services/post.dart';

class LatestPost extends StatefulWidget {
  LatestPost({Key? key}) : super(key: key);

  @override
  _LatestPostState createState() => _LatestPostState();
}

class _LatestPostState extends State<LatestPost> {
  Post postService = Post();

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '').replaceAll("&#8217;", "").replaceAll("&#8230;", "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: FutureBuilder<List>(
        future: postService.getAllPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.length == 0) {
              return Center(
                child: Text("0 Post"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, i) {
                  // print(snapshot.data![i]['content']['rendered']);
                  return Card(
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Image.network(snapshot.data![i]["_embedded"]["wp:featuredmedia"][0]["source_url"]),
                          )
                        ],
                      ),
                      subtitle: Container(
                        padding: EdgeInsets.all(1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              removeAllHtmlTags(snapshot.data![i]['title']['rendered']),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                //color: Colors.blue,
                              ),
                            ),
                            Text(
                              removeAllHtmlTags(snapshot.data![i]['content']['rendered']),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0,
                                //fontStyle: FontStyle.italic,
                                //color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 10.0), // Espacement entre les textes
                          ],
                        ),

                        margin: EdgeInsets.only(bottom: 10.0),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PostDetail(data: snapshot.data?[i]),
                          ),
                        );
                      },
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
