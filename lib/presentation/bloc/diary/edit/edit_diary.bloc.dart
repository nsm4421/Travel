import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constant/constant.dart';
import '../../../../core/util/util.dart';
import '../../../../domain/usecase/diary/usecase.dart';

part 'edit_diary.state.dart';

part 'edit_diary.event.dart';

class EditDiaryBloc extends Bloc<EditDiaryEvent, EditDiaryState> {
  String _id;
  final DiaryUseCase _useCase;

  String get id => _id;

  EditDiaryBloc({required String id, required DiaryUseCase useCase})
      : _id = id,
        _useCase = useCase,
        super(EditDiaryState()) {
    on<LoadDiaryEvent>(_onLoad); // TODO
    on<InitializeEvent>(_onInit);
    on<ResetDiaryEvent>(_onReset);
    on<UpdateEditorEvent>(_onUpdate);
    on<AddAssetEvent>(_onAddAsset);
    on<ChangeAssetEvent>(_onChangeAsset);
    on<UnSelectAssetEvent>(_onUnSelect);
    on<SubmitDiaryEvent>(_onSubmit);
  }

  // TODO : edit모드인 경우 기존 데이터를 불러오기
  Future<void> _onLoad(
      LoadDiaryEvent event, Emitter<EditDiaryState> emit) async {
    try {
      if (state.update) {
        // TODO : 기존 게시글 불러와서 이미지를 File객체로 만들어 상태 업데이트
      }
      emit(state.copyWith(status: Status.initial));
    } on Exception catch (error) {
      emit(state.copyWith(
          status: Status.error, errorMessage: '기존 데이터 불러오는 중 오류 발생'));
      customUtil.logger.e(error);
    }
  }

  Future<void> _onInit(
      InitializeEvent event, Emitter<EditDiaryState> emit) async {
    try {
      emit(state.copyWith(
          status: event.status, errorMessage: event.errorMessage));
    } on Exception catch (error) {
      customUtil.logger.e(error);
      emit(state.copyWith(
          status: Status.error, errorMessage: 'error occurs on init'));
    }
  }

  Future<void> _onReset(
      ResetDiaryEvent event, Emitter<EditDiaryState> emit) async {
    try {
      _id = const Uuid().v4();
      emit(EditDiaryState());
    } on Exception catch (error) {
      customUtil.logger.e(error);
      emit(state.copyWith(
          status: Status.error, errorMessage: 'error occurs on init'));
    }
  }

  Future<void> _onUpdate(
      UpdateEditorEvent event, Emitter<EditDiaryState> emit) async {
    try {
      emit(state.copyWith(
          content: event.content ?? state.content,
          hashtags: event.hashtags ?? state.hashtags,
          location: event.location ?? state.location));
    } catch (error) {
      customUtil.logger.e(error);
      emit(state.copyWith(
          status: Status.error, errorMessage: 'error occurs on editing'));
    }
  }

  Future<void> _onAddAsset(
      AddAssetEvent event, Emitter<EditDiaryState> emit) async {
    try {
      emit(state.copyWith(assets: [
        ...state.assets,
        DiaryAsset(caption: '', image: event.image)
      ]));
    } catch (error) {
      customUtil.logger.e(error);
      emit(state.copyWith(
          status: Status.error, errorMessage: 'error occurs on add asset'));
    }
  }

  Future<void> _onChangeAsset(
      ChangeAssetEvent event, Emitter<EditDiaryState> emit) async {
    try {
      emit(state.copyWith(
          assets: List.generate(state.assets.length, (index) {
        final asset = state.assets[index];
        return event.index == index
            ? asset.copyWith(
                image: event.asset.image, caption: event.asset.caption)
            : asset;
      })));
    } catch (error) {
      customUtil.logger.e(error);
      emit(state.copyWith(
          status: Status.error, errorMessage: 'error occurs on change image'));
    }
  }

  Future<void> _onUnSelect(
      UnSelectAssetEvent event, Emitter<EditDiaryState> emit) async {
    try {
      List<DiaryAsset> assets = [...state.assets];
      assets.removeAt(event.index);
      emit(state.copyWith(assets: assets));
    } catch (error) {
      customUtil.logger.e(error);
      emit(state.copyWith(
          status: Status.error,
          errorMessage: 'error occurs on un select image'));
    }
  }

  Future<void> _onSubmit(
      SubmitDiaryEvent event, Emitter<EditDiaryState> emit) async {
    try {
      emit(state.copyWith(
          status: Status.loading, content: state.content.trim()));
      // 이미지나 본문이 없는 경우 에러 처리
      if (state.assets.isEmpty && state.content.isEmpty) {
        emit(state.copyWith(
            status: Status.error, errorMessage: '이미지나 본문을 입력해주세요'));
        return;
      }
      // 업로드 요청
      await _useCase.edit
          .call(
              id: id,
              location: state.location,
              content: state.content,
              hashtags: state.hashtags,
              images: state.assets.map((item) => item.image).toList(),
              captions: state.assets.map((item) => item.caption).toList(),
              isPrivate: state.isPrivate,
              update: state.update)
          .then((res) => res.fold((l) {
                emit(state.copyWith(
                    status: Status.error, errorMessage: l.message));
              }, (r) {
                emit(state.copyWith(status: Status.success));
              }));
    } on Exception catch (error) {
      emit(state.copyWith(
          status: Status.error, errorMessage: '업로드 중 에러가 발생했습니다'));
      customUtil.logger.e(error);
    }
  }
}
