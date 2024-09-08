import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:vfarm/otp.dart';
import 'package:vfarm/theme.dart';
import 'package:vfarm/widgets/primary_button.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? verificationId;
  String agreeError = "";
  bool agreeTerms = false;
  bool isButtonEnabled = false;
  ProgressDialog? pd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Enter Your Phone Number",
                        style: heading2.copyWith(color: textBlack),
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        'assets/accent.png',
                        width: 99,
                        height: 4,
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                print(number
                                    .phoneNumber); // This already includes the country code
                              },
                              inputDecoration: InputDecoration(
                                hintText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                                leadingPadding: 8,
                                trailingSpace: false,
                                showFlags: true,
                                setSelectorButtonAsPrefixIcon: true,
                              ),
                              ignoreBlank: false,
                              selectorTextStyle: TextStyle(
                                color: const Color.fromARGB(255, 104, 45, 45),
                              ),
                              textFieldController: phoneController,
                              countries: ['IN'],
                              formatInput: true,
                              keyboardType: TextInputType.phone,
                              initialValue: PhoneNumber(isoCode: 'IN'),
                            ),
                            SizedBox(height: 30),
                            CheckBoxFormFieldWithErrorMessage(
                              labelText:
                                  'I agree to the Terms & Conditions and Privacy Policy',
                              isChecked: agreeTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  agreeTerms = value ?? false;
                                  isButtonEnabled = agreeTerms;
                                });
                              },
                              validator: (value) {
                                if (!agreeTerms) {
                                  return 'This field must be checked';
                                }
                                return null;
                              },
                              error: agreeError,
                            ),
                            SizedBox(height: 30),
                            CustomPrimaryButton(
                              buttonColor:
                                  isButtonEnabled ? primaryBlue : Colors.grey,
                              textValue: 'Register',
                              textColor: Colors.white,
                              onPressed: isButtonEnabled
                                  ? () async {
                                      if (formKey.currentState!.validate() &&
                                          agreeTerms) {
                                        String phoneNumber =
                                            phoneController.text;
                                        await phoneSignIn(
                                            phoneNumber: '+91' + phoneNumber);
                                      } else {
                                        setState(() {
                                          agreeError =
                                              'You must agree to proceed';
                                        });
                                      }
                                    }
                                  : () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    pd = ProgressDialog(context: context);
    pd!.show(max: 100, msg: 'Sending OTP...');

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) {}

  _onVerificationFailed(FirebaseAuthException exception) {
    pd!.close();
    showMessage("Error occured : $exception");
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    pd!.close();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationScreen(
          phoneNumber: phoneController.text,
          verificationId: verificationId,
        ),
      ),
    );
  }

  _onCodeTimeout(String timeout) {
    pd!.close();
    return null;
  }

  void showMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () async {
                Navigator.of(builderContext).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    pd?.close();
    super.dispose();
  }
}

class CheckBoxFormFieldWithErrorMessage extends StatelessWidget {
  final String labelText;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final FormFieldValidator<bool>? validator;
  final String error;

  CheckBoxFormFieldWithErrorMessage({
    required this.labelText,
    required this.isChecked,
    required this.onChanged,
    required this.validator,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: isChecked,
      validator: validator,
      builder: (FormFieldState<bool> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: onChanged,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'I agree to the ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchURL(
                                  'https://lfcwala.com/store/policies/terms-and-conditions');
                            },
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchURL(
                                  'https://lfcwala.com/store/policies/privacy-policy');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 12.0,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
