import 'package:face_net_authentication/pages/db/databse_helper.dart';
import 'package:face_net_authentication/pages/teacher_home.dart';
import 'package:face_net_authentication/pages/models/teacher.dart';
import 'package:face_net_authentication/pages/teacher_login.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:face_net_authentication/pages/widgets/app_text_field.dart';
import "package:flutter/material.dart";

class TeacherSignup extends StatelessWidget {
  const TeacherSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _passwordController = TextEditingController();
    final _nameController = TextEditingController();
    return Scaffold(
      
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Container(
                padding: EdgeInsets.all(20),
                child: Image.asset('assets/logo.png'),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    AppTextField(
                      labelText: "Username",
                      isPassword: true, controller: _nameController,
                    ),
                    SizedBox(height: 10),
                    AppTextField(
                      labelText: "Password",
                      isPassword: true, controller: _passwordController,
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    AppButton(
                      icon: Icon(Icons.person_add, color: Colors.white),
                      text: 'Signup',
                      onPressed: () async{
                        DatabaseHelper helper = DatabaseHelper.instance;
                        Teacher? teacher = await helper.signUpTeacher(_nameController.text, _passwordController.text);
                        if(teacher != null){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => TeacherLogin()));
                        } else {
                          // show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Signup failed'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}