import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dialog_builder_event.dart';
part 'dialog_builder_state.dart';

class DialogBuilderBloc extends Bloc<DialogBuilderEvent, DialogBuilderState> {
  DialogBuilderBloc() : super(DialogBuilderInitial()) {
    on<UpdateDialogScreenSizeEvent>(_dialogUpdateScreenSize);
  }

  void _dialogUpdateScreenSize(UpdateDialogScreenSizeEvent event, Emitter<DialogBuilderState> emit) {
    emit(DialogBuilderLoaded(isMinimized: event.isMinimized));
  }
}
