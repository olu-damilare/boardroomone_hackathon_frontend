import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  File _image = File('assets/placeholder.png');
  ImagePicker picker = ImagePicker();
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
              height: 32,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 80,
                  child: _image != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.file(
                      _image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50)),
                    width: 100,
                    height: 100,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
            SizedBox(height: 5),
            Text(
                "Name:",
              style: TextStyle(
                color: Colors.white,
                  fontWeight: FontWeight.bold
              )
            ),
            SizedBox(height: 5),
            buildTextFormField(
                'Name', 15, FontWeight.w400, 'Input your name'),
            SizedBox(height: 5),
            Text("Blurb:",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )
            ),
            SizedBox(height: 5),
            buildTextFormField(
                'blurb', 15, FontWeight.w400, 'Input your name'),
            SizedBox(height: 15),
        ]
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

    _imgFromCamera() async {
      File image = (await picker.pickImage(
          source: ImageSource.camera, imageQuality: 50
      )) as File;

      setState(() {
        _image = image;
      });
    }

    _imgFromGallery() async {
      File image = (await  picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50
      )) as File;

      setState(() {
        _image = image;
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

  Future<void> modifyImage() async{

    try {
      Response response = await get(
          Uri.parse("http://localhost:8080/upload"));
      Map data = jsonDecode(response.body);

      imageUrl = data["secure_url"];

    }catch(e){
      print('caught error: $e');
    }
  }

}