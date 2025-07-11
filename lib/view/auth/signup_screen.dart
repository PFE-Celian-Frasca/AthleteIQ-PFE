import 'package:athlete_iq/repository/user/user_repository.dart';
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

final genderProvider = StateNotifierProvider<GenderNotifier, String>((ref) => GenderNotifier());

class GenderNotifier extends StateNotifier<String> {
  GenderNotifier() : super('Male');

  void setGender(String gender) {
    state = gender;
  }
}

class SignupScreen extends HookConsumerWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pseudoExistsNotifier = useState<bool?>(null);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final pseudoController = useTextEditingController();
    final passwordVisible = useState<bool>(false);
    final confirmPasswordVisible = useState<bool>(false);
    final formValid = useState<bool>(false);

    final authController = ref.read(authControllerProvider.notifier);
    final isLoading = ref.watch(authControllerProvider);

    useEffect(() {
      void validateForm() => formValid.value = _formKey.currentState?.validate() ?? false;

      emailController.addListener(validateForm);
      passwordController.addListener(validateForm);
      confirmPasswordController.addListener(validateForm);
      pseudoController.addListener(validateForm);

      return () {
        emailController.removeListener(validateForm);
        passwordController.removeListener(validateForm);
        confirmPasswordController.removeListener(validateForm);
        pseudoController.removeListener(validateForm);
      };
    }, [emailController, passwordController, confirmPasswordController, pseudoController]);

    Future<void> register() async {
      if (_formKey.currentState!.validate() && pseudoExistsNotifier.value == false) {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        final pseudo = pseudoController.text.trim().toLowerCase();
        final sex = ref.read(genderProvider);
        await authController.signUp(email: email, password: password, pseudo: pseudo, sex: sex);
      }
    }

    void checkPseudoExists() async {
      final pseudo = pseudoController.text.trim().toLowerCase();
      final exists = await ref.read(userRepositoryProvider).checkIfPseudoExist(pseudo);
      pseudoExistsNotifier.value = exists;
      _formKey.currentState?.validate(); // Re-validate the form
    }

    useEffect(() {
      pseudoController.addListener(checkPseudoExists);
      return () {
        pseudoController.removeListener(checkPseudoExists);
      };
    }, [pseudoController]);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomInputField(
                          controller: pseudoController,
                          label: "Pseudo",
                          context: context,
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          icon: Icons.account_circle_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez un pseudo';
                            }
                            if (pseudoExistsNotifier.value == true) {
                              return 'Ce pseudo est déjà pris';
                            }
                            return null;
                          }),
                      CustomInputField(
                          controller: emailController,
                          label: "Email",
                          context: context,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          icon: UniconsLine.envelope_alt,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez une adresse email';
                            }
                            if (!RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                                .hasMatch(value)) {
                              return 'Entrez une adresse email valide';
                            }
                            return null;
                          }),
                      CustomPasswordField(
                          controller: passwordController,
                          label: "Mot de passe",
                          context: context,
                          isObscure: !passwordVisible.value,
                          toggleObscure: () => passwordVisible.value = !passwordVisible.value),
                      CustomPasswordField(
                          controller: confirmPasswordController,
                          label: "Confirmer le mot de passe",
                          context: context,
                          isObscure: !confirmPasswordVisible.value,
                          toggleObscure: () =>
                              confirmPasswordVisible.value = !confirmPasswordVisible.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez votre mot de passe';
                            }
                            if (value != passwordController.text) {
                              return 'Les mots de passe ne correspondent pas';
                            }
                            return null;
                          }),
                      _buildGenderSelector(context, ref),
                      SizedBox(height: 20.h),
                      ValueListenableBuilder<bool>(
                        valueListenable: formValid,
                        builder: (context, valid, child) {
                          return CustomElevatedButton(
                            icon: isLoading ? null : Icons.person_add_alt_1_outlined,
                            onPressed: valid && !isLoading ? register : null,
                            text: isLoading ? null : "Créer un compte",
                            loadingWidget: isLoading
                                ? CircularProgressIndicator(
                                    color: Theme.of(context).colorScheme.surface)
                                : null,
                            backgroundColor: valid
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).disabledColor,
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildLoginOption(context),
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

  Widget _buildGenderSelector(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: Text('Genre:',
              style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Male', 'Female', 'Non-binary']
                .map((gender) => genderButton(
                    gender,
                    gender == 'Male'
                        ? Icons.male
                        : gender == 'Female'
                            ? Icons.female
                            : Icons.transgender,
                    context,
                    ref))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget genderButton(String gender, IconData icon, BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: ref.watch(genderProvider) == gender
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
            color: ref.watch(genderProvider) == gender
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.3),
            width: 2),
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.colorScheme.onPrimary),
        onPressed: () => ref.read(genderProvider.notifier).setGender(gender),
      ),
    );
  }

  Widget _buildLoginOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Vous avez déjà un compte?'),
        TextButton(
            onPressed: () => GoRouter.of(context).go('/login'), child: const Text('Connexion')),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 0.3.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(35.r), bottomLeft: Radius.circular(35.r)),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 20.h, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/logo.png", height: 0.15.sh),
                Text('Bienvenue',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                Text('Creez un compte pour continuer',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
