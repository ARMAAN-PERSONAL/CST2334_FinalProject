import 'package:flutter/material.dart';

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

  // Initial image source set to the question mark image
  String imageSource = 'lib/images/questionmark.png';

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
                decoration: InputDecoration(
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
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Login ElevatedButton
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Read the password input
                  String enteredPassword = _passwordController.text;
                  // Change the image based on password input
                  if (enteredPassword == "QWERTY123") {
                    imageSource = "lib/images/idea.png"; // Path to the light bulb image
                  } else {
                    imageSource = "lib/images/stop.png"; // Path to the stop sign image
                  }
                });
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            // Display the image based on current imageSource
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}