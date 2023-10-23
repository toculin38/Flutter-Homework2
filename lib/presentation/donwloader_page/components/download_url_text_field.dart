part of downloader_page_view;

class _Strings {
  static String urlTextFieldLabel = 'Download Url';
  static String urlDefaultContent =
      'https://upload.wikimedia.org/wikipedia/commons/e/e6/Clocktower_Panorama_20080622_20mb.jpg';
}

class _DownloadUrlTextField extends StatelessWidget {
  final DownloadRepository _downloaderAPI;
  final TextEditingController _urlController =
      TextEditingController(text: _Strings.urlDefaultContent);

  _DownloadUrlTextField({required DownloadRepository downloaderAPI})
      : _downloaderAPI = downloaderAPI;

  @override
  Widget build(BuildContext context) {
    return _buildUrlTextField();
  }

  TextField _buildUrlTextField() {
    final controller = _urlController;
    final labelText = _Strings.urlTextFieldLabel;
    const border = OutlineInputBorder();
    final suffixIcon = _buildDownloadButton();
    final decoration = InputDecoration(
        labelText: labelText, border: border, suffixIcon: suffixIcon);

    return TextField(
      controller: controller,
      decoration: decoration,
    );
  }

  IconButton _buildDownloadButton() {
    return IconButton(
        onPressed: onDownloadIconPressed, icon: const Icon(Icons.download));
  }

  void onDownloadIconPressed() {
    String url = _urlController.text;
    _downloaderAPI.startDownload(url);
  }
}
