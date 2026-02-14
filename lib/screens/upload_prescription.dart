// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import 'package:pharmacy/screens/payment.dart';

// class UploadPrescriptionScreen extends StatefulWidget {
//   @override
//   _UploadPrescriptionScreenState createState() =>
//       _UploadPrescriptionScreenState();
// }

// class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
//   File? image;

//   pick() async {
//     final picked =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) setState(() => image = File(picked.path));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Upload Prescription")),
//       body: Column(
//         children: [
//           image != null
//               ? Image.file(image!, height: 200)
//               : Text("No Prescription Selected"),
//           ElevatedButton(onPressed: pick, child: Text("Upload Image")),
//           TextButton(
//             child: Text("Skip"),
//             onPressed: () {
//               Navigator.push(context,
//                 MaterialPageRoute(builder: (_) => PaymentScreen()));
//             },
//           ),
//           ElevatedButton(
//             child: Text("Continue to Payment"),
//             onPressed: () {
//               Navigator.push(context,
//                 MaterialPageRoute(builder: (_) => PaymentScreen()));
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
