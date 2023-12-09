import 'package:flutter/material.dart';
import 'package:hostel_app/login_page.dart';
import 'package:hostel_app/HostelSearch.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  void performSearch(String query) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HostelSearch(searchQuery: query),
      ),
    );
  }

  void navigateToLoginPage() {
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
        automaticallyImplyLeading: false,
        title: _buildSearchBar(),
        actions: <Widget>[
          if (_searchController.text.isEmpty)
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: navigateToLoginPage,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchTextField(),
            const SizedBox(height: 16),
            _buildFeatureButtons(),
            const SizedBox(height: 16),
            _buildImageSlider(),
          ],
        ),
      ),
      floatingActionButton: _buildUploadButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSearchBar() {
    return _searchController.text.isEmpty
        ? const Text('Hostel Finder')
        : TextField(
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
    );
  }

  Widget _buildSearchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Search for Hostels',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              performSearch(_searchController.text);
            },
          ),
        ),
        onSubmitted: (value) {
          performSearch(value);
        },
      ),
    );
  }

  Widget _buildFeatureButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFeatureButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Login prompt'),
                  content: const Text('Please login for further'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icons.favorite_border,
          label: 'Favourite',
          backgroundColor: Colors.deepPurpleAccent, // Change the background color
          labelColor: Colors.white, // Change the label color
        ),
        _buildFeatureButton(
          onPressed: () {
            // Handle Recent Viewed Hostels button press
          },
          icon: Icons.remove_red_eye,
          label: 'Recent Views',
          backgroundColor: Colors.lightBlueAccent, // Change the background color
          labelColor: Colors.white, // Change the label color
        ),
      ],
    );
  }

  Widget _buildFeatureButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color labelColor,
  }) {
    return SizedBox(
      width: 150,
      height: 100,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded edges
          ),
          backgroundColor: backgroundColor,
        ),
        icon: Icon(icon, color: Colors.black),
        label: Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: SizedBox(
        height: 50.0,
        width: 100.0,
        child: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Login prompt'),
                  content: const Text('Please login for further'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          label: const Text('Upload'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarIcon(Icons.home),
            _buildNavBarIcon(Icons.account_circle),
            _buildNavBarIcon(Icons.settings),
            _buildNavBarIcon(Icons.logout),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {
          if (icon == Icons.account_circle) {
            navigateToLoginPage();
          } else if (icon == Icons.logout) {
            // Handle logout button press
          }
        },
      ),
    );
  }

  Widget _buildImageSlider() {
    return Container(
      height: 200,
      child: ImageSlider(),
    );
  }
}

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _imageList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeVG9ImXui80ezNeVduchR9GQOuPflAi3dhlzbbEzAuU_MLIgqm6OOzYbBBZISoa-4GmQ&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOXrAMV74AUrRPOxN6RGyRXSmIeDCfRt7FEA&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRZLdm-CBRPdijIXQG1ZGwtPtKWSzfMWF29VVLhbidZuh0wyS2yIvRaCfeY1BznOqZzTk&usqp=CAU',
    // Add your image URLs or local paths here
  ];

  @override
  void initState() {
    super.initState();
    _startSlider();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startSlider() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentPage =
          (_currentPage < _imageList.length - 1) ? _currentPage + 1 : 0;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        });
        _startSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: _imageList.length,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            _imageList[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text('Error loading image'),
              );
            },
          ),
        );
      },
    );
  }
}