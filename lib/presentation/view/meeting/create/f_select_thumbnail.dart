part of 'page.dart';

class SelectThumbnailFragment extends StatelessWidget {
  const SelectThumbnailFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateMeetingCubit, CreateMeetingState>(
        builder: (context, state) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const IconLabelWidget(
            iconData: Icons.add_photo_alternate_outlined, label: 'Thumbnail'),
        const SizedBox(height: 24),
        state.thumbnail == null
            ? ElevatedButton(
                onPressed: () async {
                  await customUtil
                      .pickImageAndReturnCompressedImage()
                      .then((res) {
                    if (res == null) return;
                    context.read<CreateMeetingCubit>().updateThumbnail(res);
                  });
                },
                child: const Text('Select'))
            : Stack(children: [
                CircularAvatarAssetWidget(size: 120, state.thumbnail!),
                Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                        onPressed: () {
                          context
                              .read<CreateMeetingCubit>()
                              .updateThumbnail(null);
                        },
                        icon: const Icon(Icons.clear, size: 25)))
              ])
      ]);
    });
  }
}
