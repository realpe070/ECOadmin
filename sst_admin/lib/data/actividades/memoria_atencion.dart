import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const MemoriaAtencion());

class MemoriaAtencion extends StatelessWidget {
  const MemoriaAtencion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memoria y Atención',
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
      title: 'Movilizando',
      materials: [
        'Espacio físico',
        'Flechas de dirección (derecha, izquierda, arriba, abajo)',
      ],
      information:
          'Favorecer habilidades motoras con el fin de contribuir a su desempeño laboral.',
      sequence: [
        'Los trabajadores deben realizar una pausa en sus labores, en donde deben colocarse sobre una superficie plana y fija.',
        'Cada persona deberá colocarse en una posición bípeda.',
        'Los trabajadores iniciarán movimientos desde la cabeza hasta los pies, según la dirección indicada por su compañero.',
        'Por ejemplo: Si se les muestra una flecha hacia la izquierda, girarán la cabeza a la izquierda.',
        'Realizar movimientos hacia arriba, abajo, derecha e izquierda, siguiendo la secuencia desde la cabeza hasta el tronco.',
        'Repetir la acción durante 20 repeticiones.',
      ],
      videoUrl: 'videos/movilizando.mp4',
    ),
    Activity(
      title: 'El Espejo',
      materials: ['Patrón de objetos'],
      information: 'Mejora atención y memoria a corto plazo.',
      sequence: [
        'El último participante recibe un patrón de objetos (ejemplo: manzana, carro, etc.).',
        'Debe transmitirlo al compañero de enfrente hasta llegar al primero.',
        'El primero repite el patrón en voz alta.',
      ],
      videoUrl: 'videos/el_espejo.mp4',
    ),
    Activity(
      title: 'Activa Tu Coordinación',
      materials: ['Espacio físico'],
      information: 'Promueve atención y seguimiento de instrucciones.',
      sequence: [
        'Seguir instrucciones rápidas como “paso al frente”, “pierna derecha atrás”, “aplauso”.',
        'El equipo con menos descoordinaciones gana.',
      ],
      videoUrl: 'videos/activa_tu_coordinacion.mp4',
    ),
    Activity(
      title: 'Recorrido Corporal',
      materials: ['Espacio físico', 'Antifaz'],
      information: 'Favorece concentración y seguimiento visual.',
      sequence: [
        'Los trabajadores deben colocarse sobre una superficie plana y fija.',
        'Donde el trabajador que deba indicar la parte de su cuerpo estará tapado sus ojos con el antifaz.',
        'En posición bípeda, el trabajador mediante diferentes órdenes deberá con su dedo índice indicar la parte del cuerpo que se le indique.',
        'Esto se repetirá varias veces en diversas partes del cuerpo.',
      ],
      videoUrl: 'videos/recorrido_corporal.mp4',
    ),
    Activity(
      title: 'Pasa el Objeto',
      materials: ['Pelota'],
      information: 'Favorece memoria y rotación del tronco.',
      sequence: [
        'Pasar una pelota inclinando el tronco hacia la derecha.',
        'Llegar al último participante y devolverla inclinándose hacia la izquierda.',
      ],
      videoUrl: 'videos/pasa_el_objeto.mp4',
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
                  'Memoria y Atención',
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
