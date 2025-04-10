import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const HabilidadesMotoras());

class HabilidadesMotoras extends StatelessWidget {
  const HabilidadesMotoras({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habilidades Motoras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'HelveticaRounded'),
      home: const VideoListScreen(),
    );
  }
}

class Activity {
  final String title;
  final List<String> materials;
  final String information;
  final List<String> sequence;
  final String videoUrl;

  const Activity({
    required this.title,
    required this.materials,
    required this.information,
    required this.sequence,
    required this.videoUrl,
  });
}

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  final List<Activity> activities = const [
    Activity(
      title: 'No Dejes Caer el Globo',
      materials: ['Globo'],
      information: 'Desarrolla coordinación y movilidad.',
      sequence: [
        'Lanza un globo al aire, aplaude detrás de la espalda y recógelo antes de que toque el suelo.',
        'Realiza aplausos delante del cuerpo, debajo de las piernas y sobre la cabeza.',
        'Repite toda la secuencia 3 veces.',
      ],
      videoUrl: 'videos/no_dejes_caer_el_globo.mp4',
    ),
    Activity(
      title: 'El Zig Zag',
      materials: ['Pelota', 'Espacio físico'],
      information: 'Mejora control de movimiento y coordinación.',
      sequence: [
        'Formar filas con el mismo número de participantes.',
        'Pasar una pelota en zigzag con las manos sin dejarla caer.',
        'Si cae, se reinicia desde el principio.',
        'El equipo que complete primero gana.',
      ],
      videoUrl: 'videos/el_zig_zag.mp4',
    ),
    Activity(
      title: 'El Trencito',
      materials: ['Globo', 'Silla', 'Espacio físico'],
      information: 'Fomenta coordinación y patrones de marcha.',
      sequence: [
        'Formar dos filas de participantes.',
        'El primer participante rodea una silla y regresa con un globo.',
        'El siguiente participante se une, manteniendo el globo entre ambos.',
        'Continuar hasta completar la fila sin dejar caer el globo.',
      ],
      videoUrl: 'videos/el_trencito.mp4',
    ),
    Activity(
      title: 'Helices de Helicóptero',
      materials: ['Palo de escoba', 'Ganchos', 'Tulas de colores'],
      information: 'Favorece movilidad y coordinación.',
      sequence: [
        'Sostener un palo de escoba sobre los hombros y girar el torso.',
        'Usar los ganchos para recoger tulas de colores en diferentes puntos.',
        'Llevar las tulas a un recipiente inicial.',
      ],
      videoUrl: 'videos/carga_levanta_lleva.mp4',
    ),
    Activity(
      title: 'El Barco',
      materials: ['Hojas de papel', 'Espacio físico'],
      information: 'Favorece coordinación y movilidad.',
      sequence: [
        'Cada participante se coloca sobre hojas de papel para avanzar sin tocar el suelo.',
        'Avanzar pasando las hojas hacia adelante.',
        'El equipo que llegue primero al otro extremo gana.',
      ],
      videoUrl: 'videos/el_barco.mp4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color(0xFF0067AC),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
            ),
            child: Column(
              children: [
                const Text(
                  'Habilidades Motoras',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(height: 5, width: 150, color: Color(0xFFC6DA23)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return ActivityCard(activity: activities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({required this.activity, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shadowColor: const Color(0xFFC6DA23),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0067AC),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children:
                  activity.materials.map((material) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(
                          material,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFFC6DA23),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              'Información: ${activity.information}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  activity.sequence.map((step) {
                    return Text(
                      '- $step',
                      style: const TextStyle(fontSize: 14),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => VideoDialog(videoUrl: activity.videoUrl),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0067AC),
                  ),
                  child: const Text(
                    'Ver Actividad',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) =>
                              ConfirmationDialog(activityTitle: activity.title),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC6DA23),
                  ),
                  child: const Text(
                    'Asignar Actividad',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VideoDialog extends StatelessWidget {
  final String videoUrl;

  const VideoDialog({required this.videoUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Reproduciendo Actividad',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0067AC),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: VideoPlayerWidget(videoUrl: videoUrl),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl, super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String activityTitle;

  const ConfirmationDialog({required this.activityTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmar Asignación'),
      content: Text('¿Estás seguro de asignar la actividad "$activityTitle"?'),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (_) => const AssignmentSuccessDialog(),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class AssignmentSuccessDialog extends StatelessWidget {
  const AssignmentSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('animaciones/exito.json', height: 150),
            const SizedBox(height: 16),
            const Text(
              '¡Actividad Asignada!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0067AC),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC6DA23),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
