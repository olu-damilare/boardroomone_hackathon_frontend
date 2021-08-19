import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';

import 'package:path/path.dart';
import 'package:async/async.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  // File _image = File('assets/placeholder.png');
  ImagePicker picker = ImagePicker();
  // Image defaultImage = Image.asset('assets/placeholder.png');
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
            "Edit profile",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white

          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                 child: Container(
                   height: 300.0,
                   width: 300.0,
                    child: imageUrl.length > 1 ?
                    ClipRRect(
                           borderRadius: BorderRadius.circular(50),
                           child: Image.network(
                             imageUrl,
                             width: 150,
                             height: 150,
                             fit: BoxFit.cover,
                           ),
                         ) :
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    width: 180,
                    height: 180,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                          Text(
                              "click to upload",
                              style: TextStyle(
                                  color: Colors.black
                              )
                          ),

                      ]
                  ),
                    ),
                  ),
                ),
              ),
            ),
        ]
        ),
    ),
    );
  }

    _imgFromCamera() async {
      XFile? image = (await picker.pickImage(
          source: ImageSource.camera, imageQuality: 50
      ));

      setState(() {
        modifyImage(image);
        // _image = ;
      });
    }

    _imgFromGallery() async {
      XFile? image = (await  picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50
      ));

      setState(() {
        modifyImage(image);

        // _image = image;
      }
      );
    }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  TextFormField buildTextFormField(String inputText, double fontSize,
      FontWeight fontWeight, String hintText) {
    return TextFormField(
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[350],
          ),
          fillColor: Colors.grey[100],
          filled: true
      ),
      style: TextStyle(
        fontFamily: 'Lato',
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  Future<void> modifyImage(XFile? imageFile) async {
    var streamedResponse = new ByteStream(DelegatingStream.typed(imageFile!.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse("https://boardroom-one.herokuapp.com/upload");

    var request = new MultipartRequest("POST", uri);
    var multipartFile = new MultipartFile('file', streamedResponse, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    var response = await request.send();

    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      imageUrl = json.decode(value)['secure_url'];
      print(imageUrl);
      print(value);
    });
  }
}