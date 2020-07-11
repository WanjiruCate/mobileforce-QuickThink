import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickthink/model/categories.dart';
import 'package:quickthink/theme/theme.dart';
import 'package:quickthink/utils/responsiveness.dart';
import 'package:http/http.dart' as http;
import 'package:clipboard_manager/clipboard_manager.dart';

// TODO: Visual feedback for when a selected
// TODO: Tell user when category isn't selected... category validation
// TODO: Change colours of modal fonts and line from black
// TODO: Center progress loading text
// TODO: Change progress loading colour from black //Done
// TODO: Visual feedback for copy code

const String fetchGameCode_Api = 'http://mohammedadel.pythonanywhere.com/game';

class CreateGame extends StatefulWidget {
  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  //GetCategories getCategories = new GetCategories();

  List<Categories> listCategories;
  var getCat;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  SizeConfig _sizeConfig;
  bool isLoading;
  String userName = '';
  String category;
  String hintText;
  String gameCode;
  TextEditingController userNameController = TextEditingController();

  Future _fetchCategory() async {
    setState(() {
      isLoading = true;
    });
    listCategories = await getCategories();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    userNameController.addListener(() {});
    _fetchCategory();
    super.initState();
  }

  void _showInSnackBar(String value, color) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: color,
      duration: new Duration(seconds: 3),
    ));
  }

  Future<String> getCode(context, username) async {
    setState(() {
      progressDialog.show();
    });
    http.Response response = await http.post(
      fetchGameCode_Api,
      headers: {'Accept': 'application/json'},
      body: {"user_name": userName, "category": category},
    );

    if (response.statusCode == 200) {
      String data = response.body;
      gameCode = jsonDecode(data)['game_code'].toString();
      setState(() {
        progressDialog.hide();
      });
      _showInSnackBar(gameCode, Colors.green);
      showQuizCodeBottomSheet(context);
      return gameCode;
    } else {
      setState(() {
        progressDialog.hide();
      });
      _showInSnackBar(response.body, Colors.red);
      throw Exception('Failed to retrieve code');
    }
  }

  bool light = CustomTheme.light;

  final _formKey = GlobalKey<FormState>();

  ProgressDialog progressDialog;

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);

    progressDialog.style(
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: SpinKitThreeBounce(color: Color(0xFF18C5D9), size: 25),
      elevation: 10.0,
      insetAnimCurve: Curves.easeOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _logoText(),
                SizedBox(
                  height: SizeConfig().yMargin(context, 10),
                ),
                _prompt(),
                SizedBox(
                  height: SizeConfig().yMargin(context, 4),
                ),
                _userName(),
                SizedBox(
                  height: SizeConfig().yMargin(context, 7),
                ),
                _promptCategory(),
                SizedBox(
                  height: SizeConfig().yMargin(context, 1),
                ),
                _allCategories(
                  onSelect: (String categoryChosen) {
                    setState(() {
                      category = categoryChosen;
                      print(category);
                    });
                  },
                ),
                SizedBox(
                  height: SizeConfig().yMargin(context, 4),
                ),
                _loginBtn(),
                SizedBox(
                  height: SizeConfig().yMargin(context, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _prompt() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig().xMargin(context, 5.0),
        right: SizeConfig().xMargin(context, 3.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Create a game',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig().textSize(context, 3.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _promptCategory() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig().xMargin(context, 5.0),
        right: SizeConfig().xMargin(context, 3.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Choose Category',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig().textSize(context, 2.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _allCategories({Function(String option) onSelect}) {
    final List<String> categoryNames = [
      "Math",
      "English",
      "HNG",
      "Science",
      "Art",
      "games"
    ];
    return Wrap(
        direction: Axis.horizontal,
        spacing: 16.0,
        children: List.generate(categoryNames.length, (index) {
          return GestureDetector(
            onTap: () {
              onSelect(categoryNames[index]);
            },
            child: Chip(
              backgroundColor: Color(0xFF38208C),
              label: Text(
                categoryNames[index],
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig().textSize(context, 2.2),
                ),
              ),
            ),
          );
        }));
  }

  Widget _logoText() {
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
            text: 'Quick',
            style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig().textSize(context, 3),
                color: Colors.white)),
        TextSpan(
            text: 'Think',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: SizeConfig().textSize(context, 3),
              color: Color.fromRGBO(24, 197, 217, 1),
            ))
      ]),
    );
  }

  Widget _userName() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig().xMargin(context, 5.0),
        right: SizeConfig().xMargin(context, 3.0),
      ),
      child: TextFormField(
        controller: userNameController,
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: SizeConfig().textSize(context, 3),
            color: Colors.white),
        validator: (val) {
          if (val.length == 0) {
            return 'Quiz Name Should Not Be Empty';
          }
          if (val.length <= 2) {
            return 'should be 3 or more characters';
          }
          if (!RegExp(r"^[a-z0-9A-Z_-]{3,16}$").hasMatch(val)) {
            return "can only include _ or -";
          }

          return null;
        },
        onSaved: (val) => userName = val,
        decoration: InputDecoration(
          hintText: 'Enter your username',
          hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig().textSize(context, 2),
              color: Colors.white),
          contentPadding: EdgeInsets.fromLTRB(14.0, 12.0, 0.0, 12.0),
          fillColor: Color.fromRGBO(87, 78, 118, 1),
          filled: true,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromRGBO(24, 197, 217, 1), width: 1.0),
              borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  Widget _quizCode() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig().xMargin(context, 2.0),
        right: SizeConfig().xMargin(context, 2.0),
      ),
      child: TextFormField(
        enabled: false,
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: SizeConfig().textSize(context, 3),
            color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig().textSize(context, 2),
              color: Colors.black),
          contentPadding: EdgeInsets.fromLTRB(14.0, 12.0, 0.0, 12.0),
          fillColor: Color(0xFFDADADA),
          filled: true,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromRGBO(24, 197, 217, 1), width: 1.0),
              borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return RaisedButton(
      padding: EdgeInsets.fromLTRB(70, 20, 70, 20),
      onPressed: onPressed,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: Color.fromRGBO(24, 197, 217, 1),
      highlightColor: Color.fromRGBO(24, 197, 217, 1),
      child: Text('Create Game',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: SizeConfig().textSize(context, 2),
              color: Colors.white)),
    );
  }

  void onPressed() async {
    var form = _formKey.currentState;
    if (form.validate() && category != null) {
      form.save();

      hintText = await getCode(userName, category);
    }
    userNameController.clear();
    category = null;
  }

  showQuizCodeBottomSheet(BuildContext context) {
    var radius = Radius.circular(10);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: radius, topRight: radius)),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(22),
          height: 269,
          child: Column(
            children: <Widget>[
              smallLine(),
              SizedBox(height: 25),
              Row(
                children: <Widget>[
                  Text(
                    "Game Code",
                    style: GoogleFonts.poppins(
                      color: light ? Color(0xff1C1046) : Colors.white,
                      fontSize: SizeConfig().textSize(context, 2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 21),
              _quizCode(),
              // why not use screen util
              SizedBox(height: 30),
              SizedBox(
                width: double.maxFinite,
                height: 45,
                child: RaisedButton(
                  color: Color(0xff18C5D9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    ClipboardManager.copyToClipBoard(hintText);
                  },
                  child: Text(
                    "Copy",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget smallLine() {
    return Container(
      height: 3,
      width: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: light ? Color(0xff1C1046) : Colors.white,
      ),
    );
  }
}
