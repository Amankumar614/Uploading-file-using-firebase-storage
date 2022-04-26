import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'api/FirebaseApi.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UploadTask? task;
  File? file;

  Future selectFile() async {
    // this is will open the file manager
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return null;
    // the file path will store in the path
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
      print(" this is the file $file");
    });
  }

  @override
  Widget build(BuildContext context) {
    Future UploadFile() async {
      // if (file == null) { var snackBar = SnackBar(content: Text('Hello World'));
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar); } ;
      if (file == null) return;
      final fileName = basename(file!.path);
      final destination = 'files/$fileName';
      task = FirebaseApi.uploadFile(destination, file!);

      if (file == null) {
        return SnackBar(content: Text('File not uploaded successfully'));
      }
      ;
      var snackBar = SnackBar(content: Text('File uploaded successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print("download $urlDownload");
    }

    final fileName = file != null ? basename(file!.path) : 'no file seleted';

    return Scaffold(
      
      body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  SizedBox(
                    width: 300,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('Select File');
                        selectFile();
                      },
                      icon: Icon(Icons.phonelink_ring_sharp),
                      label: Text("Select File"),
                    ),
                  ),SizedBox(
                    height: 20,
                  ),
                  Text(fileName),
                  SizedBox(
                    height: 20,
                  ),
                 
                  SizedBox(
                    width: 300,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.upload),
                      label: Text("Upload File"),
                      onPressed: () {
                        
                        print('upload File');
                        UploadFile();
                      
                      },
                      // child: Text('Upload File')
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
