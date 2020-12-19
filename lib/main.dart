import 'package:flutter/material.dart';  // library which will follow matreial design guidelines
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart'; //plugin
import 'package:image_picker/image_picker.dart'; //plugin
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'result.dart';
import 'globals.dart' as globals;

void main() => runApp(MyApp()); //entry point of the app
// runApp() runs the app which is passed as a widget inside it

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //statelesswidget i super class
  //MyApp is subclass
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detect your Currency ',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{

  File _selectedFile;
  bool _inProcess = false;
  bool statusText;

  Widget getImageWidget()
  {
    if (_selectedFile != null)
    {
      return Image.file(
        _selectedFile,
        width: 300,
        height: 200,
        fit: BoxFit.cover,
      );
    }
    else
    {
      return Image.asset(
        "images/camera.png",
        width: 250,
        height: 250,
        fit: BoxFit.cover,);
    }
  }

  getImage(ImageSource source) async
  {
    this.setState(() {
      _inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(
              ratioX: 3, ratioY: 2),
          //compressQuality: 100,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "Image Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          )
      );

      this.setState(() {
        _selectedFile = cropped;
        _inProcess = false;
      });
    }

    else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  void upload() async {

    final phpEndPoint = 'http://b6a0cebcd356.ngrok.io';
    if (_selectedFile == null) return;
    String base64Image = base64Encode(_selectedFile.readAsBytesSync());
    String fileName = _selectedFile.path.split("/").last;
    print(base64Image);
    Map data = {'image': base64Image ,
      'name': fileName} ;
    var body = json.encode(data);
    await http.post(phpEndPoint,
      headers: {"accept": "application/json",
        "content-type": "application/json; charset=UTF-8"},
      body: body,
    ).then((res) {
      print(res.statusCode);
      print(res.body);
      globals.a = res.body;
      Fluttertoast.showToast(msg: "Image upload successful", toastLength: Toast.LENGTH_SHORT);
    }).catchError((err) {
      print(err);
      Fluttertoast.showToast(msg: "Image upload failed ", toastLength: Toast.LENGTH_SHORT);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text ( "Currency Detector",
          ),
        ),
        body: Stack(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getImageWidget(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                            color: Colors.teal,
                            child: Text(
                              "Camera",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              getImage(ImageSource.camera);
                            }),
                        MaterialButton(
                            color: Colors.teal,
                            child: Text(
                              "Device",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            }),

                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                                color: Colors.teal,
                                child: Text(
                                  "Upload",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: upload
                            )
                          ], )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                                color: Colors.red,
                                child: Text(
                                  "Detect",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return result();
                                  }));
                                })
                          ], )

                      ],
                    )
                  ])]));
  }
}
