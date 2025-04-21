import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

/// Widget para reproducir videos embebidos desde Google Drive
class WebVideoPlayer extends StatefulWidget {
  final String embedUrl;

  const WebVideoPlayer({super.key, required this.embedUrl});

  @override
  State<WebVideoPlayer> createState() => _WebVideoPlayerState();
}

class _WebVideoPlayerState extends State<WebVideoPlayer> {
  late final String _viewId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _viewId = 'drive-video-${DateTime.now().millisecondsSinceEpoch}';
      _registerView();
    }
  }

  void _registerView() {
    ui.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        ..src = widget.embedUrl
        ..allow = 'autoplay; encrypted-media; picture-in-picture; web-share';

      // Configurar evento de carga
      iframe.onLoad.listen((_) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: HtmlElementView(viewType: _viewId),
        ),
        if (_isLoading)
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
