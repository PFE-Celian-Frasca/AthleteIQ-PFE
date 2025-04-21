import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/models/user/user_model.dart';
import 'package:athlete_iq/providers/auth/auth_provider.dart';
import 'package:athlete_iq/providers/global/global_provider.dart';
import 'package:athlete_iq/providers/user/user_provider.dart';
import 'package:athlete_iq/resources/components/Button/CustomElevatedButton.dart';
import 'package:athlete_iq/resources/components/InputField/CustomInputField.dart';
import 'package:athlete_iq/resources/components/InputField/CustomPasswordField.dart';
import 'package:athlete_iq/services/user_service.dart';
import 'package:unicons/unicons.dart';

final genderProvider =
    StateNotifierProvider<GenderNotifier, String>((ref) => GenderNotifier());

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

    final loading = ref.watch(authProvider.select(
        (state) => state.maybeWhen(orElse: () => false, loading: () => true)));

    useEffect(() {
      void validateForm() =>
          formValid.value = _formKey.currentState?.validate() ?? false;

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
    }, [
      emailController,
      passwordController,
      confirmPasswordController,
      pseudoController
    ]);

    useEffect(() {
      void checkPseudoExistence() async {
        if (pseudoController.text.isNotEmpty) {
          pseudoExistsNotifier.value = await ref
              .read(userServiceProvider)
              .checkPseudoExists(pseudoController.text.trim().toLowerCase());
        }
      }

      pseudoController.addListener(checkPseudoExistence);
      return () => pseudoController.removeListener(checkPseudoExistence);
    }, [pseudoController]);

    void register() async {
      if (formValid.value && pseudoExistsNotifier.value == false) {
        try {
          final signup = await ref.read(authProvider.notifier).signUp(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
          if (!signup) return;
          String userID = ref.read(globalProvider.select((state) => state
              .authState
              .maybeWhen(orElse: () => "", authenticated: (user) => user.uid)));
          final newUser = UserModel(
              id: userID,
              pseudo: pseudoController.text.trim().toLowerCase(),
              email: emailController.text.trim(),
              sex: ref.watch(genderProvider),
              createdAt: DateTime.now());
          final userCreated =
              await ref.read(userProvider.notifier).createUserProfile(newUser);
          if (userCreated) {
            GoRouter.of(context).go("/verify-email");
          }
        } catch (e) {
          return;
        }
      }
    }

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
                          icon: Icons.account_circle_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a pseudo';
                            }
                            if (pseudoExistsNotifier.value == true) {
                              return 'Pseudo already exists';
                            }
                            return null;
                          }),
                      CustomInputField(
                          controller: emailController,
                          label: "Email",
                          context: context,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          icon: UniconsLine.envelope_alt,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (!RegExp(
                                    r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          }),
                      CustomPasswordField(
                          controller: passwordController,
                          label: "Password",
                          context: context,
                          isObscure: !passwordVisible.value,
                          toggleObscure: () =>
                              passwordVisible.value = !passwordVisible.value),
                      CustomPasswordField(
                          controller: confirmPasswordController,
                          label: "Confirm Password",
                          context: context,
                          isObscure: !confirmPasswordVisible.value,
                          toggleObscure: () => confirmPasswordVisible.value =
                              !confirmPasswordVisible.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm the password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          }),
                      _buildGenderSelector(context, ref),
                      SizedBox(height: 20.h),
                      ValueListenableBuilder<bool>(
                        valueListenable: formValid,
                        builder: (context, valid, child) {
                          return CustomElevatedButton(
                            icon: loading
                                ? null
                                : Icons.person_add_alt_1_outlined,
                            onPressed: register,
                            text: loading ? null : "Créer un compte",
                            loadingWidget: loading
                                ? CircularProgressIndicator(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background)
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
    var genderNotifier = ref.watch(genderProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: Text("Select Gender:",
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: theme.colorScheme.onBackground)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ["Male", "Female", "Non-binary"]
                .map((gender) => genderButton(
                    gender,
                    gender == "Male"
                        ? Icons.male
                        : gender == "Female"
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

  Widget genderButton(
      String gender, IconData icon, BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: ref.watch(genderProvider) == gender
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
            color: ref.watch(genderProvider) == gender
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.3),
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
        const Text("Already have an account?"),
        TextButton(
            onPressed: () => GoRouter.of(context).go("/login"),
            child: const Text("Log in")),
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
                bottomRight: Radius.circular(35.r),
                bottomLeft: Radius.circular(35.r)),
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
                Text('Créez un compte pour continuer,',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.7))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
