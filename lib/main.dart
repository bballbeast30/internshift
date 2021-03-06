import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:internshift/functions/auth.dart';

import 'package:internshift/pages/navigationbarmainpages/notificationspage.dart';
import 'package:internshift/pages/navigationbarmainpages/savedopenings.dart';
import 'package:internshift/pages/signin.dart';
import 'package:internshift/widgets.dart';
import 'constants.dart';
import 'functions/functions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'functions/helperfunctions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InternShift',
      home: userIsLoggedIn ? MainPage() : SignInPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  final String userName;

  MainPage({this.userName});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1;

  final _children = [
    Saved(),
    HomePage(),
    NotificationsPage(
      username: "djje",
    ),
  ];
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  String ifItIsABigDeviceHome() {
    if (MediaQuery.of(context).size.width > 500) {
      return "Home";
    } else {
      return "";
    }
  }

  String ifItIsABigDeviceSaved() {
    if (MediaQuery.of(context).size.width > 500) {
      return "Saved";
    } else {
      return "";
    }
  }

  String ifItIsABigDeviceNotifications() {
    if (MediaQuery.of(context).size.width > 500) {
      return "Notifications";
    } else {
      return "";
    }
  }

  bool forPDFIfThereIsBigScreen = false;
  void getScreenSizeAnddecideLinkLaunchingMethod() {
    if (MediaQuery.of(context).size.width > 600) {
      setState(() {
        forPDFIfThereIsBigScreen = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ProfileDrawer(
        userName: widget.userName,
      ),
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        actions: [
          Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(
                      // Icons.tune,
                      Icons.account_circle,
                      color: Color(0xff5FBA94),
                      size: 30,
                    ),
                  ),
                ),
              );
            },
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _children.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark,
                color: ColorPalette().bottomNavigationBarColor,
              ),
              label: ifItIsABigDeviceSaved()),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: Offset(1, 1),
                            color: Colors.grey[400]),
                      ],
                      color: Color(0xff5FBA94),
                      borderRadius: BorderRadius.circular(20)),
                ),
                Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 26,
                )
              ],
              alignment: Alignment.center,
            ),
            label: ifItIsABigDeviceHome(),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: ColorPalette().bottomNavigationBarColor,
              ),
              label: ifItIsABigDeviceNotifications()),
        ],
      ),
    );
  }
}

class TopRatedInternships extends StatelessWidget {
  final String nameOfJob;
  final String employer;
  final String employerLocation;
  final String logo;
  TopRatedInternships(
      {this.nameOfJob, this.employer, this.employerLocation, this.logo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appAddModalBottomSheet(
            context, nameOfJob, employer, employerLocation, logo);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: MediaQuery.of(context).size.width * 1 / 1.2,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 20),
              width: MediaQuery.of(context).size.width * 1 / 1.2,
              height: 100,
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 40.0, bottom: 10),
                  child: Image.network(logo, height: 45, width: 45),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      width: 200,
                      child: Text(
                        nameOfJob,
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xff06745A),
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 20,
                      ),
                    )
                  ]),
                  Text(
                    employer,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Color(0xff759E8B),
                      ),
                      Text(employerLocation,
                          style:
                              TextStyle(color: Color(0xff759E8B), fontSize: 14))
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  )
                ]),
              ]),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                    color: Colors.grey[200]),
              ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String username;
  HomePage({this.username});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool filterButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    double determineWidth() {
      if (MediaQuery.of(context).size.width >= 500) {
        return 414;
      } else {
        return MediaQuery.of(context).size.width * 1 / 1.1;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  returnGreeting(),
                  style: TextStyle(fontSize: 20, color: Color(0xff759E8B)),
                ),
              ),
              bigName(widget.username)
            ]),
            MainPageSearchBox(),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      filterButtonPressed = !filterButtonPressed;
                    });
                  },
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorPalette().themeColor),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Icon(
                                        Icons.filter_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Filter",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )),
                          ),
                          SizedBox(width: 100),
                          SizedBox(width: 100),
                        ]),
                  ),
                ),
              ),
            ),
            filterButtonPressed
                ? Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1 / 1.1,
                      height: 143,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 3,
                                spreadRadius: 0,
                                offset: Offset(0, 4),
                                color: Colors.grey[200]),
                          ],
                          color: Colors.white),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                filterButtonPressed = false;
                              });
                            }),
                      ),
                    ),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                width: determineWidth(),
                child: Center(
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
                      width: determineWidth(),
                      height: 275,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                spreadRadius: 0,
                                offset: Offset(0, 4),
                                color: Colors.grey[300]),
                          ],
                          gradient: LinearGradient(
                              colors: [Color(0xffFAFAFA), Color(0xffFAFAFA)])),
                    ),
                    Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5.0, left: 15),
                              child: Text(
                                'Featured Offers',
                                style: TextStyle(
                                    color: Color(0xff858585),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                      featuredOffers(0),
                      featuredOffers(1)
                    ])
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ViewAllTopRatedOffersButton(),
            ),
            NewListings(),
          ],
        ),
      ),
    );
  }
}

