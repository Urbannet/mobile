import 'package:flutter/material.dart';
import 'package:fo_proprete_atalian/widgets/appbar_custom.dart';

class PostDetail extends StatelessWidget {
  final data;
  const PostDetail({Key? key, required this.data}) : super(key: key);

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
		appBar: CustomAppBar(),
		body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
              child: Text(
                data['title']['rendered'],
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Image.network(data["_embedded"]["wp:featuredmedia"][0]["source_url"]),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              removeAllHtmlTags(data['content']['rendered']
                  .toString()),
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
