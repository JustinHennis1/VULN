import 'package:flutter/material.dart';
import 'package:vuln/components/drawer_view.dart';
import 'package:vuln/pages/home_page.dart';
import 'package:vuln/services/add_message.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
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
        height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: const AssetImage('assets/images/honeycomb.jpg'),
            colorFilter: ColorFilter.mode(
              Theme.of(context).canvasColor,
              BlendMode.colorBurn,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              "↓↓↓ Found an Issue? Please Report It Below ↓↓↓",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: controller,
                maxLines: 5, // Adjust based on your requirement
                decoration: InputDecoration(
                  hintText: 'Enter your report here...',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  filled: true,
                  fillColor: Theme.of(context).focusColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Make API call to send the report to the database
                // You can implement your API call logic here
                await addMessage(controller.text);
                controller.text = '';

                // Show an alert after successfully sending the message
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Success'),
                      content:
                          const Text('Message sent, thank you for your help!!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Submit Report'),
            ),
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Version 1.0 Support",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
