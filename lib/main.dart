import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controllers for text fields
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Secure storage instance for encrypted data
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  // Load credentials from secure storage
  void _loadCredentials() async {
    String? username = await _secureStorage.read(key: 'username');
    String? password = await _secureStorage.read(key: 'password');

    if (username != null && password != null) {
      setState(() {
        _loginController.text = username;
        _passwordController.text = password;
      });
      // Show Snackbar with Undo action
      _showSnackbarWithUndo();
    }
  }

  void _showSnackbarWithUndo() {
    final snackBar = SnackBar(
      content: const Text('Previous login details loaded'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _loginController.clear();
            _passwordController.clear();
          });
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Credentials'),
          content: const Text('Would you like to save your username and password for the next time you run the application?'),
          actions: [
            TextButton(
              onPressed: () {
                _saveCredentials();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                _clearCredentials();
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _saveCredentials() async {
    String username = _loginController.text;
    String password = _passwordController.text;
    await _secureStorage.write(key: 'username', value: username);
    await _secureStorage.write(key: 'password', value: password);
  }

  void _clearCredentials() async {
    await _secureStorage.delete(key: 'username');
    await _secureStorage.delete(key: 'password');
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Login Name TextField
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Login name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Password TextField
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true, // Hides the input
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Login ElevatedButton
            ElevatedButton(
              onPressed: () {
                // Show dialog to ask if user wants to save credentials
                _showSaveDialog();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
