import 'package:athlete_iq/resources/components/Button/custom_elevated_button.dart';
import 'package:athlete_iq/resources/components/InputField/custom_input_field.dart';
import 'package:athlete_iq/resources/components/InputField/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import 'package:athlete_iq/view/auth/auth_controller.dart';

class LoginScreen extends HookConsumerWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final isPasswordObscure = useState(true);
    final isValid = useState(false);
    final authController = ref.read(authControllerProvider.notifier);
    final isLoading = ref.watch(authControllerProvider);

    useEffect(() {
      void validateForm() {
        final formState = _formKey.currentState;
        isValid.value = formState?.validate() ?? false;
      }

      final List<TextEditingController> controllers = [emailController, passwordController];

      for (final controller in controllers) {
        controller.addListener(validateForm);
      }

      validateForm(); // Trigger validation initially

      return () {
        for (final controller in controllers) {
          controller.removeListener(validateForm);
        }
      };
    }, [emailController, passwordController]);

    void loginUser() async {
      if (_formKey.currentState!.validate()) {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        await authController.signIn(email: email, password: password);
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomInputField(
                        icon: UniconsLine.envelope_alt,
                        context: context,
                        label: "Email",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _emailValidator,
                      ),
                      CustomPasswordField(
                        context: context,
                        label: "Mot de passe",
                        controller: passwordController,
                        isObscure: isPasswordObscure.value,
                        toggleObscure: () => isPasswordObscure.value = !isPasswordObscure.value,
                        validator: _passwordValidator,
                      ),
                      _buildForgotPasswordButton(context),
                      ValueListenableBuilder<bool>(
                        valueListenable: isValid,
                        builder: (context, valid, child) => CustomElevatedButton(
                          icon: isLoading ? null : UniconsLine.signin,
                          onPressed: valid && !isLoading ? loginUser : null,
                          text: isLoading ? "Chargement..." : "Connexion",
                          loadingWidget: isLoading
                              ? CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.surface)
                              : null,
                          backgroundColor: valid && !isLoading
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                      _buildSignUpOption(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Veillez entrer votre email';
    if (!RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
      return 'Entrez une adresse email valide';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Entrez votre mot de passe';
    return null;
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 0.3.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(35.r),
              bottomLeft: Radius.circular(35.r),
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 20.h, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/logo.png", height: 0.15.sh),
                Text('Bienvenue,',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                Text('Connectez-vous pour continuer,',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => GoRouter.of(context).go("/forgot-password"),
        child: const Text("Mot de passe oublié?"),
      ),
    );
  }

  Widget _buildSignUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Vous n'avez pas de compte? "),
        TextButton(
          onPressed: () => GoRouter.of(context).go("/signup"),
          child: const Text("Inscription"),
        ),
      ],
    );
  }
}
