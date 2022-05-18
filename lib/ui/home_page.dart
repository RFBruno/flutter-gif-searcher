import 'dart:convert';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search = '';
  int offset = 0;

  Future<dynamic> _getGifs() async {
    http.Response response;

    if(_search.isEmpty){
      response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=GIZdrOzWTxHE4L4V4MuSIq1izmxU1LZK&limit=20&rating=G');
    }else{
      response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=GIZdrOzWTxHE4L4V4MuSIq1izmxU1LZK&q=$_search&limit=19&offset=$offset&rating=g&lang=en');
    }

    return jsonDecode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _getGifs().then((map) => print(map));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.network('https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquise aqui',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                   return Container(
                     alignment: Alignment.center,
                     child: const CircularProgressIndicator(
                       valueColor: AlwaysStoppedAnimation(Colors.white),
                       strokeWidth: 5,
                     ),
                   );
                   default:
                    if(snapshot.hasError){
                      return Container();
                    }else{
                      return _createBuildTable(context, snapshot);
                    }
                }

              }
            ),
          ),
        ],
      ),
    );
  }

  int _itemCount(data){
    if(_search.isEmpty){
      return data.length;
    }else{
      return data.length + 1;
    }
  }

  Widget _createBuildTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10
      ),
      itemCount: _itemCount(snapshot.data["data"]) ,
      itemBuilder: (context, index) {
        if(_search.isEmpty || index < snapshot.data["data"].length){
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPage(snapshot.data["data"][index])
                )
              );
            },
            onLongPress: (){
              Share.share(
                snapshot.data["data"][index]["images"]["fixed_height"]["url"]
              );
            },
          );
        }else{
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 60,
                  ),
                  Text(
                    'Carregar mais...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  )
                ],
              ),
              onTap: (){
                setState(() {
                  offset += 19;
                });
              },
            ),
          );
        }
      }
    );
  }
}



