import 'package:flutter/material.dart';
import 'package:gd6_b_1934/database/sql_helper.dart';
import 'package:gd6_b_1934/entity/alat.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InputAlat extends StatefulWidget {
  const InputAlat(
      {super.key,
      required this.title,
      required this.id,
      required this.namaAlat,
      required this.deskripsi});

  final String? title, namaAlat, deskripsi, foto;
  final int? id;

  @override
  State<InputAlat> createState() => _InputAlatState();
}

class _InputAlatState extends State<InputAlat> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDeskripsi = TextEditingController();
  File? _image; // Untuk menyimpan foto yang dipilih
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.namaAlat != null) {
      controllerName.text = widget.namaAlat!;
    }
    if (widget.deskripsi != null) {
      controllerDeskripsi.text = widget.deskripsi!; // Set deskripsi jika sudah ada
    }
    if (widget.foto != null) {
      _image = File(widget.foto!); // Set gambar dari path foto jika sudah ada
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("INPUT ALAT"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Nama Alat',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controllerDeskripsi,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Deskripsi',
            ),
          ),
          const SizedBox(height: 24),
          // Pratinjau gambar
          // _image != null
          //     ? Image.file(
          //         _image!,
          //         height: 200,
          //       )
          //     : const Text("Tambah Foto Alat"),
          // const SizedBox(height: 16),
          // ElevatedButton.icon(
          //   icon: const Icon(Icons.photo),
          //   label: const Text("Pilih Foto"),
          //   onPressed: _pickImage,
          // ),
          // const SizedBox(height: 48),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              if (widget.id == null) {
                await addAlat();
              } else {
                await editAlat(widget.id!);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> addAlat() async {
    await SQLHelper.addAlat(controllerName.text, controllerDeskripsi.text);
  }

  Future<void> editAlat(int id) async {
    await SQLHelper.editAlat(id, controllerName.text, controllerDeskripsi.text);
  }

  
}
