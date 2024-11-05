import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel/core/di/dependency_injection.dart';
import 'package:travel/core/theme/theme.dart';
import 'package:travel/core/util/extension/extension.dart';
import 'package:travel/core/util/snackbar/snackbar.dart';
import 'package:travel/presentation/widget/widget.dart';

import '../../../../core/constant/constant.dart';
import '../../../../core/util/media/media.dart';
import '../../../bloc/auth/sign_up/cubit.dart';

part 's_sign_up.dart';

part 'f_form.dart';

part 'f_avatar.dart';

part 'w_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignUpCubit>(),
      child: BlocListener<SignUpCubit, SignUpState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) async {
          switch (state.status) {
            case Status.success:
              getIt<CustomSnackBar>().success(title: 'Success');
              context.pop();
            case Status.error:
              getIt<CustomSnackBar>()
                  .error(title: 'Error', description: state.message);
              await Future.delayed(1.sec, () {
                context
                    .read<SignUpCubit>()
                    .init(status: Status.initial, message: '');
              });
            default:
              return;
          }
        },
        child: BlocBuilder<SignUpCubit, SignUpState>(
          builder: (context, state) {
            return LoadingOverLayWidget(
                isLoading: state.status == Status.loading,
                loadingWidget: const Center(child: CircularProgressIndicator()),
                childWidget: const SignUpScreen());
          },
        ),
      ),
    );
  }
}