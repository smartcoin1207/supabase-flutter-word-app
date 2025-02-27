import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../utils/responsive.dart';
import 'components/signup_form.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Responsive(
            mobile: MobileSignupScreen(),
            desktop: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
                        child: SignUpForm(),
                      ),
                      SizedBox(height: defaultPadding / 2),
                      // SocalSignUp()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: SignUpForm(),
            ),
            Spacer(),
          ],
        ),
        // const SocalSignUp()
      ],
    );
  }
}
