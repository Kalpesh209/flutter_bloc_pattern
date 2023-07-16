import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mavencliq/Bloc/Mentee/Auth/bloc/mentee_auth_bloc.dart';

import 'package:mavencliq/Bloc/Mentor/Auth/SignUp/bloc/mentor_auth_bloc.dart';
import 'package:mavencliq/Presentation/Screens/Mentee/Screens/Auth/CheckMail/mentee_check_your_mail_screen.dart';
import 'package:mavencliq/Presentation/Screens/Mentor/Auth/CheckMail/check_your_mail_screen.dart';
import 'package:mavencliq/Presentation/Screens/Mentor/Auth/SignIn/sign_in_screen.dart';
import 'package:mavencliq/Presentation/Screens/Mentor/widgets/bottom_navigation_bar_widget.dart';
import 'package:mavencliq/Presentation/Screens/Mentor/widgets/text_button_widget.dart';
import 'package:mavencliq/Presentation/Screens/Mentor/widgets/text_form_field_widget.dart';

import 'package:mavencliq/Ui_Config/app_utilities.dart';
import 'package:mavencliq/Ui_Config/app_colors.dart';
import 'package:mavencliq/Ui_Config/app_images.dart';
import 'package:mavencliq/Ui_Config/app_string.dart';
import 'package:mavencliq/Ui_Config/text_style.dart';
import 'package:flutter/gestures.dart';

class MenteeForgotPasswordScreen extends StatefulWidget {
  const MenteeForgotPasswordScreen({super.key});

  @override
  State<MenteeForgotPasswordScreen> createState() =>
      _MenteeForgotPasswordScreenState();
}

class _MenteeForgotPasswordScreenState
    extends State<MenteeForgotPasswordScreen> {
  TextEditingController menteeEmailController = TextEditingController();
  GlobalKey<FormState> menteeFormKey = GlobalKey<FormState>();
  late MenteeAuthBloc menteeAuthBloc;
  String errorMsg = '';

  onBackButtonTap() {
    Navigator.pop(context);
  }

  void _removeFocus() {
    AppUtilities(context).dismissKeyboard();
  }

  onSubmitButtonTap() {
    _removeFocus();
    String emailTxt = menteeEmailController.text;
    final bool? isValid = menteeFormKey.currentState?.validate();
    print('LINE 51 : $isValid');
    if (isValid == true) {
      menteeAuthBloc.add(MenteeForgotPasswordEvent(emailTxt));
    } else {
      print('LINE 61 : $isValid');
    }
  }

  navigateToBottomNavigationWidget() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          return BottomNavigationBarWidget();
        },
      ),
      (route) => false,
    );
  }

  navigateToSignInScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SignInScreen();
        },
      ),
    );
  }

  navigateToCheckMailScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MenteeCheckYourMailScreen();
        },
      ),
    );
  }

  @override
  void initState() {
    menteeAuthBloc = BlocProvider.of<MenteeAuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.kWhiteColor,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<MenteeAuthBloc, MenteeAuthState>(
        listener: (context, state) {
          if (state is MenteeForgotPasswordCompletedState) {
            menteeEmailController.clear();
            errorMsg = '';
            AppUtilities(context).showTextSnackBar(state.response.message);
            navigateToCheckMailScreen();
          } else if (state is MenteeForgotPasswordFailedState) {
            errorMsg = state.response.message;
          }
        },
        builder: (context, state) {
          if (state is MenteeForgotPasswordLoadingState) {
            return SizedBox(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.kPrimaryColor,
                ),
              ),
            );
          } else {
            return formData();
          }
        },
      ),
    );
  }

  Widget formData() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Form(
          key: menteeFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60.h,
              ),
              GestureDetector(
                onTap: () {
                  onBackButtonTap();
                },
                child: Image.asset(
                  AppImages.icBack,
                  height: 20,
                  width: 20,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                'MENTEE ${AppString.forgotPass}',
                style: MavenTextStyles.bitterSemiBold.copyWith(
                  fontSize: 22.sp,
                  color: AppColors.kWelcomeBackColor,
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                AppString.provideDetails,
                style: MavenTextStyles.nunitoRegular.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.ksignInColor,
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              // Error
              Text(
                errorMsg,
                style: MavenTextStyles.nunitoRegular.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.kServerErrorColor,
                ),
              ),

              SizedBox(
                height: 30.h,
              ),
              Text(
                AppString.emailAdd,
                style: MavenTextStyles.nunitoSemiBold.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.kBlackColor,
                ),
              ),
              SizedBox(
                height: 6.5.h,
              ),
              TextFormFieldWidget(
                controller: menteeEmailController,
                isPasswordField: false,
                inputAction: TextInputAction.next,
                onFieldSubmitted: (value) {},
                validator: (val) {
                  if (val == null || val == "" || val.trim().isEmpty) {
                    return AppUtilities(context)
                        .showTextSnackBar('* Email Required');
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(val)) {
                    return AppUtilities(context)
                        .showTextSnackBar('* Invalid Email Address');
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),

              SizedBox(
                height: 31.h,
              ),
              TextButtonWidget(
                onButtonTap: () {
                  onSubmitButtonTap();
                },
                btnTxt: AppString.submit,
              ),
              SizedBox(
                height: 12.h,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: AppString.rememberPass,
                    style: MavenTextStyles.nunitoRegular.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.ksignInColor,
                    ),
                    children: [
                      TextSpan(
                        text: AppString.signIn,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigateToSignInScreen();
                          },
                        style: MavenTextStyles.nunitoBold.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.kSelectedTabColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBarWidget() {
    return AppBar(
      backgroundColor: AppColors.kWhiteColor,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: GestureDetector(
          onTap: () {
            onBackButtonTap();
          },
          child: Image.asset(
            AppImages.icBack,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
