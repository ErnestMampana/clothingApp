import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(50, 100, 50, 5),
        child: Column(
          children: [
            const Text(
              'Sign In',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 50),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              //autofillHints: ,
              decoration: InputDecoration(
                labelText: 'data',
                fillColor: Colors.lightBlue,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1, //<-- SEE HERE
                    color: Colors.greenAccent,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  //fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                const Text(
                  'Remember me',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('login'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Forgot Password?'),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 2,
                    endIndent: 20,
                  ),
                ),
                Text('Or'),
                Expanded(
                  child: Divider(
                    thickness: 2,
                    color: Colors.black,
                    indent: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.amber[100],
              width: 5000,
              height: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.amber[100],
              width: 5000,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
