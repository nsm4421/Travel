import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/core/constant/constant.dart';
import 'package:travel/core/di/dependency_injection.dart';
import '../../../../core/bloc/display_bloc.dart';
import '../../../../domain/entity/meeting/meeting.dart';
import '../../../bloc/bloc_module.dart';
import '../../../bloc/meeting/display/display_meeting.bloc.dart';
import '../../../route/router.dart';
import '../../../widgets/widgets.dart';

part 's_meeting.dart';

part 'f_appbar.dart';

part 'f_meetings.dart';

part 'w_meeting_item.dart';

part 'f_search.dart';

class MeetingPage extends StatelessWidget {
  const MeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<BlocModule>().displayMeeting..add(FetchEvent(refresh: true)),
      child: BlocBuilder<DisplayMeetingBloc, CustomDisplayState<MeetingEntity>>(
          builder: (context, state) {
        return LoadingOverLayScreen(
            isLoading: state.status == Status.loading,
            loadingWidget: const Center(child: CircularProgressIndicator()),
            childWidget: const DisplayMeetingScreen());
      }),
    );
  }
}
