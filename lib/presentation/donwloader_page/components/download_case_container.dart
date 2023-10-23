part of downloader_page_view;

class _DownloadCaseContainer extends StatefulWidget {
  final DownloadCase _downloadCase;
  const _DownloadCaseContainer(this._downloadCase);
  _DownloadCaseContainerState createState() => _DownloadCaseContainerState();
}

class _DownloadCaseContainerState extends State<_DownloadCaseContainer>
    with WidgetsBindingObserver {
  DownloadCase get _downloadCase => widget._downloadCase;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _downloadCase.pause();
    } else if (state == AppLifecycleState.resumed) {
      _downloadCase.start();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.all(3.0);
    final url = _downloadCase.url;
    final progress = _downloadCase.progress;
    final child = _buildContainer(url, progress);
    return Padding(padding: padding, child: child);
  }

  Widget _buildContainer(String text, double progress) {
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

    return container;
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
          SizedBox(height: 20.0, child: marqueeText),
        ],
      ),
    );
  }

  Widget _buildIconButtonsSection() {
    List<Widget> children = [];

    if (_downloadCase.status == DonwloadStatus.pausing) {
      const iconStart = Icon(Icons.play_arrow);
      final startButton = IconButton(
          icon: iconStart, iconSize: 30, onPressed: _downloadCase.start);

      children.add(startButton);
    }

    if (_downloadCase.status == DonwloadStatus.ongoing) {
      const iconPause = Icon(Icons.pause);
      final pauseButton = IconButton(
          icon: iconPause, iconSize: 30, onPressed: _downloadCase.pause);

      children.add(pauseButton);
    }

    const iconCancel = Icon(Icons.cancel);
    final cancelButton = IconButton(
        icon: iconCancel, iconSize: 30, onPressed: _downloadCase.cancel);

    children.add(cancelButton);

    final row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children);

    return Expanded(flex: 3, child: row);
  }
}
