import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gd6_b_1934/database/sql_helper.dart';
import 'package:gd6_b_1934/entity/employee.dart';
import 'package:gd6_b_1934/inputPage.dart';
import 'package:gd6_b_1934/inputAlat.dart'; // Import halaman InputAlat

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFLITE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(
        title: 'SQFLITE',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> employee = [];
  List<Map<String, dynamic>> alat = []; // Tambahkan list untuk data alat
  int _selectedIndex = 0;

  void refresh() async {
    final employeeData = await SQLHelper.getEmployee();
    final alatData = await SQLHelper.getAlat(); // Ambil data alat dari database

    setState(() {
      employee = employeeData;
      alat = alatData; // Set data alat ke state
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const InputAlat(
            title: 'INPUT ALAT',
            id: null,
            namaAlat: null,
            deskripsi: null,
          ),
        ),
      ).then((_) => refresh()); // Refresh halaman saat kembali
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EMPLOYEE & ALAT"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InputPage(
                    title: 'INPUT EMPLOYEE',
                    id: null,
                    name: null,
                    email: null,
                  ),
                ),
              ).then((_) => refresh());
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? ListView.builder(
              itemCount: employee.length + alat.length, // Jumlah item total
              itemBuilder: (context, index) {
                if (index < employee.length) {
                  // Tampilkan data employee
                  return Slidable(
                    key: ValueKey(employee[index]['id']),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InputPage(
                                  title: 'INPUT EMPLOYEE',
                                  id: employee[index]['id'],
                                  name: employee[index]['name'],
                                  email: employee[index]['email'],
                                ),
                              ),
                            ).then((_) => refresh());
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.update,
                          label: 'Update',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            await deleteEmployee(employee[index]['id']);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(employee[index]['name']),
                      subtitle: Text(employee[index]['email'] ?? ''),
                    ),
                  );
                } else {
                  // Tampilkan data alat
                  final alatIndex = index - employee.length;
                  return Slidable(
                    key: ValueKey(alat[alatIndex]['id']),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InputAlat(
                                  title: 'INPUT ALAT',
                                  id: alat[alatIndex]['id'],
                                  namaAlat: alat[alatIndex]['namaAlat'],
                                  deskripsi: alat[alatIndex]['deskripsi'],
                                ),
                              ),
                            ).then((_) => refresh());
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.update,
                          label: 'Update',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            await SQLHelper.deleteAlat(alat[alatIndex]['id']);
                            refresh();
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(alat[alatIndex]['namaAlat']),
                      subtitle: Text(alat[alatIndex]['deskripsi'] ?? ''),
                      // leading: alat[alatIndex]['foto'] != null
                          // ? Image.file(
                          //     file(alat[alatIndex]['foto']),
                          //     width: 50,
                          //     height: 50,
                          //   )
                          // : const Icon(Icons.build),
                    ),
                  );
                }
              },
            )
          : const Center(child: Text("Fitur Lainnya")),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Employee & Alat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Tambah Alat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> deleteEmployee(int id) async {
    await SQLHelper.deleteEmployee(id);
    refresh();
  }
}