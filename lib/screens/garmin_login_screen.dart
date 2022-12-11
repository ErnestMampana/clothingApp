// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:hope_with_every_step/hwes_tracker/backend/services/user_service.dart';
// import 'package:hope_with_every_step/hwes_tracker/frontend/components/circle_back_button.dart';
// import 'package:hope_with_every_step/hwes_tracker/frontend/components/color.dart';
// import 'package:hope_with_every_step/hwes_tracker/frontend/components/global_ui.dart';
// import 'package:hope_with_every_step/hwes_tracker/frontend/widgets/bs.rounded_button.dart';
// import 'package:hope_with_every_step/hwes_tracker/frontend/widgets/widget_helper.dart';
// import 'package:hope_with_every_step/hwes_tracker/backend/constants.dart';
// import 'package:oauth1/oauth1.dart' as OAuth1;
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// import '../../theme_constants.dart';

// class GarminConnectLoginScreen extends StatefulWidget {
//   @override
//   _GarminConnectLoginScreenState createState() =>
//       _GarminConnectLoginScreenState();
// }

// class _GarminConnectLoginScreenState extends State<GarminConnectLoginScreen> {
//   final flutterWebviewPlugin = FlutterWebviewPlugin();
//   final platform = new OAuth1.Platform(
//       'https://connectapi.garmin.com/oauth-service/oauth/request_token', // temporary credentials request
//       'https://connect.garmin.com/oauthConfirm', // resource owner authorization
//       'https://connectapi.garmin.com/oauth-service/oauth/access_token', // token credentials request
//       OAuth1.SignatureMethods.hmacSha1);
//   final String apiKey = '92576e3b-bfc6-41b6-9738-31f1bce40fa0';
//   final String apiSecret = 'UzD7YK72Urk9IkeSC8zMioAqgkVPYBKDCTf';
//   final UserService userService = UserService();
//   OAuth1.ClientCredentials clientCredentials;
//   OAuth1.Authorization auth;
//   OAuth1.AuthorizationResponse authorizationResponse;
//   final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
//   bool _loading = true;
//   bool _connectedToGarmin = false;
//   bool _showWebView = false;
//   String garminUrl;

//   String token;
//   String tokenSecret;

//   _GarminConnectLoginScreenState() {
//     clientCredentials = new OAuth1.ClientCredentials(apiKey, apiSecret);
//     auth = new OAuth1.Authorization(clientCredentials, platform);
//   }

//   @override
//   void dispose() {
//     flutterWebviewPlugin.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     init();

//     flutterWebviewPlugin.onUrlChanged.listen((url) {
//       // Look for Step 2 callback so that we can move to Step 3.
//       if (url.startsWith("com.auth0.movethenation")) {
//         final queryParameters = Uri.parse(url).queryParameters;
//         final oauthToken = queryParameters['oauth_token'];
//         final oauthVerifier = queryParameters['oauth_verifier'];
//         if (null != oauthToken && null != oauthVerifier) {
//           _garminConnectLoginFinished(oauthVerifier);
//         }
//       }
//     });
//   }

//   init() async {
//     var clientId = await secureStorage.read(key: clientKey);
//     var storedAccessToken = await secureStorage.read(key: 'access_token');
//     var storedTokenSecret = await secureStorage.read(key: 'token_secret');

//     if (storedAccessToken != null) {
//       var list = storedAccessToken.split("move");
//       if (list.length > 1 && list[1] == clientId) {
//         token = list[0];
//       }
//     }

//     if (storedTokenSecret != null) {
//       var list = storedTokenSecret.split("move");
//       if (list.length > 1 && list[1] == clientId) {
//         tokenSecret = list[0];
//       }
//     }

//     setState(() {
//       _connectedToGarmin = token != null && tokenSecret != null;
//       _loading = false;
//     });
//   }

//   Widget _body() {
//     return _connectedToGarmin
//         ? Column(
//             children: [
//               Container(
//                 child: Text("You are connected to Garmin",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontFamily: 'Metropolis',
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                     )),
//               ),
//               WidgetHelper.fixedSizedBox(20),
//               Center(
//                   child: Padding(
//                 padding: const EdgeInsets.all(50),
//                 child: BsRoundButton(
//                     color: COLORS.lime,
//                     width: ScreenUtil().setWidth(GlobalUI.width * 0.8),
//                     height: ScreenUtil().setHeight(GlobalUI.height * 0.08),
//                     label: "Logout",
//                     onPressed: () async {
//                       FocusScope.of(context).unfocus();
//                       secureStorage.delete(key: 'access_token');
//                       secureStorage.delete(key: 'token_secret');
//                       setState(() {
//                         this._connectedToGarmin = false;
//                       });
//                     }),
//               )),
//             ],
//           )
//         : _notConnectedWidget();
//   }

//   Widget _notConnectedWidget() {
//     return Column(
//       children: [
//         Text("You are NOT connect to Garmin",
//             style: TextStyle(
//               color: COLORS.black,
//               fontFamily: 'Metropolis',
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//             )),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
//           child: Center(
//             child: BsRoundButton(
//                 width: ScreenUtil().setWidth(GlobalUI.width * 0.8),
//                 height: ScreenUtil().setHeight(GlobalUI.height * 0.07),
//                 color: COLORS.white,
//                 label: "Connect to Garmin",
//                 onPressed: () async {
//                   FocusScope.of(context).unfocus();
//                   await _handleGarminConnect();
//                 }),
//           ),
//         ),
//       ],
//     );
//   }

