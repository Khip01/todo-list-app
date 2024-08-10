part of 'setting_bloc.dart';

@immutable
sealed class SettingEvent {}

class UpdateSettingEvent  extends SettingEvent {
  final bool isSettingMode;

  UpdateSettingEvent({required this.isSettingMode});
}