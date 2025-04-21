import 'package:flutter/material.dart';
import '../../../core/services/drive_service.dart';

class VideoSelectorDialog extends StatefulWidget {
  final Function(Map<String, dynamic> video) onVideoSelected;

  const VideoSelectorDialog({
    super.key,
    required this.onVideoSelected,
  });

  @override
  State<VideoSelectorDialog> createState() => _VideoSelectorDialogState();
}

class _VideoSelectorDialogState extends State<VideoSelectorDialog> {
  String? _selectedVideoId;
  String _searchQuery = '';
  bool _isLoading = true;
  List<Map<String, dynamic>> _videos = [];
  final Map<String, bool> _isHovering = {};

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    debugPrint('🎥 Iniciando carga de videos');
    setState(() => _isLoading = true);
    try {
      debugPrint('📡 Llamando a getAllVideos');
      final videos = await DriveService.getAllVideos();
      debugPrint('✅ Videos obtenidos: ${videos.length}');
      debugPrint('📝 Primer video: ${videos.isNotEmpty ? videos.first : "ninguno"}');
      
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('❌ Error cargando videos: $e');
      debugPrint('📚 StackTrace: $stackTrace');
      
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 800,
        height: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildVideoGrid()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF0067AC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.video_library, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Seleccionar Video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Buscar video...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredVideos = _videos.where((video) {
      return video['name'].toString().toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 16/12,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredVideos.length,
      itemBuilder: (context, index) {
        final video = filteredVideos[index];
        final fileId = video['id'];
        final isSelected = _selectedVideoId == fileId;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovering[fileId] = true),
          onExit: (_) => setState(() => _isHovering[fileId] = false),
          child: GestureDetector(
            onTap: () => setState(() => _selectedVideoId = fileId),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? const Color(0xFF0067AC) : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      video['thumbnailUrl'] ?? DriveService.getThumbnailUrl(fileId),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                                : null,
                            color: const Color(0xFF0067AC),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.video_library,
                            size: 40,
                            color: Color(0xFF0067AC),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_isHovering[fileId] == true || isSelected)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.black54,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle : Icons.play_circle,
                            color: Colors.white,
                            size: 40,
                          ),
                          if (video['size'] != null)
                            Text(
                              '${(video['size'] / 1024 / 1024).toStringAsFixed(1)} MB',
                              style: const TextStyle(color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(7),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video['name'] ?? 'Sin nombre',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (video['mimeType'] != null)
                            Text(
                              video['mimeType'].toString().split('/').last.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedVideoId != null 
              ? 'Video seleccionado: ${_videos.firstWhere((v) => v['id'] == _selectedVideoId)['name']}'
              : 'Ningún video seleccionado',
            style: TextStyle(
              color: _selectedVideoId != null ? const Color(0xFF0067AC) : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _selectedVideoId != null
                    ? () {
                        final selectedVideo = _videos.firstWhere(
                          (v) => v['id'] == _selectedVideoId
                        );
                        widget.onVideoSelected(selectedVideo);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC6DA23),
                ),
                child: const Text('Seleccionar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