class ViewAllTopRatedOffersButton extends StatefulWidget {
  @override
  _ViewAllTopRatedOffersButtonState createState() =>
      _ViewAllTopRatedOffersButtonState();
}

class _ViewAllTopRatedOffersButtonState
    extends State<ViewAllTopRatedOffersButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(alignment: Alignment.center, children: [
        Container(
          width: MediaQuery.of(context).size.width * 1 / 1.1,
          height: 50,
          decoration: BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //       blurRadius: 3,
              //       spreadRadius: 0,
              //       offset: Offset(0, 4),
              //       color: Colors.grey[300]),
              // ],
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                  colors: [Color(0xffFAFAFA), Color(0xffFAFAFA)])),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'View All Featured Offers',
            style: TextStyle(color: Color(0xff858585)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.arrow_forward, color: Color(0xff858585)),
          )
        ])
      ]),
    );
  }
}

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        children: [Icon(Icons.filter), Text("Filter")],
      ),
    ));
  }
}

class ProfileDrawer extends StatefulWidget {
  final String userName;
  ProfileDrawer({this.userName});
  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  _launchURL() async {
    String url = pdfURLForWebUsers;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String pdfURLForWebUsers =
      "https://firebasestorage.googleapis.com/v0/b/internshift2020.appspot.com/o/Akhil_Resume.pdf?alt=media&token=d8f64e22-fa4c-4d56-a2f3-de106984d586";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document("akhilpeddikuppa")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            String firstName = snapshot.data['firstName'];
            String lastName = snapshot.data['lastName'];
            String email = snapshot.data['email'];
            String school = snapshot.data['school'];
            String age = snapshot.data['age'];

            String getFirstLetterOfFirstNameAndLastName() {
              String firstLetter = firstName[0];
              String lastLetter = lastName[0];
              return firstLetter + lastLetter;
            }

            return Drawer(
              child: ListView(padding: EdgeInsets.zero, children: [
                Stack(alignment: Alignment.center, children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 1 / 3.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: ColorPalette().themeColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      height: 175,
                      width: 175,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                          child: Text(getFirstLetterOfFirstNameAndLastName(),
                              style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: ColorPalette().themeColor))),
                    ),
                  )
                ]),
                ListTile(
                  title: Text(firstName + " " + lastName),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text("Age: " + age),
                ),
                ListTile(
                  title: Text(email),
                  leading: Icon(Icons.email),
                ),
                ListTile(
                  leading: Icon(Icons.school),
                  title: Text(school),
                ),
                ListTile(
                  leading: Icon(Icons.location_pin),
                  title: Text('Dallas, TX'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL();
                  },
                  leading: Icon(Icons.upload_file),
                  title: Text("View Your Resume"),
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Edit Profile Information"),
                  onTap: () {
                    // Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SettingsPage(
                    //               image:
                    //                   "https://cdn.icon-icons.com/icons2/2119/PNG/512/google_icon_131222.png",
                    //               userName: "user",
                    //               firstName: "firstName",
                    //               lastName: "lastName",
                    //               school: "TAG",
                    //               password: "password",
                    //               email: "aaoifjeiofj",
                    //             )));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Log Out"),
                  onTap: () {
                    AuthMethods().signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                ),
              ]),
            );
          }
        });
  }
}

Widget bigName(String username) {
  return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document('akhilpeddikuppa')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          String firstName = snapshot.data['firstName'];
          String lastName = snapshot.data['lastName'];
          return Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 50),
            child: Text(firstName + " " + lastName, style: titleTextStyle()),
          );
        }
      });
}

