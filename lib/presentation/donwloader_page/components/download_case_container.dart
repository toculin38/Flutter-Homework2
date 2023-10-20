part of downloader_page_view;

class _DownloadCaseContainer extends StatelessWidget {
  final String _url;
  final double _progress;

  const _DownloadCaseContainer({required String url, required double progress})
      : _url = url,
        _progress = progress;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.all(3.0);
    final child = _buildInlWellContainer(_url, _progress);
    return Padding(padding: padding, child: child);
  }

  Widget _buildInlWellContainer(String text, double progress) {
    final decoration = BoxDecoration(
      border: Border.all(color: Colors.black, width: 1.0),
    );

    final containnerRow = Row(
      children: [
        _buildMarqueeSection(text, progress),
        _buildIconButtonsSection(),
      ],
    );

    final container = Container(
      height: 50,
      decoration: decoration,
      child: containnerRow,
    );

    return InkWell(
      onTap: _handleTap, // 這裡是當Container被點擊時要觸發的方法
      child: container,
    );
  }

  void _handleTap() {
    print("Container被點擊了!");
  }

  Widget _buildMarqueeSection(String text, double progress) {
    final progressBar = LinearProgressIndicator(value: progress);
    final marqueeText = Marquee(text: text, velocity: 30.0, blankSpace: 30.0);

    return Expanded(
      flex: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          progressBar,
          Container(height: 20.0, child: marqueeText),
        ],
      ),
    );
  }

  Widget _buildIconButtonsSection() {
    const iconReusme = Icon(Icons.play_arrow);
    const iconCancel = Icon(Icons.cancel);
    final resumeButton =
        IconButton(icon: iconReusme, iconSize: 30, onPressed: () {});
    final cancelButton =
        IconButton(icon: iconCancel, iconSize: 30, onPressed: () {});

    List<Widget> children = [resumeButton, cancelButton];

    final row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children);

    return Expanded(flex: 3, child: row);
  }
}
