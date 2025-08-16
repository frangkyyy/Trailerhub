// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class CustomWebViewWidget extends StatefulWidget {
//   const CustomWebViewWidget(
//       {super.key, required this.title, required this.url});

//   //butuh title karena nanti akan ditambahkan appbar
//   //titlenya dari title movie itu sendiri
//   final String title;
//   final String url;

//   @override
//   CustomWebViewWidgetState createState() => CustomWebViewWidgetState();
// }

// class CustomWebViewWidgetState extends State<CustomWebViewWidget> {
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse(widget.url));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Builder(builder: (_) {
//         //cek jika url nya isEmpty, return Center dengan text 'Homepage is empty'
//         //kalo urlnya ada langsung saja panggil widget.url
//         if (widget.url.isEmpty) {
//           return Center(
//             child: Text('Homepage is empty'),
//           );
//         }

//         return WebViewWidget(controller: controller);
//       }),
//     );
//   }
// }
