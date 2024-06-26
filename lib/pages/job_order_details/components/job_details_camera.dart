import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/controllers/job_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class JobDetailsCamera extends StatefulWidget {
  const JobDetailsCamera({super.key});
  @override
  State<JobDetailsCamera> createState() => _JobDetailsCameraState();
}

class _JobDetailsCameraState extends State<JobDetailsCamera> {
  late int jobId;
  final AuthController authController = Get.find();
  bool isOverlayVisible = false;
  String? overlayPhotoPath;
  final JobOrderController jobOrderController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    jobId = ModalRoute.of(context)!.settings.arguments as int;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CameraAwesomeBuilder.awesome(
        availableFilters: awesomePresetFiltersList,
        saveConfig: SaveConfig.photo(
          pathBuilder: (sensors) async {
            final Directory extDir = await getTemporaryDirectory();
            final testDir = await Directory(
              '${extDir.path}/camerawesome',
            ).create(recursive: true);
            if (sensors.length == 1) {
              final String filePath =
                  '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
              return SingleCaptureRequest(filePath, sensors.first);
            } else {
              return MultipleCaptureRequest(
                {
                  for (final sensor in sensors)
                    sensor:
                        '${testDir.path}/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
                },
              );
            }
          },
          // exifPreferences: ExifPreferences(saveGPSLocation: true),
        ),
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.back),
          flashMode: FlashMode.auto,
          aspectRatio: CameraAspectRatios.ratio_4_3,
          zoom: 0.0,
        ),
        enablePhysicalButton: true,
        previewAlignment: Alignment.center,
        previewFit: CameraPreviewFit.contain,
        onMediaTap: (mediaCapture) {
          mediaCapture.captureRequest.when(
            single: (single) {
              debugPrint('single: ${single.file?.path}');
              setState(() {
                isOverlayVisible = true;
                overlayPhotoPath = single.file?.path;
              });
            },
            multiple: (multiple) {
              multiple.fileBySensor.forEach((key, value) {
                debugPrint('multiple file taken: $key ${value?.path}');
                value?.openRead();
              });
            },
          );
        },
      ),
      if (isOverlayVisible && overlayPhotoPath != null)
        PhotoOverlay(
            photoPath: overlayPhotoPath!,
            onConfirm: () async {
              await jobOrderController.addPhoto(
                  overlayPhotoPath!, jobId, authController.token);
              Get.back();
            },
            onTakePhotoAgain: closeOverlay),
    ]);
  }

  void closeOverlay() {
    setState(() {
      isOverlayVisible = false;
      overlayPhotoPath = null;
    });
  }
}

class PhotoOverlay extends StatelessWidget {
  final String photoPath;
  final VoidCallback onConfirm;
  final VoidCallback onTakePhotoAgain;

  const PhotoOverlay({
    super.key,
    required this.photoPath,
    required this.onConfirm,
    required this.onTakePhotoAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Image.file(
                  File(photoPath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTakePhotoAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: const Color.fromARGB(255, 241, 237, 1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Take Photo Again'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: const Color.fromARGB(255, 248, 212, 7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
