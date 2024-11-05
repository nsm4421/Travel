part of 'index.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              (24.0).h,

              /// 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check,
                    size: 25,
                  ),
                  (12.0).w,
                  Text(
                    'Sign In',
                    style: context.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(flex: 2),

              /// 회원가입 양식
              const SignInFormFragment(),

              /// 로그인 버튼
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: SubmitButtonWidget(),
              ),

              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: DividerWidget(label: 'OR')),

              /// 회원가입 버튼
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: RouteToSignUpButtonWidget(),
              ),

              const Spacer()
            ],
          ),
          const CloseButtonWidget()
        ],
      ),
    );
  }
}