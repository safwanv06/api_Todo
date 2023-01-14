import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import 'Addnote.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List a = [];
  bool b = true;
  int? d;
  int? e;
  int f = 1;

  clr() {
    if (f == 1) {
      f = 2;
      return  const Color(0xffD9F8C4);
    } else if (f == 2) {
      f = 3;
      return const Color(0xFFF9F9C5);
    } else if (f == 3) {
      f = 4;
      return const Color(0xFFFAD9A1);
    } else if (f == 4) {
      f = 1;
      return const Color(0xFFF37878);
    }
  }

  dltData(id) async {
    print('>>>>>>>>>>>>>>>>>>>>>>>${id}');
    Response res = await delete(
        Uri.parse('http://192.168.43.50:8000/delete_items/$id/delete'));
    print(res.body);
    d = res.statusCode;
    print(d);
    if (d == 202) {
      print('object');
      setState(() {
        a.removeWhere((element) => element['id'] == id);
      });
    } else {
      return const AlertDialog(
        title: Text('Erorr!!!!'),
      );
    }
  }

  getData() async {
    Response res =
        await get(Uri.parse('http://192.168.43.50:8000/TodoListView'));
    a = jsonDecode(res.body);
    print(a);
    setState(() {
      b = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: b
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.amber,
                        child: Text('  Notes',
                            style: GoogleFonts.lato(fontSize: 30))),
                  ),
                  const Divider(),
                  Expanded(
                    flex: 10,
                    child: Container(
                        child: a.isEmpty
                            ? const Center(child: Text('Empty'))
                            : SingleChildScrollView(
                                child: Container(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: a.map((e) {
                                      print(e);
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Addnote(
                                                    id: e['id'],
                                                    title: e['title'],
                                                    content: e['content']),
                                              ));
                                        },
                                        child: Container(
                                            width: a.indexOf(e) % 3 != 0
                                                ? (deviceWidth / 2) - 11
                                                : deviceWidth - 18,
                                            height: 190,
                                            decoration: BoxDecoration(
                                                color: clr(),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 20, 10, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${e['title']}' ?? '',
                                                    style: GoogleFonts.actor(
                                                      fontSize: 40,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        '${e['content']}' ?? '',
                                                        overflow:
                                                            TextOverflow.fade,
                                                        maxLines: 4,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 20,
                                                            color: Colors.black87)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        100, 30, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              dltData(
                                                                  e['id']);
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .delete_forever,
                                                              color: Colors
                                                                  .black38,
                                                            ))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                      );
                                    }).toList(),
                                  ),
                                )),
                              )),
                  )
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Addnote(),
                ));
          },
          child: const Icon(Icons.add)),
    );
  }
}
// SingleChildScrollView(
// child: Card(
// child: ListTile(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => Addnote(
// id: a[index]['id'],
// title: a[index]['title'],
// content: a[index]
// ['content']),
// ));
// },
// title: Text(
// a[index]['title'] ?? '',
// style:
// GoogleFonts.actor(fontSize: 20),
// ),
// trailing: IconButton(
// onPressed: () {
// dltData(a[index]['id']);
// },
// icon:
// const Icon(Icons.delete_forever),
// )),
// ),
// );
