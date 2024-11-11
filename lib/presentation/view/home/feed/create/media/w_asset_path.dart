part of '../index.dart';

class SelectAssetPathWidget extends StatelessWidget {
  const SelectAssetPathWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFeedBloc, CreateFeedState>(
      builder: (context, state) {
        return Row(
          children: [
            DropdownButton<AssetPathEntity>(
              value: state.currentAssetPath,
              items: state.album
                  .map((item) => DropdownMenuItem<AssetPathEntity>(
                        value: item,
                        child: Text(item.name),
                      ))
                  .toList(),
              onChanged: (path) {
                if (path != null) {
                  context.read<CreateFeedBloc>().add(ChangeAssetPathEvent(path));
                }
              },
            ),
          ],
        );
      },
    );
  }
}