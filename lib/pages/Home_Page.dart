import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/cloud_firestore_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  final TextEditingController authorController = TextEditingController();
  final TextEditingController bookController = TextEditingController();

  String? imageURL;
  ImagePicker imagePicker = ImagePicker();

  String? author;
  String? book;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("Author Registration"),
        centerTitle: true,
      ),
      backgroundColor: Colors.indigo.withOpacity(0.3),
      body: StreamBuilder(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectRecords(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;

            List<QueryDocumentSnapshot> documents = data!.docs;

            return (documents.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Spacer(),
                        Icon(
                          Icons.library_books_outlined,
                          size: 70,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          " Authors you add appear here ! ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.all(10),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (context, i) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  height: 270,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            height: 168,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "${documents[i]['imageURL']}"),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                            height: 180,
                                            width: width * 0.45,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // Text(
                                                //   "Author : ",
                                                //   style: GoogleFonts.brawler(
                                                //     fontSize: 18,
                                                //     fontWeight: FontWeight.w600,
                                                //   ),
                                                // ),
                                                Text(
                                                  "${documents[i]['author']} ",
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                // Text(
                                                //   "Book Name: \n",
                                                //   style: GoogleFonts.asul(
                                                //     fontSize: 18,
                                                //     fontWeight: FontWeight.w600,
                                                //   ),
                                                // ),
                                                Text(
                                                  "${documents[i]['book']} \n ",
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black,
                                        child: Column(
                                          children: [
                                            const Divider(
                                              color: Colors.white,
                                              thickness: 2,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    validateAndUpdate(
                                                        updata:
                                                            documents[i].id);
                                                    authorController.text =
                                                        documents[i]['author'];

                                                    bookController.text =
                                                        documents[i]['book'];
                                                  },
                                                  icon: const Icon(
                                                    Icons.mode_edit_outlined,
                                                    size: 32,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: const Center(
                                                          child: Text(
                                                              "Delete Record"),
                                                        ),
                                                        content: const Text(
                                                          "Are you sure you Want to Delete Author Record ?",
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              CloudFirestoreHelper
                                                                  .cloudFirestoreHelper
                                                                  .deleteRecord(
                                                                      id: documents[
                                                                              i]
                                                                          .id);

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                              "Delete",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                              "cancel",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  // onPressed: () async {
                                                  //   CloudFirestoreHelper
                                                  //       .cloudFirestoreHelper
                                                  //       .deleteRecord(
                                                  //           id: documents[i]
                                                  //               .id);
                                                  // },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 32,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              color: Colors.white,
                                              thickness: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          validateAndInsert();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  //for insert record
  void validateAndInsert() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: const Center(child: Text("Register Author")),
            content: Form(
              key: insertFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        imgFromGallery();
                        // Navigator.of(context).pop();
                      },
                      child: const Text("IMAGE PIcK"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: authorController,
                        validator: (val) {
                          return (val!.isEmpty)
                              ? "Enter Author Name first"
                              : null;
                        },
                        onSaved: (val) {
                          setState(() {
                            author = val;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Author's Name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bookController,
                        validator: (val) {
                          return (val!.isEmpty)
                              ? "Enter Book Name first"
                              : null;
                        },
                        onSaved: (val) {
                          setState(() {
                            book = val;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Book's Name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (insertFormKey.currentState!.validate()) {
                    insertFormKey.currentState!.save();

                    await CloudFirestoreHelper.cloudFirestoreHelper
                        .insertRecord(
                      author_name: author!,
                      book_name: book!,
                      imageURL: imageURL!,
                    )
                        .then((value) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          content: Text("Author Registered successfully..."),
                        ),
                      );
                    }).catchError(
                      (error) {
                        return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $error"),
                          ),
                        );
                      },
                    );
                  }

                  authorController.clear();
                  bookController.clear();

                  setState(() {
                    author = null;
                    book = null;
                  });

                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(primary: Colors.teal),
                child: const Text("ADD"),
              ),
              ElevatedButton(
                onPressed: () async {
                  authorController.clear();
                  bookController.clear();
                  setState(() {
                    author = null;
                    book = null;
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(primary: Colors.teal),
                child: const Text("Cancel"),
              )
            ],
          );
        });
  }

  //for update record
  void validateAndUpdate({required updata}) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            clipBehavior: Clip.none,
            title: const Center(child: Text("Edit Author")),
            content: Form(
              key: updateFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        imgFromGallery();
                        // Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Edit Image",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: authorController,
                        validator: (val) {
                          return (val!.isEmpty)
                              ? "Enter Author Name first"
                              : null;
                        },
                        onSaved: (val) {
                          setState(() {
                            author = val;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Author's Name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bookController,
                        validator: (val) {
                          return (val!.isEmpty)
                              ? "Enter Book Name first"
                              : null;
                        },
                        onSaved: (val) {
                          setState(() {
                            book = val;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Book's Name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (updateFormKey.currentState!.validate()) {
                    updateFormKey.currentState!.save();

                    await CloudFirestoreHelper.cloudFirestoreHelper
                        .updateRecord(
                      id: updata,
                      author_name: author!,
                      book_name: book!,
                      imageURL: imageURL!,
                    )
                        .then((value) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          content: Text("Author Edited successfully..."),
                        ),
                      );
                    }).catchError(
                      (error) {
                        return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Author edition filed...Error: $error"),
                          ),
                        );
                      },
                    );
                  }

                  authorController.clear();
                  bookController.clear();
                  setState(() {
                    author = "";
                    book = "";
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(primary: Colors.teal),
                child: const Text("Edit"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.teal),
                onPressed: () async {
                  authorController.clear();
                  bookController.clear();
                  setState(() {
                    author = null;
                    book = null;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              )
            ],
          );
        });
  }

  Future imgFromGallery() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImages = referenceRoot.child('images');
    Reference referenceImagesUpload = referenceImages.child(uniqueFileName);

    try {
      await referenceImagesUpload.putFile(File(file!.path));
      imageURL = await referenceImagesUpload.getDownloadURL();
    } catch (error) {
      print("$error");
    }
  }
}
