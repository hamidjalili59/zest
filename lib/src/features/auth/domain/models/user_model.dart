import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

// @freezed
// @JsonSerializable()
// class UserModel with _$UserModel {
//   UserModel({required this.name});
//
//   factory UserModel.fromJson(Map<String, Object?> json) =>
//       _$UserModelFromJson(json);
//
//   Map<String, Object?> toJson() => _$UserModelToJson(this);
//
//   @override
//   final String name;
// }
//

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({required String name}) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
