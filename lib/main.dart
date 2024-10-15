import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  void _loadCredentials() async {
    await _userRepository.loadData();
    setState(() {
      _loginController.text = _userRepository.username ?? '';
      _passwordController.text = _userRepository.password ?? '';
    });
  }

  void _saveCredentials() async {
    _userRepository.username = _loginController.text;
    _userRepository.password = _passwordController.text;
    await _userRepository.saveData();
  }

  void _onLoginPressed() {
    if (_passwordController.text == 'your_password') {
      _saveCredentials();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(loginName: _loginController.text),
        ),
      );
    }
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _onLoginPressed,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final String loginName;

  const ProfilePage({Key? key, required this.loginName}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository _userRepository = UserRepository();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    await _userRepository.loadData();
    setState(() {
      _firstNameController.text = _userRepository.firstName ?? '';
      _lastNameController.text = _userRepository.lastName ?? '';
      _phoneNumberController.text = _userRepository.phoneNumber ?? '';
      _emailController.text = _userRepository.email ?? '';
    });
  }

  void _saveProfileData() async {
    _userRepository.firstName = _firstNameController.text;
    _userRepository.lastName = _lastNameController.text;
    _userRepository.phoneNumber = _phoneNumberController.text;
    _userRepository.email = _emailController.text;
    await _userRepository.saveData();
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showUnsupportedAlert();
    }
  }

  void _showUnsupportedAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('URL is not supported on this device'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _saveProfileData();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome Back, ${widget.loginName}!'),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () => _launchUrl('tel:${_phoneNumberController.text}'),
                ),
                IconButton(
                  icon: const Icon(Icons.sms),
                  onPressed: () => _launchUrl('sms:${_phoneNumberController.text}'),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email Address'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.email),
                  onPressed: () => _launchUrl('mailto:${_emailController.text}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? username;
  String? password;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;

  Future<void> loadData() async {
    username = await _secureStorage.read(key: 'username');
    password = await _secureStorage.read(key: 'password');
    firstName = await _secureStorage.read(key: 'firstName');
    lastName = await _secureStorage.read(key: 'lastName');
    phoneNumber = await _secureStorage.read(key: 'phoneNumber');
    email = await _secureStorage.read(key: 'email');
  }

  Future<void> saveData() async {
    await _secureStorage.write(key: 'username', value: username);
    await _secureStorage.write(key: 'password', value: password);
    await _secureStorage.write(key: 'firstName', value: firstName);
    await _secureStorage.write(key: 'lastName', value: lastName);
    await _secureStorage.write(key: 'phoneNumber', value: phoneNumber);
    await _secureStorage.write(key: 'email', value: email);
  }
}
