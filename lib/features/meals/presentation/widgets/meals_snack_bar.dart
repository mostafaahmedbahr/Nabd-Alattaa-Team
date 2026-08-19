import '../../../../common_imports.dart';

void mealsShowSnackBar(BuildContext context, String message, Color color)
{
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}
