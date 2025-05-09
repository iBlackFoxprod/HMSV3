// lib/core/enums/user_role_enum.dart
enum UserRole {
  patient,
  doctor,
  nurse,
  pharmacist,
  finance,
  management,
  hr,
  clientHelp,
  purchase,
  storage,
  maintenance,
  it,
  logistic,
  accounting,
  admin, // A super-admin role if needed
}

// lib/core/enums/department_enum.dart (if you want it separate or part of user model)
// For now, we can represent department as a string in UserModel or a dedicated field.
// If departments have more properties later, make it a class/model.