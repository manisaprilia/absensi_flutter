import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AbsensiApp());
}

class AbsensiApp extends StatelessWidget {
  const AbsensiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form Absensi',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
        ).copyWith(secondary: Colors.pinkAccent),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.pink.shade50,
          labelStyle: const TextStyle(color: Colors.pink),
          floatingLabelStyle: const TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.pink.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.pink, width: 2),
          ),
        ),
      ),
      home: const AbsensiFormPage(),
    );
  }
}

class AbsensiFormPage extends StatefulWidget {
  const AbsensiFormPage({super.key});

  @override
  State<AbsensiFormPage> createState() => _AbsensiFormPageState();
}

class _AbsensiFormPageState extends State<AbsensiFormPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController deviceController = TextEditingController();

  String? jenisKelamin;

  Future<void> submitAbsensi() async {
    final url = Uri.parse(
      "https://absensi-mobile.primakarauniversity.ac.id/api/absensi",
    );

    final body = {
      "nama": namaController.text,
      "kelas": kelasController.text,
      "nim": nimController.text,
      "jenis_kelamin": jenisKelamin ?? "",
      "device": deviceController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.pink.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            data["status"] == "success" ? "Berhasil" : "Gagal",
            style: TextStyle(
              color: data["status"] == "success"
                  ? Colors.pink
                  : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(data["message"]),
          actions: [
            TextButton(
              child: const Text("OK", style: TextStyle(color: Colors.pink)),
              onPressed: () {
                Navigator.pop(context);

                if (data["status"] == "success") {
                  namaController.clear();
                  nimController.clear();
                  kelasController.clear();
                  deviceController.clear();
                  setState(() => jenisKelamin = null);
                }
              },
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.pink.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Error",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Terjadi kesalahan, cek koneksi internet."),
          actions: [
            TextButton(
              child: const Text("OK", style: TextStyle(color: Colors.pink)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Widget buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.pink,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        title: const Text("Form Absensi"),
        elevation: 2,
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle("Nama"),
                  const SizedBox(height: 5),
                  TextField(controller: namaController),
                  const SizedBox(height: 16),

                  buildTitle("NIM"),
                  const SizedBox(height: 5),
                  TextField(controller: nimController),
                  const SizedBox(height: 16),

                  buildTitle("Kelas"),
                  const SizedBox(height: 5),
                  TextField(controller: kelasController),
                  const SizedBox(height: 16),

                  buildTitle("Jenis Kelamin"),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          activeColor: Colors.pink,
                          title: const Text("Laki-Laki"),
                          value: "Laki-Laki",
                          groupValue: jenisKelamin,
                          onChanged: (value) =>
                              setState(() => jenisKelamin = value),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          activeColor: Colors.pink,
                          title: const Text("Perempuan"),
                          value: "Perempuan",
                          groupValue: jenisKelamin,
                          onChanged: (value) =>
                              setState(() => jenisKelamin = value),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  buildTitle("Device"),
                  const SizedBox(height: 5),
                  TextField(controller: deviceController),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitAbsensi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        "Submit Absensi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
