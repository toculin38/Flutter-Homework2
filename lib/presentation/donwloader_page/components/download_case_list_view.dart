part of downloader_page_view;

class _DownloadCaseListView extends StatelessWidget {
  final DownloadRepository _downloaderAPI;
  const _DownloadCaseListView({required DownloadRepository downloaderAPI})
      : _downloaderAPI = downloaderAPI;

  @override
  Widget build(BuildContext context) {
    return _buildExpandedListView();
  }

  Widget _buildExpandedListView() {
    StreamBuilder streamBuilder = StreamBuilder(
        stream: _downloaderAPI.onDownloadCasesUpdateStream,
        builder: (context, snapshot) {
          List<Widget> children = [];

          if (snapshot.hasData) {
            for (DownloadCase downloadCase in snapshot.data) {
              final downloadCaseContainer =
                  _DownloadCaseContainer(downloadCase);

              children.add(downloadCaseContainer);
            }
          }

          return ListView(children: children);
        });

    return Expanded(child: streamBuilder);
  }
}
