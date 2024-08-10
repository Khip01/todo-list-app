part of 'setting_bloc.dart';

@immutable
sealed class SettingState {
  final bool isSettingMode;

  const SettingState({
    required this.isSettingMode,
  });
}

final class SettingInitial extends SettingState {
  const SettingInitial()
      : super(isSettingMode: false);
}

class SettingLoaded extends SettingState {
  const SettingLoaded({required super.isSettingMode});
}
