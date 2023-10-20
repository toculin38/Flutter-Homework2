part of downloader_page_view;

class _DownloadCaseListView extends StatelessWidget {
  final DownloaderAPI _downloaderAPI;
  const _DownloadCaseListView({required DownloaderAPI downloaderAPI})
      : _downloaderAPI = downloaderAPI;

  @override
  Widget build(BuildContext context) {
    return _buildExpandedListView();
  }

  Widget _buildExpandedListView() {
    List<Widget> children = [
      _DownloadCaseContainer(url: 'https://example.com', progress: 0.5),
      _DownloadCaseContainer(
          url:
              'https://upload.wikimedia.org/wikipedia/commons/e/e6/Clocktower_Panorama_20080622_20mb.jpg',
          progress: 0.7),
    ];
    return Expanded(child: ListView(children: children));
  }
}
