import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(BdMallApp());
}
class BdMallApp extends StatefulWidget {
  const BdMallApp({super.key});

  @override
  State<BdMallApp> createState() => _BdMallAppState();
}

class _BdMallAppState extends State<BdMallApp> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller=WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }else if(request.url.startsWith('tel:')){
              _launchUrl(request.url);
              return NavigationDecision.prevent;
            }else if(request.url.startsWith('mailto:')){
              _launchUrl(request.url);
              return NavigationDecision.prevent;
            }else if(request.url.startsWith('whatsapp://')){
              _launchUrl(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://bdmall.com.bd'));
  }
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Ensures it opens in the correct app
      );
    } else {
      debugPrint('Could not launch $url');
    }
  }
  Future<bool> _onWillPop() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return Future.value(false); // Prevent app from closing
    }
    return Future.value(true); // Allow the app to close if no back history
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: WebViewWidget(controller: controller)
          ),
        ),
      ),
    )
    ;
  }
}
