import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(const SettingInitial()) {
    on<UpdateSettingEvent>(_updateSettingEvent);
  }

  void _updateSettingEvent(UpdateSettingEvent event, Emitter<SettingState> emit){
    emit(SettingLoaded(isSettingMode: event.isSettingMode));
  }
}
