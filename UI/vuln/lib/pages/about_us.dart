import 'package:flutter/material.dart';
import 'package:vuln/components/drawer_view.dart';
import 'package:vuln/pages/home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                },
                child: const Text('Vulnerabilities Under Learned Network'))),
      ),
      drawer: const DrawerView(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: const AssetImage('assets/images/honeycomb.jpg'),
            colorFilter: ColorFilter.mode(
              Theme.of(context).canvasColor,
              BlendMode.colorBurn,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              //constraints: const BoxConstraints(maxWidth: 600.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'About Us',
                      style: TextStyle(
                          fontFamily: 'Times New Roman', fontSize: 40),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Welcome to our world of cybersecurity, where passion meets protection! '
                    ' At VULN, we are driven by an unyielding commitment to securing the digital landscape and safeguarding the online realms we inhabit.'
                    ' Every day another victim is taken advantage of by scammers and vicious hackers.'
                    ' Help spread the word and keep your loved ones safe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '-V.U.L.N Creator',
                        style: TextStyle(fontSize: 16),
                      ))
                  // Add more Text widgets for other sections of the content
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
