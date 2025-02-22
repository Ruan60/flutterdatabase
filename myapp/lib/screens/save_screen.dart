import 'package:flutter/material.dart';
import '../db/database.dart';
import '../models/post_models.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  late Future<List<Post>> data;
  final db = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    data = db.getPosts();
  }

  Future<void> _deleteAllPosts() async {
    final d = await db.database;
    await d.delete('posts');
    setState(() {
      data = db.getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dados salvos", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              bool? confirm = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Apagar todos os dados salvos??"),
                    actions: [
                      TextButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text("Apagar"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) {
                await _deleteAllPosts();
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5E7A86), Color(0xFF2B383F)],
          ),
        ),
        child: FutureBuilder<List<Post>>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erro: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "Nenhum dado salvo",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          posts[index].title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(color: Colors.grey),
                        Text(posts[index].body),
                        Divider(color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
