part of 'index.dart';

class DisplayAssetFragment extends StatelessWidget {
  const DisplayAssetFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateReelsBloc, CreateReelsState>(
      builder: (context, state) {
        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: state.assets.length + (state.isEnd ? 0 : 1),
          itemBuilder: (context, index) {
            if (index < state.assets.length) {
              final asset = state.assets[index];
              return GestureDetector(
                  onTap: () {
                    context
                        .read<CreateReelsBloc>()
                        .add(SelectVideoEvent(asset));
                  },
                  child: AnimatedOpacity(
                      opacity: asset == state.video ? 0.4 : 1,
                      duration: 200.ms,
                      child: AssetEntityImage(asset, fit: BoxFit.cover)));
            } else {
              // 더 가져오기 버튼
              return GestureDetector(
                  onTap: () {
                    context.read<CreateReelsBloc>().add(FetchMoreAssetEvent());
                  },
                  child: const Icon(Icons.add));
            }
          },
        );
      },
    );
  }
}