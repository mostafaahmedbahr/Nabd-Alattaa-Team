import '../../../../common_imports.dart';
import '../../data/models/register_model.dart';
import '../../data/repos/register_repos.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final RegisterRepo registerRepo;

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ageController = TextEditingController();

  // Form state
  String selectedGender = 'male';
  String selectedDepartment = '';
  DateTime birthDate = DateTime.now().subtract(const Duration(days: 365 * 22));
  int currentStep = 0;

  // Password visibility
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  // Form key
  final formKey = GlobalKey<FormState>();

  RegisterCubit({required this.registerRepo}) : super(const RegisterInitialState());

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(RegisterStateUpdated());
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    emit(RegisterStateUpdated());
  }

  void updateGender(String gender) {
    selectedGender = gender;
    emit(RegisterStateUpdated());
  }

  void updateDepartment(String department) {
    selectedDepartment = department;
    emit(RegisterStateUpdated());
  }

  void updateBirthDate(DateTime date) {
    birthDate = date;
    emit(RegisterStateUpdated());
  }

  void goToNextStep() {
    if (currentStep == 0) {
      currentStep = 1;
      emit(RegisterStateUpdated());
    }
  }

  void goToPreviousStep() {
    if (currentStep == 1) {
      currentStep = 0;
      emit(RegisterStateUpdated());
    }
  }

  // Single validateStep1 method using formKey
  bool validateStep1() {
    return (formKey.currentState?.validate() ?? false) && selectedDepartment.isNotEmpty;
  }

  Future<void> submitRegister() async {
    // Validate form data
    if (!validateStep1() ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      emit(RegisterErrorState(message: 'يرجى ملء جميع الحقول المطلوبة'));
      return;
    }

    // Validate passwords match
    if (passwordController.text != confirmPasswordController.text) {
      emit(RegisterErrorState(message: 'كلمة المرور غير متطابقة'));
      return;
    }

    emit(const RegisterLoadingState());

    final registerData = RegisterModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      age: int.parse(ageController.text.trim()),
      department: selectedDepartment,
      gender: selectedGender,
      birthDate: birthDate,
    );

    final result = await registerRepo.register(registerData: registerData);

    result.fold(
          (failure) => emit(RegisterErrorState(message: failure.message)),
          (user) => emit(RegisterSuccessState(user: user)),
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();
    return super.close();
  }
}