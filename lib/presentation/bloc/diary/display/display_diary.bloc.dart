import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:travel/core/util/util.dart';
import 'package:travel/domain/entity/diary/diary.dart';

import '../../../../core/constant/constant.dart';
import '../../../../domain/usecase/diary/usecase.dart';

part 'display_diary.event.dart';

class DisplayDiaryBloc
    extends Bloc<DisplayDiaryEvent, CustomDisplayState<DiaryEntity>> {
  final DiaryUseCase _useCase;

  DisplayDiaryBloc(this._useCase) : super(CustomDisplayState<DiaryEntity>()) {
    on<FetchDiariesEvent>(_onFetch);
  }

  Future<void> _onFetch(FetchDiariesEvent event,
      Emitter<CustomDisplayState<DiaryEntity>> emit) async {
    try {
      emit(state.copyWith(
        status: event.refresh ? Status.loading : state.status,
        isFetching: true,
        data: event.refresh ? [] : state.data,
        isEnd: event.refresh ? false : state.isEnd,
      ));
      await _useCase
          .fetch(state.beforeAt, take: event.take)
          .then((res) => emit(state.from(res, take: event.take)));
    } on Exception catch (error) {
      emit(state.copyWith(
          status: Status.error, errorMessage: 'error occurs on fetching data'));
      customUtil.logger.e(error);
    } finally {
      emit(state.copyWith(isFetching: false));
    }
  }
}
