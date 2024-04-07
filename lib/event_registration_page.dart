import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'event.dart';
import 'database_helper.dart';

List<CameraDescription>? cameras;

class EventRegistrationPage extends StatefulWidget {
  @override
  _EventRegistrationPageState createState() => _EventRegistrationPageState();
}

class _EventRegistrationPageState extends State<EventRegistrationPage> {
  FlutterSoundRecorder? _audioRecorder;
  CameraController? _cameraController;
  bool _isRecording = false;
  String _audioPath = '';
  XFile? _imageFile;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _requestPermissions().then((_) {
      _initRecorder();
      _initCamera();
    });
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  Future<void> _initRecorder() async {
    _audioRecorder = FlutterSoundRecorder();

    final microphoneStatus = await Permission.microphone.status;
    if (!microphoneStatus.isGranted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _audioRecorder!.openAudioSession();
  }

  Future<void> _initCamera() async {
    final cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      throw CameraException('CameraAccessDenied', 'Camera access permission was denied.');
    }

    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();
    } else {
      throw CameraException('CameraNotAvailable', 'No cameras available.');
    }
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _audioRecorder!.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );

    setState(() {
      _isRecording = true;
      _audioPath = filePath;
    });
  }

  Future<void> _stopRecording() async {
    await _audioRecorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _takePicture() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final XFile file = await _cameraController!.takePicture();
      setState(() {
        _imageFile = file;
      });
    } else {
      throw CameraException('CameraNotInitialized', 'Camera is not initialized.');
    }
  }

  Future<void> _saveEvent() async {
    Event event = Event(
      id: 1,
      title: _titleController.text,
      date: _dateController.text,
      description: _descriptionController.text,
      imagePath: _imageFile?.path,
      audioPath: _audioPath,
    );

    await _dbHelper.insertEvent(event);
  }

  @override
  void dispose() {
    _audioRecorder?.closeAudioSession();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Eventos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Fecha'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      _dateController.text = formattedDate;
                    });
                  }
                },
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              SizedBox(height: 10),
              _imageFile == null
                  ? ElevatedButton(
                      onPressed: _takePicture,
                      child: Text('Tomar Foto'),
                    )
                  : Image.file(File(_imageFile!.path), height: 200),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isRecording ? null : _startRecording,
                child: Text('Iniciar Grabación'),
              ),
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : null,
                child: Text('Detener Grabación'),
              ),
              if (_audioPath.isNotEmpty)
                Text('Audio guardado en: $_audioPath'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text('Guardar Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
