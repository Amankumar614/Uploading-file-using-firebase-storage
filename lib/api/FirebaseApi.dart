

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination,File file){
    
      final ref=FirebaseStorage.instance.ref(destination);
      print("file upload");
      print('ref ${ref.putFile(file)}');
      print("hehehe ${ref.putFile(file)}");
      return ref.putFile(file);
      
   
    
  }
}