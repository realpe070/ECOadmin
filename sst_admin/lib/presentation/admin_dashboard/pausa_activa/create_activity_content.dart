import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/drive_service.dart';
import '../../../core/services/activity_service.dart';
import 'video_selector_dialog.dart';
import 'web_video_player.dart'; // Nuevo import

class CreateActivityContent extends StatefulWidget {
  const CreateActivityContent({super.key});

  @override
  State<CreateActivityContent> createState() => _CreateActivityContentState();
}

class _CreateActivityContentState extends State<CreateActivityContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _minTimeController = TextEditingController();
  final TextEditingController _maxTimeController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  String? _selectedCategory;
  bool _showSensorSwitch = false;
  bool _sensorEnabled = false;
  VideoPlayerController? _videoPlayerController;
  bool _isYoutubeVideo = false;
  bool _isVideoLoading = false;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _showVideoSelector() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => VideoSelectorDialog(
        onVideoSelected: (video) {
          Navigator.pop(context, video);
        },
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _videoLinkController.text = DriveService.getVideoName(result);
        _initializeVideo(result);
      });
    }
  }

  Future<void> _initializeVideo(Map<String, dynamic> video) async {
    debugPrint('🎬 Iniciando inicialización de video');
    debugPrint('📝 Datos del video: $video');
    
    setState(() => _isVideoLoading = true);
    try {
      if (_videoPlayerController != null) {
        debugPrint('🔄 Liberando controlador anterior');
        await _videoPlayerController!.dispose();
      }

      final streamUrl = DriveService.getStreamUrl(video);
      debugPrint('🔗 Stream URL: $streamUrl');
      
      if (streamUrl == null) throw Exception('URL de stream no válida');

      debugPrint('⚙️ Creando nuevo controlador de video');
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(streamUrl),
      );

      debugPrint('🔄 Inicializando controlador');
      await _videoPlayerController!.initialize();
      
      debugPrint('✅ Video inicializado correctamente');
      if (!mounted) return;
      
      setState(() {
        _isVideoLoading = false;
        _isYoutubeVideo = false;
        _videoPlayerController!.play();
      });
    } catch (e, stackTrace) {
      debugPrint('❌ Error al inicializar video: $e');
      debugPrint('📚 StackTrace: $stackTrace');
      
      if (!mounted) return;

      // Intento alternativo con URL de vista previa
      try {
        final previewUrl = video['previewUrl'] as String?;
        if (previewUrl == null) throw Exception('URL de preview no disponible');

        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(previewUrl),
        );
        await _videoPlayerController!.initialize();
        
        setState(() {
          _isVideoLoading = false;
          _isYoutubeVideo = false;
          _videoPlayerController!.play();
        });
      } catch (secondError) {
        setState(() {
          _isVideoLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Error al cargar el video. El formato no es compatible con el navegador.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    }
  }

  Future<void> _saveActivity() async {
    // Verificar campos antes de la operación asíncrona
    if (_videoLinkController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _minTimeController.text.isEmpty ||
        _maxTimeController.text.isEmpty ||
        _selectedCategory == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Validar el video de Drive
      if (_videoLinkController.text.contains('drive.google.com')) {
        final isValid = await DriveService.validateDriveFile(_videoLinkController.text);
        if (!mounted) return;
        
        if (!isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El video debe estar en la carpeta de EcoBreack'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      final result = await ActivityService.createActivity(
        name: _nameController.text,
        description: _descriptionController.text,
        minTime: int.parse(_minTimeController.text),
        maxTime: int.parse(_maxTimeController.text),
        category: _selectedCategory!,
        videoUrl: _videoLinkController.text,
        sensorEnabled: _sensorEnabled,
      );

      if (!mounted) return;

      if (result['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Actividad creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _clearForm();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _minTimeController.clear();
    _maxTimeController.clear();
    _videoLinkController.clear();
    setState(() {
      _selectedCategory = null;
      _sensorEnabled = false;
    });
  }

  Widget _buildVideoPlayer() {
    if (_isVideoLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (!_isYoutubeVideo && _videoPlayerController != null) {
      if (kIsWeb) {
        final videoId = _videoLinkController.text.split('/').last;
        return WebVideoPlayer(
          embedUrl: DriveService.getEmbedUrl(videoId),
        );
      } else {
        return Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController!),
            ),
            IconButton(
              icon: Icon(
                _videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _videoPlayerController!.value.isPlaying
                      ? _videoPlayerController!.pause()
                      : _videoPlayerController!.play();
                });
              },
            ),
          ],
        );
      }
    }

    return const Center(
      child: Text(
        'Seleccione un video para reproducir',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Video de la Actividad',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0067AC),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _videoLinkController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Seleccione un video...',
                  prefixIcon: const Icon(Icons.movie),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _showVideoSelector,
              icon: const Icon(Icons.video_library),
              label: const Text('Seleccionar Video'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC6DA23),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_videoPlayerController != null || _isVideoLoading)
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildVideoPlayer(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0067AC).withAlpha(26),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nueva Actividad',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'HelveticaRounded',
                color: Color(0xFF0067AC),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _nameController,
              label: 'Nombre del Ejercicio',
              hint: 'Ingrese el nombre del ejercicio',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: 'Descripción',
              hint: 'Describa el ejercicio',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _minTimeController,
                    label: 'Tiempo mínimo (seg)',
                    hint: '30',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _maxTimeController,
                    label: 'Tiempo máximo (seg)',
                    hint: '60',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categoría',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0067AC),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: 'Seleccione una categoría',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF0067AC),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: [
                    _buildDropdownItem(
                      'Tren Superior',
                      Icons.accessibility_new,
                    ),
                    _buildDropdownItem(
                      'Tren Inferior',
                      Icons.directions_walk,
                    ),
                    _buildDropdownItem(
                      'Movilidad Articular',
                      Icons.self_improvement,
                    ),
                    _buildDropdownItem(
                      'Estiramientos Generales',
                      Icons.accessibility,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                      _showSensorSwitch = value == 'Tren Superior' || 
                                          value == 'Movilidad Articular';
                      if (!_showSensorSwitch) {
                        _sensorEnabled = false;
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0067AC)),
                  dropdownColor: Colors.white,
                  elevation: 3,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0067AC).withAlpha(13),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF0067AC).withAlpha(26),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sensors,
                        color: Color(0xFF0067AC),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sensor de Movimiento',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0067AC),
                              ),
                            ),
                            Text(
                              'Activar detección de movimiento para esta actividad',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _sensorEnabled,
                        onChanged: (value) {
                          setState(() => _sensorEnabled = value);
                        },
                        activeColor: const Color(0xFF0067AC),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildVideoSection(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Lógica para cancelar
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'HelveticaRounded',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0067AC),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Guardar Actividad',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'HelveticaRounded',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0067AC),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF0067AC),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String text, IconData icon) {
    return DropdownMenuItem<String>(
      value: text,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF0067AC), size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'HelveticaRounded',
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
