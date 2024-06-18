import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:otp/otp.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OTPProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MFA App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    OTPPage(),
    PasswordPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MFA App'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'MFA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key),
            label: 'Passwords',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                child: Text('New OTP Entry'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showAddOTPDialog(context);
                },
              ),
              ElevatedButton(
                child: Text('New Group'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showAddGroupDialog(context);
                },
              ),
              ElevatedButton(
                child: Text('New Password Entry'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showAddPasswordDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddOTPDialog(BuildContext context) {
    final otpProvider = Provider.of<OTPProvider>(context, listen: false);
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    String name = '';
    String secret = '';
    Group? selectedGroup = groupProvider.groups.isNotEmpty ? groupProvider.groups.first : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('New OTP Entry'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Secret'),
                    onChanged: (value) {
                      secret = value;
                    },
                  ),
                  DropdownButton<Group?>(
                    value: selectedGroup,
                    onChanged: (Group? newGroup) {
                      setState(() {
                        selectedGroup = newGroup;
                      });
                    },
                    items: groupProvider.groups.map<DropdownMenuItem<Group>>((Group group) {
                      return DropdownMenuItem<Group>(
                        value: group,
                        child: Text(group.name),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Add'),
                  onPressed: () {
                    otpProvider.addOTP(name, secret, selectedGroup);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddGroupDialog(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    String groupName = '';
    Color groupColor = Colors.blue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Group Name'),
                onChanged: (value) {
                  groupName = value;
                },
              ),
              BlockPicker(
                pickerColor: groupColor,
                onColorChanged: (Color color) {
                  groupColor = color;
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                groupProvider.addGroup(groupName, groupColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddPasswordDialog(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
    String name = '';
    String username = '';
    String password = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Password Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Username'),
                onChanged: (value) {
                  username = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                passwordProvider.addPassword(name, username, password);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class OTPPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OTPProvider>(
      builder: (context, otpProvider, child) {
        return ListView.builder(
          itemCount: otpProvider.otps.length,
          itemBuilder: (context, index) {
            final otp = otpProvider.otps[index];
            return Card(
              color: otp.group?.color,
              child: ListTile(
                title: Text(otp.name),
                subtitle: Text(otp.code),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    otpProvider.removeOTP(otp);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordProvider>(
      builder: (context, passwordProvider, child) {
        return ListView.builder(
          itemCount: passwordProvider.passwords.length,
          itemBuilder: (context, index) {
            final password = passwordProvider.passwords[index];
            return Card(
              child: ListTile(
                title: Text(password.name),
                subtitle: Text('Username: ${password.username}\nPassword: ${password.value}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    passwordProvider.removePassword(password);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings Page'),
    );
  }
}

class OTP {
  final String name;
  final String secret;
  final Group? group;

  OTP({required this.name, required this.secret, this.group});

  String get code => OTP.generateTOTPCodeString(secret);

  static String generateTOTPCodeString(String secret) {
    final code = OTP.generateTOTPCode(secret);
    return code.toString().padLeft(6, '0');
  }
}
