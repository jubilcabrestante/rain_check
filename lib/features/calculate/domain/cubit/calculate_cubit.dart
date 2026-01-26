import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calculate_state.dart';
part 'calculate_cubit.freezed.dart';

class CalculateCubit extends Cubit<CalculateState> {
  CalculateCubit() : super(const CalculateState());
}
