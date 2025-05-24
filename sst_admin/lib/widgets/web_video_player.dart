import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;
import 'package:web/web.dart' as web;
import 'dart:js_interop';

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
  bool _hasError = false;
  String? _errorMessage;
  bool _isRegistered = false;

  @override
  void initState() {
    super.initState();
    _viewId = 'drive-video-${DateTime.now().microsecondsSinceEpoch}';
    _registerView();
  }

  @override
  void didUpdateWidget(covariant WebVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.embedUrl != widget.embedUrl) {
      _isRegistered = false;
      _registerView();
    }
  }

  void _registerView() {
    if (_isRegistered) return;

    try {
      final String videoUrl = widget.embedUrl;
      final bool isLocalVideo = videoUrl.endsWith('.mp4') || 
                              videoUrl.endsWith('.webm') || 
                              videoUrl.endsWith('.mov') || 
                              videoUrl.endsWith('.avi');

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        _viewId,
        (int viewId) {
          final iframe = web.document.createElement(isLocalVideo ? 'video' : 'iframe') as web.HTMLElement;
          
          if (isLocalVideo) {
            (iframe as web.HTMLVideoElement)
              ..src = 'http://localhost:4300/videos/$videoUrl'
              ..style.width = '100%'
              ..style.height = '100%'
              ..style.border = 'none'
              ..controls = true
              ..autoplay = false;
          } else {
            (iframe as web.HTMLIFrameElement)
              ..src = videoUrl
              ..style.width = '100%'
              ..style.height = '100%'
              ..style.border = 'none'
              ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
              ..setAttribute('allowfullscreen', 'true')
              ..setAttribute('frameborder', '0');
          }

          iframe.onload = (() {
            if (mounted) setState(() => _isLoading = false);
            return null as JSAny?;
          }).toJS;

          iframe.onerror = (() {
            if (mounted) {
              setState(() {
                _hasError = true;
                _errorMessage = 'Error al cargar el video';
                _isLoading = false;
              });
            }
            return null as JSAny?;
          }).toJS;

          return iframe;
        },
      );
      _isRegistered = true;
    } catch (e) {
      debugPrint('❌ Error registrando vista web: $e');
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Color(0xFF9ACA60), size: 40),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage ?? 'Error desconocido',
                        style: const TextStyle(color: Color(0xFF9ACA60)),
                      ),
                    ],
                  ),
                )
              : HtmlElementView(viewType: _viewId),
        ),
        if (_isLoading)
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF9ACA60)),
            ),
          ),
      ],
    );
  }
}
