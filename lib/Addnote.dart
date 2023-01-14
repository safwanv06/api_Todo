import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import 'main.dart';

class Addnote extends StatefulWidget {
  Addnote({Key? key, this.title, this.content, this.id}) : super(key: key);
  String? title;
  String? content;
  int? id;

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  TextEditingController txt1controller = TextEditingController();
  TextEditingController txt2controller = TextEditingController();
  String? txt1;
  String? txt2;

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    print(widget.id);
    if (widget.id != null) {
      txt1controller.text = widget.title!;
      txt2controller.text = widget.content!;
    } else {}
  }

  sentData(context) async {
    Response res = await post(Uri.parse('http://'
        '192.168.43.50:8000/todoview'),
        body: {'title': txt1controller.text, 'content': txt2controller.text});
    print('>>>>>>>>>>>>>>>>${res.body}');
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return const MyHomePage(
          title: 'title',
        );
      },
    ));
  }

  updateData(context) async {
    Response res = await post(
        Uri.parse('http://192.168.43.50:8000/update_items/${widget.id}'),
        body: {'title': txt1controller.text,'content':txt2controller.text});
    print('>>>>>>>>>>>>${res.statusCode}');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'title'),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 5),
                  child: TextField(
                    style: GoogleFonts.lato(
                      fontSize: 30,
                    ),
                    controller: txt1controller,
                    onChanged: (value) {
                      txt1 = value;
                    },
                    decoration: InputDecoration(
                        hintText: 'Add title',
                        hintStyle: GoogleFonts.lato(fontSize: 30)),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    maxLines: 35,
                    controller: txt2controller,
                    onChanged: (value) {
                      txt2 = value;
                    },
                    decoration: InputDecoration(
                        hintText: 'Add content',
                        hintStyle: GoogleFonts.lato(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.title != null ? updateData(context) : sentData(context);
          },
          child: const Icon(Icons.done),
          backgroundColor: Colors.amber),
    );
  }
}
