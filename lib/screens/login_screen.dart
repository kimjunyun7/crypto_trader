import 'package:crypto_trader/api_key.dart';
import 'package:crypto_trader/models/market_model.dart';
import 'package:crypto_trader/services/api_service.dart';
import 'package:crypto_trader/shared/user_secure_storage.dart';
import 'package:crypto_trader/utils/generate_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  final controllerAccessKey =
      TextEditingController(text: access_key + secret_key);

  final controllerSecretKey = TextEditingController();

  int inputValueLength = 40;

  @override
  void initState() {
    logIn(context);
    super.initState();
  }

  @override
  void dispose() {
    controllerAccessKey.dispose();
    controllerSecretKey.dispose();
    super.dispose();
  }

  Future logIn(BuildContext context) async {
    // /// 인풋 값 체크
    // final isValid = _formKey.currentState!.validate();
    // if (!isValid) return;

    // UtilsDialogs.showIndicatorDialog(context);

    String tempAccessKey =
        controllerAccessKey.text.substring(0, inputValueLength);
    String tempSecretKey = controllerAccessKey.text.substring(inputValueLength);
    // log('access: $tempAccessKey\nsecret: $tempSecretKey');

    await UserSecureStorage.setAccessKey(tempAccessKey);
    await UserSecureStorage.setSecretKey(tempSecretKey);
    getJWTToken();
    // await UtilsDialogs.closeDialogNoReturn(context);
    context.goNamed('home');
  }

  Future<String> getJWTToken() async {
    return ApiServices().generateJWTToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("로그인"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controllerAccessKey,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "값 입력 바람";
                        }
                        if (controllerAccessKey.text.length <
                            inputValueLength) {
                          return "알맞은 길이의 값 입력 바람";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controllerSecretKey,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        // if (value != null && value.isEmpty) {
                        //   return "값 입력 바람";
                        // }
                        // return null;
                        null;
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () => logIn(context),
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
