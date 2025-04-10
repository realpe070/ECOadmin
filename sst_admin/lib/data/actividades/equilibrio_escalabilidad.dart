import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() => runApp(const EquilibrioEscalabilidad());

class EquilibrioEscalabilidad extends StatelessWidget {
  const EquilibrioEscalabilidad({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equilibrio y Escalabilidad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'HelveticaRounded'),
      home: VideoListScreen(),
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
  VideoListScreen({super.key});

  final List<Activity> activities = [
    Activity(
      title: 'Pato Fuera del Agua, Pato Dentro del Agua',
      materials: ['Cinta de papel', 'Espacio físico'],
      information: 'Favorece equilibrio y atención.',
      sequence: [
        'Establecer una línea para separar el “agua” y el “suelo”.',
        'Al escuchar "pato fuera del agua", los participantes se colocan detrás de la línea.',
        'Al escuchar "patos dentro del agua", saltan delante de la línea.',
        'Realizar 4 repeticiones.',
      ],
      videoUrl: 'videos/pato.mp4',
    ),
    Activity(
      title: 'Balancea tu Equilibrio',
      materials: ['Espacio físico'],
      information: 'Mejora equilibrio y estabilidad.',
      sequence: [
        'En posición bípeda, balancearse hacia adelante y hacia atrás.',
        'Pararse en puntas de pies y luego en talones.',
        'Mantener los brazos hacia el frente durante el ejercicio.',
        'Repetir 3 veces cada movimiento.',
      ],
      videoUrl: 'videos/balancea_tu_equilibrio.mp4',
    ),
    Activity(
      title: 'Pasa el Equilibrio y Gana',
      materials: ['Cinta de papel ancha', 'Pelotas', 'Ula ula'],
      information: 'Favorece memoria, equilibrio y estabilidad.',
      sequence: [
        'Formar dos equipos con igual número de participantes.',
        'Cada equipo recoge dos pelotas y camina sobre la cinta sin salirse.',
        'Ensartar las pelotas en un ula ula ubicado a 5 metros.',
        'Repetir 3 veces para un total de 6 pelotas por equipo.',
      ],
      videoUrl: 'videos/pasa_el_equilibrio_y_gana.mp4',
    ),
    Activity(
      title: 'Recorrido Corporal',
      materials: ['Espacio físico', 'Antifaz'],
      information: 'Favorece equilibrio, estabilidad y concentración.',
      sequence: [
        'Los trabajadores se colocan en posición bípeda sobre una superficie plana.',
        'Uno de los participantes se coloca un antifaz que cubra sus ojos.',
        'Mediante órdenes verbales (ejemplo: “toca tu oreja derecha con la mano izquierda”), el participante deberá identificar y señalar correctamente la parte del cuerpo indicada.',
        'Repetir varias veces con diferentes órdenes, involucrando diversas partes del cuerpo.',
      ],
      videoUrl: 'videos/recorrido_corporal.mp4',
    ),
    Activity(
      title: 'Cuidado de Tus Hombros y Brazos',
      materials: ['Papeles de colores', 'Cinta de papel', 'Espacio físico'],
      information: 'Favorece estabilidad y coordinación.',
      sequence: [
        'Elevar los hombros para alcanzar un papel dispuesto a cierta altura.',
        'Llevar el papel por un circuito marcado en el suelo.',
        'Repetir 5 veces, utilizando papeles de diferentes colores.',
      ],
      videoUrl: 'videos/cuida_de_tus_hombros_y_brazos.mp4',
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
                  'Equilibrio y Escalabilidad',
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
                      builder: (_) => ConfirmationDialog(activity: activity),
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
                // Contenedor del video con tamaño moderado
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
          // Botón de cerrar
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
    _controller.play(); // Reproducción automática
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
  final Activity activity;

  const ConfirmationDialog({required this.activity, super.key});

  Future<void> asignarActividad(BuildContext context) async {
    try {
      if (!context.mounted) return;

      DateTime fecha = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy', 'es_ES').format(fecha);

      await FirebaseFirestore.instance.collection('asignaciones').add({
        'fecha': formattedDate,
        'nombreActividad': activity.title,
        'videoUrl': activity.videoUrl,
        'informacion': activity.information,
        'materiales': activity.materials,
        'secuencia': activity.sequence,
        'color': '0xFF800080', // Morado
      });

      if (!context.mounted) return;

      Navigator.pop(context);
      showDialog(context: context, builder: (_) => AssignmentSuccessDialog());
    } catch (e) {
      debugPrint('Error al asignar actividad: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar Asignación'),
      content: Text(
        '¿Estás seguro de asignar la actividad "${activity.title}"?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () => asignarActividad(context),
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
            Lottie.asset(
              'animaciones/exito.json', // Asegúrate de que el archivo existe
              height: 150,
            ),
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
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/administrar');
              },
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