//   // BsRoundButton(
//   //             width: ScreenUtil().setWidth(GlobalUI.width * 0.08),
//   //             height: ScreenUtil().setHeight(GlobalUI.height * 0.08),
//   //             label: "Connect to Garmin",
//   //             onPressed: () async {
//   //               FocusScope.of(context).unfocus();
//   //               await _handleGarminConnect();
//   //             },
//   //           )

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height -
//         AppBar().preferredSize.height -
//         MediaQuery.of(context).padding.top -
//         MediaQuery.of(context).padding.bottom;

//     return ScreenUtilInit(
//       designSize: Size(750, 1334),
//       builder: (context, widget) => _loading
//           ? WidgetHelper.statusIndicator(context)
//           : _showWebView
//               ? _buildWebView()
//               : Scaffold(
//                   body: Container(
//                     color: Colors.white,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(
//                               top: ScreenUtil().setWidth(86),
//                               bottom: ScreenUtil().setWidth(16),
//                               left: ScreenUtil().setWidth(26),
//                               right: ScreenUtil().setWidth(26)),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CircleBackButton(
//                                 iconColor: Colors.black,
//                               ),
//                               Expanded(child: SizedBox()),
//                               Center(
//                                 child: Text(
//                                   'Garmin Connect',
//                                   style: TextStyle(
//                                       fontFamily: GlobalUI.FONT_MEDIUM,
//                                       fontSize: GlobalUI.font24,
//                                       color: COLORS.black_2a),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(
//                                           ScreenUtil().setWidth(50.0)),
//                                       topRight: Radius.circular(
//                                           ScreenUtil().setWidth(50.0))),
//                                   color: COLORS.white,
//                                 ),
//                                 padding: EdgeInsets.only(
//                                   left: ScreenUtil().setWidth(38),
//                                   right: ScreenUtil().setWidth(38),
//                                   top: ScreenUtil().setWidth(10),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Expanded(
//                                       child: _buildBodyWidget(height),
//                                     ),
//                                     SizedBox(
//                                       height: ScreenUtil().setHeight(40),
//                                     ),
//                                   ],
//                                 ))),
//                       ],
//                     ),
//                   ),
//                 ),
//     );

//     // return SafeArea(
//     //     child: Theme(
//     //         data: ThemeData(
//     //           brightness: Brightness.dark,
//     //         ),
//     //         child: _loading
//     //             ? WidgetHelper.statusIndicator(context)
//     //             : _showWebView
//     //                 ? _buildWebView()
//     //                 : Scaffold(
//     //                     appBar: WidgetHelper.buildStandardAppBar(
//     //                         context, "Garmin Connect"),
//     //                     backgroundColor: backColor,
//     //                     body: _buildBodyWidget(height))));
//   }

//   Widget _buildBodyWidget(double height) {
//     return SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Container(
//           alignment: Alignment.center,
//           height: height * 0.7,
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(height: 80),
//                 Center(
//                   child: Image.asset(
//                       'assets/hwes_tracker/images/garminLogo.png',
//                       height: height * 0.1),
//                 ),
//                 SizedBox(height: 30),
//                 const SizedBox(height: 10.0),
//                 _body()
//               ]),
//         ));
//   }

//   Widget _buildWebView() {
//     return new WebviewScaffold(
//         url: garminUrl,
//         appBar: new AppBar(
//           leading: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CircleBackButton(
//               iconColor: COLORS.black,
//             ),
//           ),
//           backgroundColor: COLORS.white,
//           title: const Text(
//             'Germin Login',
//             style: TextStyle(color: COLORS.black),
//           ),
//         ),
//         //withZoom: true,
//         scrollBar: true,
//         resizeToAvoidBottomInset: false,
//         withLocalStorage: false,
//         hidden: true,
//         initialChild: WidgetHelper.statusIndicator(context));
//   }

//   _garminConnectLoginFinished(String oauthVerifier) async {
//     setState(() {
//       this._loading = true;
//     });
//     this.flutterWebviewPlugin.close();
//     assert(authorizationResponse != null);

//     try {
//       var result = await auth.requestTokenCredentials(
//           authorizationResponse.credentials, oauthVerifier);

//       var clientId = await secureStorage.read(key: clientKey);
//       secureStorage.write(
//           key: 'access_token',
//           value: "${result.credentials.token}move$clientId");
//       secureStorage.write(
//           key: 'token_secret',
//           value: "${result.credentials.tokenSecret}move$clientId");
//       token = result.credentials.token;
//       tokenSecret = result.credentials.tokenSecret;

//       await userService.saveGarminInfo(
//           clientId, result.credentials.token, result.credentials.tokenSecret);

//       print(result.credentials.toJSON());
//       setState(() {
//         _loading = false;
//         _connectedToGarmin = true;
//         _showWebView = false;
//       });
//     } catch (e) {
//       setState(() {
//         _loading = false;
//         _connectedToGarmin = false;
//         _showWebView = false;
//       });

//       return e.toString();
//     }
//   }

//   _handleGarminConnect() async {
//     setState(() {
//       _loading = true;
//     });

//     authorizationResponse = await auth.requestTemporaryCredentials('oob');
//     garminUrl = auth.getResourceOwnerAuthorizationURI(
//         authorizationResponse.credentials.token);
//     setState(() {
//       _loading = false;
//       _showWebView = true;
//     });
//   }
// }
