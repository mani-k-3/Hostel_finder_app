import 'package:flutter/material.dart';
import 'package:hostel_app/login_page.dart';
import 'package:hostel_app/search_screen.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
 // String _searchResult = '';

  void performSearch(String query) {
    // Implement your search functionality here.
    setState(() {
      //_searchResult = 'Search result for: $query';
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHostelPage(searchArea: _searchController.text)));
    });
  }

  void navigateToLoginPage() {
    // Use Navigator to push the login page onto the screen.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            performSearch(value);
          },
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search for Hostels',
            hintStyle: TextStyle(color: Colors.white),
          ),
        )
            : const Text('Hostel Finder'),
        actions: <Widget>[
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                // Handle the sign-in action here.
                navigateToLoginPage(); // Redirect to the login page.

              },
            ),
          IconButton(
            icon: _isSearching ? const Icon(Icons.close) : const Icon(
                Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: const Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Rest of your UI content here
              ],
            ),
          ),
          //Text(_searchResult),
        ],
      ),
    );
  }
}
