import 'dart:io';
import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _pickedImage;
  String outputText = "";
  final GlobalKey<AnimatedFloatingActionButtonState> key =
  GlobalKey<AnimatedFloatingActionButtonState>();
  final GlobalKey<ScaffoldState> keyclipboard = new GlobalKey<ScaffoldState>();

  void showbar() {
    keyclipboard.currentState!
        .showSnackBar(new SnackBar(content: new Text('Đã copy toàn bộ!')));
  }

  pickedImage(File file) {
    setState(() {
      _pickedImage = file;
    });
    InputImage inputImage = InputImage.fromFile(file);
    // code to recognsize image
    processImageForConversion(inputImage);
  }

  processImageForConversion(inputImage) async {
    setState(() {
      outputText = "";
    });

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    for (TextBlock block in recognizedText.blocks) {
      setState(() {
        outputText += block.text + "\n";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyclipboard,
      appBar: AppBar(
        title: Text("Image To Text"),
        actions: [
          IconButton(
              onPressed: () {
                FlutterClipboard.copy(outputText).then((value) => showbar());
              },
              icon: Icon(Icons.copy))
        ],
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        //Fab list
          fabButtons: <Widget>[float1(), float2()],
          key: key,
          colorStartAnimation: Colors.blue,
          colorEndAnimation: Colors.red,
          animatedIconData: AnimatedIcons.menu_close //To principal button
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_pickedImage == null)
                Container(
                  height: 300,
                  color: Colors.black,
                  width: double.infinity,
                )
              else
                Container(
                  child: SizedBox(
                      child: Image.file(
                        _pickedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )),
                ),
              SizedBox(
                height: 20,
              ),
              SelectableText(
                outputText,
                showCursor: true,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget float1() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          pickImage(ImageSource.gallery, pickedImage);
        },
        heroTag: "btn1",
        tooltip: 'First button',
        child: Icon(Icons.image_outlined),
      ),
    );
  }

  Widget float2() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          pickImage(ImageSource.camera, pickedImage);
        },
        heroTag: "btn2",
        tooltip: 'Second button',
        child: Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}