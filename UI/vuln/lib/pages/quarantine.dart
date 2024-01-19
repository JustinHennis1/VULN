import 'package:flutter/material.dart';
import 'package:vuln/components/drawer_view.dart';
import 'package:vuln/components/getqfilelist.dart';
import 'package:vuln/pages/home_page.dart';
//import 'package:vuln/components/scan_now.dart';

class QPage extends StatefulWidget {
  const QPage({super.key});

  @override
  State<QPage> createState() => _QPageState();
}

class _QPageState extends State<QPage> {
  String selectedFile = '';
  List<String> tempFiles = [];
  String searchQuery = '';

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
          color: Theme.of(context).secondaryHeaderColor,
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Container(
                width: 600,
                height: 400,
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  border: Border.all(),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Quarantine:',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).canvasColor),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    SearchBar(
                      hint: Theme.of(context).hintColor,
                      onSearch: (query) {
                        //print('Search query: $query');
                        setState(() {
                          searchQuery = query;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: QuarantinedFilesList(searchQuery: searchQuery),
                    ),
                    const SizedBox(height: 10),
                    //Text('Selected File: $selectedFile'),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Version 1.0 File Select",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, required this.hint, required this.onSearch})
      : super(key: key);

  final Color hint;
  final void Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        onChanged: onSearch, // Trigger search on text change
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: hint),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
