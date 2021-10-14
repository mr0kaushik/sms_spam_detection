import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/presentation/styles.dart';
import 'package:sms_spam_detection/utils/SharedPrefrences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool _showSettingBtn = false;
  String _btnText = "Allow";
  bool _isAllAllowed = false;

  static final String permissionErrorSubtitle =
      "You have to allow the permission to continue";
  static final String permissionSubtitle = "Press Allow to grant permission";

  String subtitle = permissionSubtitle;

  List<Permission> permissions = [
    Permission.sms,
    Permission.phone,
    Permission.contacts
  ];

  askPermission() async {
//    final Permission permission = permissions[_currentPage];

    if (_isAllAllowed) {
      Navigator.of(context).pushReplacementNamed('/import');
      return;
    }

    if (await permissions[_currentPage].status.isGranted) {
      moveNextPage();
    } else {
      PermissionStatus status = await permissions[_currentPage].request();
      handlePermissionStatus(status);
    }
  }

  void moveNextPage() {
    if (mounted) {
      setState(() {
        _showSettingBtn = false;
        subtitle = permissionSubtitle;
      });
    }
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      if (mounted) {
        setState(() {
          _isAllAllowed = true;
          _btnText = "Finish";
        });
      }
    }
  }

  void handlePermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        moveNextPage();
        if (_currentPage == 2) {
          //TODO MOVE TO IMPORT
        }
        break;
      case PermissionStatus.denied:
        if (mounted) {
          setState(() {
            subtitle = permissionErrorSubtitle;
          });
        }
        break;
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        if (mounted) {
          setState(() {
            subtitle = permissionErrorSubtitle;
            _showSettingBtn = true;
          });
        }
        break;
    }
  }

  Future<bool> isPermissionAllowed(Permission permission) async {
    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    isAlreadyImported();
    super.initState();
  }

  void isAlreadyImported() async {
    bool value = await SharedPref.isMessageImported();
    if (value) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  List<String> _imagePath = [
    'assets/images/sms.png',
    'assets/images/phone.png',
    'assets/images/contact.png'
  ];

  List<String> _titles = [
    "Need\nSMS Permission",
    "Need\nTelephone Permission",
    "Need\nContact Permission"
  ];

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  _getPageView(int position) {
    return Padding(
      padding: EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage(
                _imagePath[position],
              ),
              height: 200.0,
              width: 200.0,
            ),
          ),
          SizedBox(height: 50.0),
          Text(
            _titles[position],
            style: onBoardTitleStyle,
          ),
          SizedBox(height: 20.0),
          Text(
            subtitle,
            style: onBoardSubTitleStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 0.4, 0.6],
              colors: [
                MatColor.primaryLightColor,
                MatColor.primaryColor,
                MatColor.primaryDarkColor,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 40.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
//                        _pageController.nextPage(
//                          duration: Duration(milliseconds: 500),
//                          curve: Curves.ease,
//                        );
                      });
                    },
                    children: <Widget>[
                      _getPageView(0),
                      _getPageView(1),
                      _getPageView(2),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Visibility(
                      visible: _showSettingBtn,
                      child: OutlineButton(
                        borderSide:
                            BorderSide(width: 1.8, color: Colors.white70),
                        onPressed: () => openSetting(),
                        child: Container(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Go to Setting",
                                style: permissionFlatButtonStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: OutlineButton(
                          borderSide:
                              BorderSide(width: 1.8, color: Colors.white70),
                          onPressed: () => askPermission(),
                          child: Container(
                            height: 45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(_btnText,
                                    style: permissionFlatButtonStyle),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  openSetting() async {
    bool value = await openAppSettings();
  }
}
