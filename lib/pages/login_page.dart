import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/forgot_page.dart';
import '../providers/auth_provider.dart';
import '../services/navigation_service.dart';
import '../services/snackbar_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = true;
  double _deviceHeight;
  double _deviceWidth;

  GlobalKey<FormState> _formkey;
  AuthProvider _auth;
  String _email;
  String _password;

  _LoginPageState() {
    _formkey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("lib/ima/SC4.jpeg"),
            fit: BoxFit.fill,
          )),
          child: Align(
            alignment: Alignment.center,
            child: ChangeNotifierProvider<AuthProvider>.value(
              value: AuthProvider.instance,
              child: _loginPageUI(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginPageUI() {
    return Builder(
      builder: (BuildContext _context) {
        SnackBarService.instance.buildContext = _context;
        _auth = Provider.of<AuthProvider>(_context);
        return Container(
          height: _deviceHeight * 1.0,
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.12),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _headingWidget(),
              _inputForm(),
              _registerButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _headingWidget() {
    return Container(
      height: _deviceHeight * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox( height:20),
          Text(
            "   Welcome,",
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          Text(
            "Sign in to Continue!",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _inputForm() {
    return Container(
      height: _deviceHeight * 0.40,
      width: _deviceWidth * 0.80,
      child: Form(
        key: _formkey,
        onChanged: () {
          _formkey.currentState.save();
        },
        child: Card(
          color: Color.fromRGBO(232, 241, 249, 1.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 20),
                  height: _deviceHeight * 0.04,
                  child: Text(
                    "Login..",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue,
                    ),
                  )),
              _emailTextField(),
              _PasswordTextField(),
              _restPassword(),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return Center(
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          color: Colors.white,
          child: TextFormField(
            autocorrect: false,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
            validator: (_input) {
              return _input.length != 0 && _input.contains("@")
                  ? null
                  : "Please enter a valid email";
            },
            onSaved: (_input) {
              setState(() {
                _email = _input;
              });
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email Address...",
              hintStyle: TextStyle(fontSize: 20, color: Colors.black38),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
            ),
          )),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _PasswordTextField() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.only(left: 10, right: 10),
      color: Colors.white,
      child: TextFormField(
        autocorrect: false,
        obscureText: passwordVisible,
        style: TextStyle(color: Colors.black),
        // ignore: missing_return
        validator: (_input) {
          return _input.length != 0 ? null : "Please enter a password";
        },
        onSaved: (_input) {
          setState(() {
            _password = _input;
          });
        },
        cursorColor: Colors.white,
        decoration: InputDecoration(
            hintText: "Password...",
            hintStyle: TextStyle(
              fontSize: 20,
              color: Colors.black38,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.black,
            )),
      ),
    );
  }

  Widget _restPassword() {
    return Container(
      margin: EdgeInsets.only(left: 120),
      child: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => ResetPassword()));
          },
          child: Text(
            "Forgot password ? ",
            style: TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400),
            textAlign: TextAlign.right,
          )),
    );
  }

  Widget _loginButton() {
    return _auth.status == AuthStatus.Authenticating
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: 90),
            height: _deviceHeight * 0.06,
            width: _deviceWidth,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                if (_formkey.currentState.validate()) {
                  _auth.loginUserWithEmailAndPassword(_email, _password);
                  // login user
                }
              },
              color: Colors.white,
              child: Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue),
              ),
            ));
  }

  Widget _registerButton() {
    return Column(children: [
      Container(
        // padding: EdgeInsets.symmetric(horizontal: 45),
        height: _deviceHeight * 0.05,
        child: Text(
          "You Don’t Have An Account ?",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
      ),
      GestureDetector(
        onTap: () {
          NavigationService.instance.navigateTo("register");
        },
        child: Container(
          height: _deviceHeight * 0.20,
          child: Text(
            "REGISTER",
            textAlign: TextAlign.end,
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: Colors.blue),
          ),
        ),
      ),
    ]);
  }
}
