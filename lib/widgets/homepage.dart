// ignore_for_file: prefer_final_fields, prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:buscador_de_gifs/widgets/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;
  TextEditingController _searchController = TextEditingController();

  Future<Map> _getGifs() async {
    http.Response response;
    if (_search.isEmpty) {
      response = await http.get(
        Uri.parse(
            "https://api.giphy.com/v1/gifs/trending?api_key=xVzp8tbaWEOp9j7C3YSjSjI8wQo2DFW1&limit=19&offset=$_offset&rating=g"),
      );
    } else {
      response = await http.get(
        Uri.parse(
            "https://api.giphy.com/v1/gifs/search?api_key=xVzp8tbaWEOp9j7C3YSjSjI8wQo2DFW1&q=$_search&limit=19&offset=$_offset&rating=g&lang=pt"),
      );
    }

    return json.decode(response.body);
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: (snapshot.data["data"].length) + 1,
      itemBuilder: (context, index) {
        if (index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]
                  ["fixed_height_small"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPage(snapshot.data["data"][index]),
                ),
              );
            },
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            },
          );
        } else {
          return GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 70,
                ),
                Text(
                  "Carregar mais",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                )
              ],
            ),
            onTap: () {
              setState(() {
                _offset += 19;
              });
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          "images/dev-logo-lg.gif",
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  labelText: "Search here",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.text = "";
                      });
                    },
                  )),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              onSubmitted: (value) {
                setState(() {
                  _search = value.toString();
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 300,
                      height: 300,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 6.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
