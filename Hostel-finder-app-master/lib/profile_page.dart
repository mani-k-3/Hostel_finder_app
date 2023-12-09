import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  String _originalName = "John Doe"; // Assume a default name

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = _originalName;
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveChanges() {
    setState(() {
      _originalName = _nameController.text;
      _isEditing = false;
    });
    // TODO: Save changes to Firebase or your preferred storage

    // After saving, return to the previous screen (LoggedHomePage)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _startEditing,
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _saveChanges,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_isEditing)
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                ),
              )
            else
              Text(
                _originalName,
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),
            // Add more profile details as needed
          ],
        ),
      ),
    );
  }
}