Widget featuredOffers(int index) {
  return StreamBuilder(
    stream: Firestore.instance.collection('featuredoffers').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      } else {
        String nameOfJob = snapshot.data.documents[index]['nameOfJob'];
        String employer = snapshot.data.documents[index]['employer'];
        String employerLocation =
            snapshot.data.documents[index]['employerLocation'];
        String logo = snapshot.data.documents[index]['logo'];
        return TopRatedInternships(
          nameOfJob: nameOfJob,
          employer: employer,
          employerLocation: employerLocation,
          logo: logo,
        );
      }
    },
  );
}

class OtherSearchPage extends StatefulWidget {
  final String val;

  OtherSearchPage({this.val});
  @override
  _OtherSearchPageState createState() => _OtherSearchPageState();
}

class _OtherSearchPageState extends State<OtherSearchPage> {
  TextEditingController otherTextEditingController =
      new TextEditingController();
  String name = "";

  void initState() {
    if (widget.val != null) {
      setState(() {
        name = widget.val.toLowerCase().trim();
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: ColorPalette().themeColor,
          ),
        ),
      ),
      body: Column(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 1 / 1.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: Offset(0, 4),
                          color: Colors.grey[200]),
                    ],
                    color: Colors.white),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8, right: 25, bottom: 8),
                        child: TextField(
                            cursorHeight: 20,
                            controller: otherTextEditingController,
                            onChanged: (value) {
                              setState(() {
                                name = value.toLowerCase();
                              });
                              print(value);
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusColor: ColorPalette().themeColor,
                                hoverColor: ColorPalette().themeColor,
                                fillColor: ColorPalette().themeColor,
                                icon: Icon(
                                  Icons.search,
                                  color: ColorPalette().themeColor,
                                ),
                                hintText: "Search offers",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none))),
                      ),
                    ),
                  ],
                )),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: name != "" && name != null
                  ? Firestore.instance
                      .collection('offers')
                      .where("searchKey", isEqualTo: name.substring(0, 1))
                      .snapshots()
                  : Firestore.instance.collection("offers").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, i) {
                        DocumentSnapshot rsnapshot = snapshot.data.documents[i];
                        return GestureDetector(
                          onTap: () {
                            appAddModalBottomSheet(
                                context,
                                rsnapshot.data['nameofoffer'],
                                rsnapshot.data['employer'],
                                rsnapshot.data['location'],
                                rsnapshot.data['logo']);
                          },
                          child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Column(children: [
                                  CircleAvatar(
                                      radius: 36,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          NetworkImage(rsnapshot.data['logo'])),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 10),
                                    child: Center(
                                      child: Container(
                                        width: 200,
                                        child: Text(
                                          rsnapshot.data["nameofoffer"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: ColorPalette().themeColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    rsnapshot.data['employer'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xffBDBDBD)),
                                  )
                                ]),
                              )),
                        );
                      },
                    ),
                  );
                }
                //     if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                // switch (snapshot.connectionState) {
                //   case ConnectionState.waiting:
                //     return new Text('Loading...');
                //   default:
                //     return new ListView(
                //       children:
                //           snapshot.data.documents.map((DocumentSnapshot document) {
                //         return new ListTile(
                //           title: new Text(document['nameofoffer']),
                //         );
                //       }).toList(),
                //     );
                //   }
              }),
        )
      ]),
    );
  }
}

class MainPageSearchBox extends StatefulWidget {
  @override
  _MainPageSearchBoxState createState() => _MainPageSearchBoxState();
}

class _MainPageSearchBoxState extends State<MainPageSearchBox> {
  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 1 / 1.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                      color: Colors.grey[200]),
                ],
                color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 8, right: 25, bottom: 8),
                    child: TextField(
                        cursorHeight: 20,
                        controller: searchController,
                        onSubmitted: (value) {
                          print(value);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtherSearchPage(
                                        val: value,
                                      )));
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusColor: ColorPalette().themeColor,
                            hoverColor: ColorPalette().themeColor,
                            fillColor: ColorPalette().themeColor,
                            icon: Icon(
                              Icons.search,
                              color: ColorPalette().themeColor,
                            ),
                            hintText: "Search offers",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none))),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
