import 'package:equatable/equatable.dart';

class ScreenState<T> extends Equatable {
  final Enum screen;
  final T? data;

  const ScreenState({required this.screen, this.data});

  ScreenState<T> copyWith({Enum? screen, T? data}) {
    return ScreenState(
      screen: screen ?? this.screen,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [screen, data];
}
