import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchman/edit_text.dart';


void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: const Color(0xFF456280),
      canvasColor: const Color(0xFF456280),
    ),
    home: const Home()
));

//AnimationController controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
class App {
  static Future init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
  }
}



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

final _editTextKey = GlobalKey<EditTextState>();


const String adminKey = 'admin';

class _HomeState extends State<Home> {
  /*
  int colorPrimary = 0xFF456280;
  int colorPrimaryDark = 0xFF2C3E50;
  int colorPrimaryLight = 0xFF5f86AD;
  int colorAccent = 0xFFF58E18;
  */

  setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(key) ?? false;
    return value;
  }




  static const platform = MethodChannel('sendSms');

  Future<void> sendSms(String number, String msg) async {
    try {
      await platform.invokeMethod('send',<String,dynamic>{"phoneNumber": number,"message": msg});
    } on PlatformException catch (e) {
      print(e);
    }
  }

  AlertDialog setUpDialog(context, String text) {
    return AlertDialog(
      backgroundColor: const Color(0xFF456280),
      elevation: 20.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))
      ),
      title: Text(
        text,
        style: const TextStyle(
            fontFamily: 'SansCondensed',
            color: Colors.white
        ),
      ),
      content: null,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text(
            "TAKAISIN",
            style: TextStyle(color: Color(0xFFF58E18)),
          ),
          style: TextButton.styleFrom(
            primary: Colors.black26,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text(
            "LÄHETÄ",
            style: TextStyle(color: Color(0xFFF58E18)),
          ),
          style: TextButton.styleFrom(
            primary: Colors.black26,
          ),
        ),
      ],
    );
  }





  Future<void> proceedToPage(int page) async {

    if (await getBool(adminKey)) {
      Navigator.pop(context);
      pageController.jumpToPage(page);
    } else {
      showDialog(
          context: context,
          builder: (_) => setUpAdminDialog(context),
          barrierDismissible: true
      ).then((exit) {
        Navigator.pop(context);
        if (exit) {
          pageController.jumpToPage(page);
        }
      });
    }
  }


  AlertDialog setUpAdminDialog(context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF456280),
      elevation: 20.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))
      ),
      title: const Text(
        'Anna pääkäyttäjän salasana',
        style: TextStyle(
            fontFamily: 'SansCondensed',
            color: Colors.white
        ),
      ),
      content: EditText(key: _editTextKey),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text(
            "PERUUTA",
            style: TextStyle(color: Color(0xFFF58E18)),
          ),
          style: TextButton.styleFrom(
            primary: Colors.black26,
          ),
        ),
        TextButton(
          onPressed: () {
            if (_editTextKey.currentState!.getText() == '2808') {
              setBool(adminKey, true);
              Navigator.pop(context, true);
            } else {
              Navigator.pop(context, false);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Ei käyttöoikeuksia muihin asetuksiin"),
              ));
            }
          },
          child: const Text(
            "OK",
            style: TextStyle(color: Color(0xFFF58E18)),
          ),
          style: TextButton.styleFrom(
            primary: Colors.black26,
          ),
        ),
      ],
    );
  }

  ElevatedButton setRegularButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFF58E18),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 3.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        primary: const Color(0xFF5f86AD), // <-- Button color
        onPrimary: Colors.white24, // <-- Splash color
      ),
    );
  }

  /*
  ElevatedButton setActionButton(int page, String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          actionPage = page;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SansCondensed',
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 1.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 3.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))
        ),
        padding: const EdgeInsets.all(20),
        primary: const Color(0xFF5f86AD), // <-- Button color
        onPrimary: Colors.white24, // <-- Splash color
      ),
    );
  }

   */

  Container pageChangePassword() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 90.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            alignment: Alignment.center,
            child: const Text(
              'Uusi salasana',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
          EditText(key: _editTextKey),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            alignment: Alignment.center,
            child: const Text(
              'Vahvista salasana',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              color: Colors.white,
            ),
            child: TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                ]
            ),
          ),
          setRegularButton('VAIHDA SALASANA')
        ],
      ),
    );
  }

  Container pageSetTime() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: const [
          Text(
            'page 2',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container pageAddUserNumber() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: const [
          Text(
            'page 3',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container pageSetThresholds() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: const [
          Text(
            'page 4',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /*
  AlertDialog dialog = AlertDialog(
    backgroundColor: const Color(0xFF456280),
    elevation: 20.0,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))
    ),
    title: const Text(
        'Haluatko varmasti lähettää kysely-teksiviestin?',
      style: TextStyle(
        fontFamily: 'SansCondensed',
          color: Colors.white
      ),
    ),
    content: null,
    actions: [
      TextButton(
        onPressed: () {},
        child: const Text(
          "TAKAISIN",
          style: TextStyle(color: Color(0xFFF58E18)),
        ),
        style: TextButton.styleFrom(
          primary: Colors.black26,
        ),
      ),
      TextButton(
        onPressed: () {

        },
        child: const Text(
          "LÄHETÄ",
          style: TextStyle(color: Color(0xFFF58E18)),
        ),
        style: TextButton.styleFrom(
          primary: Colors.black26,
        ),
      ),
    ],
  );

   */











  /*
  'Vaihda salasana'),
                setActionButton(1, 'Aseta aika'),
                setActionButton(2, 'Lisää käyttäjänumero'),
                setActionButton(3, 'Aseta hälytysrajat'
   */

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'WATCHMAN',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Syne',
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2C3E50),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2C3E50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Image(
                    image: AssetImage('assets/watchman_logo.png'),
                    width: 72,
                    height: 72,
                  ),
                  Text(
                    'ASETUKSET',
                    style: TextStyle(
                      color: Color(0xFFF58E18),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Syne',
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: ListTile(
                leading: const Icon(Icons.access_alarm, color: Colors.white, size: 36.0,),
                title: const Text(
                  'Aloitus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SansCondensed',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  pageController.jumpToPage(0);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: ListTile(
                leading: const Icon(Icons.access_alarm, color: Colors.white, size: 36.0,),
                title: const Text(
                  'Vaihda salasana',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SansCondensed',
                  ),
                ),
                onTap: () {
                  proceedToPage(1);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: ListTile(
                leading: const Icon(Icons.access_alarm, color: Colors.white, size: 36.0,),
                title: const Text(
                  'Aseta aika',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SansCondensed',
                  ),
                ),
                onTap: () {
                  proceedToPage(2);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: ListTile(
                leading: const Icon(Icons.access_alarm, color: Colors.white, size: 36.0,),
                title: const Text(
                  'Lisää käyttäjänumero',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SansCondensed',
                  ),
                ),
                onTap: () {
                  proceedToPage(3);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: ListTile(
                leading: const Icon(Icons.access_alarm, color: Colors.white, size: 36.0,),
                title: const Text(
                  'Aseta hälytysrajat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SansCondensed',
                  ),
                ),
                onTap: () {
                  proceedToPage(4);
                },
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        children: [
          Container(
            padding: const EdgeInsets.all(3.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'No status',
                        style: TextStyle(
                            fontSize: 48.0,
                            color: Colors.white38
                        ),
                      ),
                      Icon(
                        Icons.save,
                        size: 48.0,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(),
                      Column(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => setUpDialog(context, 'Haluatko varmasti lähettää komento-teksiviestin?'),
                              barrierDismissible: true
                          ).then((exit) {
                            if (exit) {
                              //here goes the action ->

                            }
                          });
                        },
                        child: const Icon(Icons.menu, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          elevation: 3.0,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          primary: const Color(0xFF00b000), // <-- Button color
                          onPrimary: Colors.black26, // <-- Splash color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (await Permission.sms.request().isGranted) {
                            showDialog(
                                context: context,
                                builder: (_) => setUpDialog(context, 'Haluatko varmasti lähettää komento-teksiviestin?'),
                                barrierDismissible: true
                            ).then((exit) async {
                              if (exit) {
                                //here goes the action ->
                                sendSms("+358509117983", "test message");
                              }
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Tekstiviestejä ei sallittu"),
                            ));
                          }


                        },
                        child: const Icon(Icons.menu, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          elevation: 3.0,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          primary: const Color(0xFFb00000), // <-- Button color
                          onPrimary: Colors.black26, // <-- Splash color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => setUpDialog(context, 'Haluatko varmasti lähettää kysely-teksiviestin?'),
                              barrierDismissible: true
                          ).then((exit) {
                            if (exit) {
                              //here goes the action ->

                            }
                          });
                        },
                        child: const Icon(Icons.menu, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          elevation: 3.0,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          primary: const Color(0xFFF58E18), // <-- Button color
                          onPrimary: Colors.black26, // <-- Splash color
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),
          /*
          Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                setActionButton(0, 'Vaihda salasana'),
                setActionButton(1, 'Aseta aika'),
                setActionButton(2, 'Lisää käyttäjänumero'),
                setActionButton(3, 'Aseta hälytysrajat'),
              ],
            ),
          ),
          */
          pageChangePassword(),
          pageSetTime(),
          pageAddUserNumber(),
          pageSetThresholds(),

    ],
      ),
    );
  }
}