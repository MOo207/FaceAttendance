import 'package:face_net_authentication/pages/db/databse_helper.dart';
import 'package:face_net_authentication/pages/teacher_home.dart';
import 'package:face_net_authentication/pages/models/teacher.dart';
import 'package:face_net_authentication/pages/teachers_signup.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:face_net_authentication/pages/widgets/app_text_field.dart';
import "package:flutter/material.dart";

class TeacherLogin extends StatelessWidget {
  const TeacherLogin({Key? key}) : super(key: key);

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
                    Text(
                      'Welcome back, teacher.',
                      style: TextStyle(fontSize: 20),
                    ),
                    
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
                      text: 'LOGIN',
                      icon: Icon(Icons.login, color: Colors.white),
                      onPressed: () async{
                            DatabaseHelper helper = DatabaseHelper.instance;
                        Teacher? teacher = await helper.loginTeacher(_nameController.text, _passwordController.text);
                        if(teacher != null){
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => TeacherHome(teacher: teacher,)));
                        } else {
                          // show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Teacher was not found'),
                            ),
                          );
                        }
                       
                      },
                    ),
                    // link to signup
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TeacherSignup()));
                      },
                      child: Text(
                        'Create an account',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
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