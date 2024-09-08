import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:vfarm/home.dart';
import '../theme.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/primary_button.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import 'package:firebase_auth/firebase_auth.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  String verificationId;

  OtpVerificationScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
  }) : super(key: key);

  @override
  _VerifyTokenState createState() => _VerifyTokenState();
}

class _VerifyTokenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  String otp = "";
  bool canResend = false;
  Timer? _timer;
  int _countdown = 30;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void resendOtp(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);

    pd.show(max: 100, msg: 'Resending OTP...');

    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+91' + widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          pd.close();
          Fluttertoast.showToast(
            msg: 'Failed to resend OTP. Please try again.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          pd.close();
          Fluttertoast.showToast(
            msg: 'OTP Resent Successfully.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          widget.verificationId = verificationId;
          setState(() {
            _countdown = 30;
            canResend = false;
          });
          startTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          pd.close();
          Fluttertoast.showToast(
            msg: 'Unable to send OTP!!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
        timeout: const Duration(seconds: 60), // Timeout for code to be sent
        forceResendingToken: null, // Not needed if resending is manual
      );
    } catch (e) {
      pd.close();
      Fluttertoast.showToast(
        msg: 'Failed to resend OTP. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _verifyOTP(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Verifying OTP...');
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      // Sign in with the credential
      await auth.signInWithCredential(credential);

      // Map<String, dynamic> data = {
      //   "mobile": widget.phoneNumber.replaceAll(" ", ""),
      //   "fcm": DataController.instance.fcm,
      // };

      // String jsonString = jsonEncode(data);

      // try {
      //   Uri regUrl = Uri.parse("${dotenv.env['API_URL']}/registerUser");
      //   final response = await http.post(
      //     regUrl,
      //     headers: <String, String>{
      //       'Content-Type': 'application/json; charset=UTF-8',
      //     },
      //     body: jsonString,
      //   );
      //   if (response.statusCode == 200) {
      //     print("Helloo");
      //     Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      //     String key = jsonResponse['key'];
      //     Map<String, dynamic> updateData = {
      //       'phone': widget.phoneNumber.replaceAll(" ", ""),
      //       'key': key,
      //     };
      //     fetchData(widget.phoneNumber.replaceAll(" ", ""), key);
      //     print(updateData);
      //     await databaseHelper.updatePhone(1, updateData);
      //   } else {
      //     throw Exception('Some error occured..');
      //   }
      // } on IOException catch (e) {
      //   print("Error : $e");
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ErrorScreen(
      //           errorMessage:
      //               'Internet Error: Please check your network connection'),
      //     ),
      //   );
      // } catch (e) {
      //   print('Error: $e');
      //   navigateToErrorScreen("Failed to verify.. Please try again..");
      // }

      pd.close();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } catch (e) {
      pd.close();
      Fluttertoast.showToast(
        msg: 'Invalid OTP. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Error verifying OTP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Disable back button press
      onWillPop: () async => false,
      child: Scaffold(
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image (Centered)

                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OTP Verification",
                          style: heading2.copyWith(color: textBlack),
                        ),
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/accent.png',
                          width: 99,
                          height: 4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    OTPTextField(
                      fieldWidth: 50,
                      fieldStyle: FieldStyle.box,
                      length: 6,
                      keyboardType: TextInputType.number,
                      width: MediaQuery.of(context).size.width,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      textFieldAlignment: MainAxisAlignment.spaceBetween,
                      onChanged: (pin) {
                        otp = pin;
                      },
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '00:${_countdown.toString()}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Didn't receive OTP?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            canResend
                                ? InkWell(
                                    onTap: () {
                                      resendOtp(context);
                                    },
                                    child: const Text(" Resend"))
                                : const Text(
                                    " Resend",
                                    style: TextStyle(color: Colors.grey),
                                  )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    CustomPrimaryButton(
                      buttonColor: primaryBlue,
                      textValue: 'Verify OTP',
                      textColor: Colors.white,
                      onPressed: () async {
                        _verifyOTP(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
