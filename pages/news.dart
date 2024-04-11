import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:phone_auth_firebase_tutorial/controllers/auth_service.dart';
import 'package:phone_auth_firebase_tutorial/pages/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';
import '../consts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Dio dio = Dio();

  List<Article> articles = [];
  String? selectedCategory = 'business'; // Default category

  @override
  void initState() {
    super.initState();
    _getNews(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        actions: [
          OutlinedButton(
            onPressed: _logout,
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryDropdown(),
          Expanded(
            child: _buildUI(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      items: <String>[
        'business',
        'science',
        'international',
        'technology', // Additional categories
        'health',
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue;
          if (selectedCategory != null) {
            _getNews(selectedCategory!); // Fetch news when category changes
          }
        });
      },
    );
  }

  Widget _buildUI() {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ListTile(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        ),),
          selectedTileColor: Colors.yellow,
          onTap: () {
            _launchUrl(Uri.parse(article.url ?? ""));
          },
          leading: Image.network(
            article.urlToImage ?? 'No Image',
            height: 250,
            width: 100,
            fit: BoxFit.cover,
          ),
          title: Text(article.title ?? ""),
          subtitle: Text(article.publishedAt ?? ""),
        );
      },
    );
  }

  Future<void> _getNews(String? category) async {
    if (category == null) return; // Skip if category is null
    final response = await dio.get(
      'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=${NEWS_API_KEY}',
    );
    final articlesJson = response.data["articles"] as List;
    setState(() {
      List<Article> newsArticle =
      articlesJson.map((a) => Article.fromJson(a)).toList();
      newsArticle = newsArticle.where((a) => a.title != "[Removed]").toList();
      articles = newsArticle;
    });
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launch(url.toString())) {
      throw Exception('Could not launch $url');
    }
  }

  void _logout() {
    AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void dispose() {
    dio.close();
    super.dispose();
  }
}