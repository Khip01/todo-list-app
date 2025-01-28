part of 'dialog_builder_bloc.dart';

@immutable
sealed class DialogBuilderState {
  final bool isMinimized;

  const DialogBuilderState({
    required this.isMinimized,
  });
}

final class DialogBuilderInitial extends DialogBuilderState {
  const DialogBuilderInitial({super.isMinimized = true});
}

final class DialogBuilderLoaded extends DialogBuilderState {
  const DialogBuilderLoaded({required super.isMinimized});
}