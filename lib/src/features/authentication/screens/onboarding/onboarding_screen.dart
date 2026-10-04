import 'package:alphabet_green_energy/src/common_widgets/phone_number_field.dart';
import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/core/controllers/profile_controller.dart';
import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/dashboard.dart';
import 'package:alphabet_green_energy/src/repository/authentication_repository/authentication_repository.dart';
import 'package:alphabet_green_energy/src/repository/user_repository/user_repository.dart';
import 'package:alphabet_green_energy/src/utils/safe_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// First-login walkthrough, shown once right after an agent's account is
/// approved (AuthenticationRepository._setInitialScreen routes here instead
/// of Dashboard while UserModel.hasCompletedOnboarding is false). Covers the
/// Dashboard's three main actions, then ends on a profile-confirmation step
/// — the most important page, since it's the one chance to catch a wrong or
/// missing phone/email/name before the agent starts using the app day to
/// day. Existing Beneficiary and Profile get their own lighter, standalone
/// first-visit tips instead of being bundled in here (see first_visit_tip.dart).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  static const _infoPageCount = 4; // welcome + 3 feature slides

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  void _back() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // No back button to a screen that doesn't exist yet (this only ever
      // appears right after login, same reasoning as SetNewPasswordScreen).
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) => setState(() => _page = page),
                  children: const [
                    _InfoSlide(
                      icon: Icons.celebration_rounded,
                      title: aOnboardingWelcomeTitle,
                      message: aOnboardingWelcomeMessage,
                    ),
                    _InfoSlide(
                      icon: Icons.person_add_alt_rounded,
                      title: aOnboardingAddBeneficiaryTitle,
                      message: aOnboardingAddBeneficiaryMessage,
                    ),
                    _InfoSlide(
                      icon: Icons.fact_check,
                      title: aOnboardingSurveyTitle,
                      message: aOnboardingSurveyMessage,
                    ),
                    _InfoSlide(
                      icon: Icons.sd_storage,
                      title: aOnboardingLocalStorageTitle,
                      message: aOnboardingLocalStorageMessage,
                    ),
                    _ConfirmDetailsSlide(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(aDefaultSize),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_infoPageCount + 1, (i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _page ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                i == _page ? aAccentColor : aPrimaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: aFormHeight),
                    // The last page (profile confirmation) has its own Save
                    // button instead of Next/Get Started — it needs to
                    // validate the form and hit Firestore before leaving.
                    if (_page < _infoPageCount)
                      Row(
                        children: [
                          if (_page > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _back,
                                child: const Text(aOnboardingBack),
                              ),
                            ),
                          if (_page > 0) const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _next,
                              child: const Text(aOnboardingNext),
                            ),
                          ),
                        ],
                      )
                    else
                      OutlinedButton(
                        onPressed: _back,
                        child: const Text(aOnboardingBack),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSlide extends StatelessWidget {
  const _InfoSlide({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(aDefaultSize),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 96, color: aAccentColor),
          const SizedBox(height: aFormHeight),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _ConfirmDetailsSlide extends StatefulWidget {
  const _ConfirmDetailsSlide();

  @override
  State<_ConfirmDetailsSlide> createState() => _ConfirmDetailsSlideState();
}

class _ConfirmDetailsSlideState extends State<_ConfirmDetailsSlide> {
  final _formKey = GlobalKey<FormState>();
  final _profileController = Get.put(ProfileController());
  final _nameController = TextEditingController();
  bool _isSaving = false;
  bool _initialized = false;
  String _phoneNo = '';
  UserModel? _current;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final current = _current;
    final uid = AuthenticationRepository.instance.firebaseUser.value?.uid;
    if (current == null || uid == null) return;

    setState(() => _isSaving = true);
    try {
      final updated = UserModel(
        id: current.id,
        fullName: _nameController.text.trim(),
        email: current.email,
        phoneNo: _phoneNo,
        profileImageUrl: current.profileImageUrl,
      );
      final success =
          await _profileController.updateUserData(updated);
      if (!success) return;
      await UserRepository.instance.markOnboardingComplete(uid);
      if (!mounted) return;
      Get.offAll(() => const Dashboard());
    } catch (e) {
      if (!mounted) return;
      showSnackbarSafely("Error", "Couldn't save your details: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = _profileController.userData.value;
      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!_initialized) {
        _initialized = true;
        _current = user;
        _nameController.text = user.fullName;
        _phoneNo = user.phoneNo;
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(aDefaultSize),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.badge_rounded, size: 72, color: aAccentColor),
              const SizedBox(height: aFormHeight),
              Text(
                aOnboardingConfirmDetailsTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                aOnboardingConfirmDetailsMessage,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: aFormHeight),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    label: Text(aFullName), prefixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return aFullNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: aFormHeight - 20),
              TextFormField(
                initialValue: user.email,
                enabled: false,
                decoration: const InputDecoration(
                    label: Text(aEmail),
                    prefixIcon: Icon(Icons.mail_outline),
                    helperText: aEmailNotEditable),
              ),
              const SizedBox(height: aFormHeight - 20),
              PhoneNumberField(
                initialValue: _phoneNo,
                onChanged: (value) => _phoneNo = value,
                validator: validatePhoneNumber,
              ),
              const SizedBox(height: aFormHeight),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(aOnboardingFinish),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
