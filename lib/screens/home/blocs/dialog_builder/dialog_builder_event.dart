part of 'dialog_builder_bloc.dart';

@immutable
sealed class DialogBuilderEvent {}

final class UpdateDialogScreenSizeEvent extends DialogBuilderEvent {
  final bool isMinimized;

  UpdateDialogScreenSizeEvent({required this.isMinimized});
}
