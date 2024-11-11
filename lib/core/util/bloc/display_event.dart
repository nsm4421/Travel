part of 'display_bloc.dart';

@sealed
class CustomDisplayEvent<T> {}

class InitDisplayEvent<T> extends CustomDisplayEvent<T> {
  final Status? status;
  final List<T>? data;
  final String? errorMessage;

  InitDisplayEvent({this.status, this.data, this.errorMessage});
}

class FetchEvent<T> extends CustomDisplayEvent<T> {
  final bool refresh;
  final int take;

  FetchEvent({this.refresh = false, this.take = 20});
}