import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:file_selector/file_selector.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const String appName = 'Shamisen Tab Composer';
const String appVersion = 'Beta 0.2.0';
const String appFullTitle = 'Shamisen Tab Composer Beta 0.2.0';

const int currentSongFileVersion = 1;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    LocalErrorLogger.writeFlutterError(details);
  };

  ui.PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
    LocalErrorLogger.writeError(
      source: 'Uncaught platform error',
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  };

  runZonedGuarded<void>(
    () {
      runApp(const ShamisenTabApp());
    },
    (Object error, StackTrace stackTrace) {
      LocalErrorLogger.writeError(
        source: 'Uncaught zoned error',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}

int clampJsonInt(int value, int minValue, int maxValue) {
  if (value < minValue) return minValue;
  if (value > maxValue) return maxValue;
  return value;
}

int readJsonInt(
  Map<String, dynamic> json,
  String key,
  int defaultValue,
) {
  final value = json[key];

  if (value is int) return value;
  if (value is num) return value.round();
  if (value is String) return int.tryParse(value.trim()) ?? defaultValue;

  return defaultValue;
}

double readJsonDouble(
  Map<String, dynamic> json,
  String key,
  double defaultValue,
) {
  final value = json[key];

  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.trim()) ?? defaultValue;

  return defaultValue;
}

String readJsonString(
  Map<String, dynamic> json,
  String key,
  String defaultValue,
) {
  final value = json[key];

  if (value == null) return defaultValue;
  if (value is String) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? defaultValue : trimmedValue;
  }

  return value.toString();
}

Map<String, dynamic>? asStringKeyedMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return value.map(
      (key, mapValue) => MapEntry(key.toString(), mapValue),
    );
  }

  return null;
}

List<Map<String, dynamic>> readJsonObjectList(dynamic value) {
  if (value is! List) return <Map<String, dynamic>>[];

  return value
      .map(asStringKeyedMap)
      .whereType<Map<String, dynamic>>()
      .toList();
}

int durationSlotsFromRhythmString(String rhythm) {
  switch (rhythm) {
    case 'Whole':
      return 16;
    case 'Half':
      return 8;
    case 'Quarter':
      return 4;
    case 'Eighth':
      return 2;
    case 'Sixteenth':
      return 1;
    default:
      return 4;
  }
}

String readableErrorMessage(Object error) {
  if (error is FormatException) {
    return error.message;
  }

  if (error is FileSystemException) {
    return error.message;
  }

  return error.toString();
}


class ShamisenTabApp extends StatelessWidget {
  const ShamisenTabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appFullTitle,
      home: const EditorScreen(),
    );
  }
}

enum EditorTool { write, erase, suri, rest, repeat, lyric, section }

class TabNote {
  final int stringNumber;
  final int slot;
  final int durationSlots;
  final String tabNumber;
  final String rhythm;
  final String technique;

  const TabNote({
    required this.stringNumber,
    required this.slot,
    required this.durationSlots,
    required this.tabNumber,
    required this.rhythm,
    required this.technique,
  });

  Map<String, dynamic> toJson() {
    return {
      'stringNumber': stringNumber,
      'slot': slot,
      'durationSlots': durationSlots,
      'tabNumber': tabNumber,
      'rhythm': rhythm,
      'technique': technique,
    };
  }

  factory TabNote.fromJson(Map<String, dynamic> json) {
    final rhythm = readJsonString(json, 'rhythm', 'Quarter');
    final fallbackDurationSlots = durationSlotsFromRhythmString(rhythm);
    final durationSlots = readJsonInt(
      json,
      'durationSlots',
      fallbackDurationSlots,
    );

    return TabNote(
      stringNumber: clampJsonInt(readJsonInt(json, 'stringNumber', 1), 1, 3),
      slot: readJsonInt(json, 'slot', 0),
      durationSlots: durationSlots <= 0 ? fallbackDurationSlots : durationSlots,
      tabNumber: readJsonString(json, 'tabNumber', '0'),
      rhythm: rhythm,
      technique: readJsonString(json, 'technique', 'None'),
    );
  }
}

class TabRest {
  final int stringNumber;
  final int slot;
  final int durationSlots;
  final String rhythm;

  const TabRest({
    required this.stringNumber,
    required this.slot,
    required this.durationSlots,
    required this.rhythm,
  });

  Map<String, dynamic> toJson() {
    return {
      'stringNumber': stringNumber,
      'slot': slot,
      'durationSlots': durationSlots,
      'rhythm': rhythm,
    };
  }

  factory TabRest.fromJson(Map<String, dynamic> json) {
    final rhythm = readJsonString(json, 'rhythm', 'Quarter');
    final fallbackDurationSlots = durationSlotsFromRhythmString(rhythm);
    final durationSlots = readJsonInt(
      json,
      'durationSlots',
      fallbackDurationSlots,
    );

    return TabRest(
      stringNumber: clampJsonInt(readJsonInt(json, 'stringNumber', 1), 1, 3),
      slot: readJsonInt(json, 'slot', 0),
      durationSlots: durationSlots <= 0 ? fallbackDurationSlots : durationSlots,
      rhythm: rhythm,
    );
  }
}

class SimileRepeat {
  final int measureIndex;
  final int repeatLength;

  const SimileRepeat({required this.measureIndex, required this.repeatLength});

  Map<String, dynamic> toJson() {
    return {'measureIndex': measureIndex, 'repeatLength': repeatLength};
  }

  factory SimileRepeat.fromJson(Map<String, dynamic> json) {
    return SimileRepeat(
      measureIndex: readJsonInt(json, 'measureIndex', 0),
      repeatLength: readJsonInt(json, 'repeatLength', 1),
    );
  }
}

class LyricEntry {
  final int slot;
  final String text;

  const LyricEntry({required this.slot, required this.text});

  Map<String, dynamic> toJson() {
    return {'slot': slot, 'text': text};
  }

  factory LyricEntry.fromJson(Map<String, dynamic> json) {
    return LyricEntry(
      slot: readJsonInt(json, 'slot', 0),
      text: readJsonString(json, 'text', ''),
    );
  }
}

class SectionLabel {
  final int measureIndex;
  final String text;

  const SectionLabel({required this.measureIndex, required this.text});

  Map<String, dynamic> toJson() {
    return {'measureIndex': measureIndex, 'text': text};
  }

  factory SectionLabel.fromJson(Map<String, dynamic> json) {
    return SectionLabel(
      measureIndex: readJsonInt(json, 'measureIndex', 0),
      text: readJsonString(json, 'text', ''),
    );
  }
}

class SuriSlide {
  final int stringNumber;
  final int startSlot;
  final int endSlot;

  const SuriSlide({
    required this.stringNumber,
    required this.startSlot,
    required this.endSlot,
  });

  Map<String, dynamic> toJson() {
    return {
      'stringNumber': stringNumber,
      'startSlot': startSlot,
      'endSlot': endSlot,
    };
  }

  factory SuriSlide.fromJson(Map<String, dynamic> json) {
    final startSlot = readJsonInt(json, 'startSlot', 0);
    final endSlot = readJsonInt(json, 'endSlot', startSlot);

    return SuriSlide(
      stringNumber: clampJsonInt(readJsonInt(json, 'stringNumber', 1), 1, 3),
      startSlot: startSlot,
      endSlot: endSlot,
    );
  }
}

class NoteAnchor {
  final int stringNumber;
  final int slot;

  const NoteAnchor({required this.stringNumber, required this.slot});
}

class SongSnapshot {
  final String title;
  final String tempoText;
  final String selectedTuning;
  final int selectedTotalMeasures;
  final double selectedZoom;
  final int selectedRepeatLength;

  final List<TabNote> notes;
  final List<TabRest> rests;
  final List<SuriSlide> suriSlides;
  final List<SimileRepeat> simileRepeats;
  final List<LyricEntry> lyricEntries;
  final List<SectionLabel> sectionLabels;

  const SongSnapshot({
    required this.title,
    required this.tempoText,
    required this.selectedTuning,
    required this.selectedTotalMeasures,
    required this.selectedZoom,
    required this.selectedRepeatLength,
    required this.notes,
    required this.rests,
    required this.suriSlides,
    required this.simileRepeats,
    required this.lyricEntries,
    required this.sectionLabels,
  });
}

class SheetImageCapture {
  final Uint8List pngBytes;
  final double logicalWidth;
  final double logicalHeight;

  const SheetImageCapture({
    required this.pngBytes,
    required this.logicalWidth,
    required this.logicalHeight,
  });
}


class LocalErrorLogger {
  static Future<Directory> getAppDataDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final appDirectory = Directory(
      '${documentsDirectory.path}${Platform.pathSeparator}ShamisenTabComposer',
    );

    if (!await appDirectory.exists()) {
      await appDirectory.create(recursive: true);
    }

    return appDirectory;
  }

  static Future<Directory> getLogDirectory() async {
    final appDirectory = await getAppDataDirectory();

    final logDirectory = Directory(
      '${appDirectory.path}${Platform.pathSeparator}ErrorLogs',
    );

    if (!await logDirectory.exists()) {
      await logDirectory.create(recursive: true);
    }

    return logDirectory;
  }

  static Future<File> getErrorLogFile() async {
    final logDirectory = await getLogDirectory();

    return File(
      '${logDirectory.path}${Platform.pathSeparator}shamisen_tab_composer_errors.log',
    );
  }

  static Future<void> writeFlutterError(FlutterErrorDetails details) async {
    await writeError(
      source: 'Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
      extraDetails: details.toStringShort(),
    );
  }

  static Future<void> writeError({
    required String source,
    required Object error,
    StackTrace? stackTrace,
    String? extraDetails,
  }) async {
    try {
      final logFile = await getErrorLogFile();
      final now = DateTime.now().toIso8601String();

      final buffer = StringBuffer()
        ..writeln('[$now]')
        ..writeln('Source: $source')
        ..writeln('Error: $error');

      if (extraDetails != null && extraDetails.trim().isNotEmpty) {
        buffer.writeln('Details: $extraDetails');
      }

      if (stackTrace != null) {
        buffer
          ..writeln('Stack trace:')
          ..writeln(stackTrace);
      }

      buffer.writeln('----------------------------------------');

      await logFile.writeAsString(
        buffer.toString(),
        mode: FileMode.append,
        flush: true,
      );
    } catch (_) {
      // Logging should never crash the app.
    }
  }
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final ScrollController toolbarScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController verticalScrollController = ScrollController();
  final GlobalKey sheetExportKey = GlobalKey();

  final TextEditingController titleController = TextEditingController(
    text: 'Untitled Shamisen Piece',
  );

  final TextEditingController tempoController = TextEditingController(
    text: '120',
  );

  final List<TabNote> notes = [];
  final List<TabRest> rests = [];
  final List<SuriSlide> suriSlides = [];
  final List<SimileRepeat> simileRepeats = [];
  final List<LyricEntry> lyricEntries = [];
  final List<SectionLabel> sectionLabels = [];

  final List<SongSnapshot> undoStack = [];
  final List<SongSnapshot> redoStack = [];

  static const int maxUndoHistory = 50;

  Timer? autoBackupTimer;
  bool hasUnsavedChanges = false;
  String? lastAutoBackupFilePath;

  NoteAnchor? pendingSuriStart;
  NoteAnchor? selectedNoteAnchor;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForAutoBackupOnStartup();
    });
  }

  @override
  void dispose() {
    autoBackupTimer?.cancel();
    toolbarScrollController.dispose();
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
    titleController.dispose();
    tempoController.dispose();
    super.dispose();
  }

  final List<String> shamisenTabNumbers = [
    '0',
    '1',
    '2',
    '3',
    '#',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'b',
    '10',
    '11',
    '12',
    '13',
    '1#',
    '14',
    '15',
    '16',
    '17',
    '18',
  ];

  final List<String> rhythms = [
    'Whole',
    'Half',
    'Quarter',
    'Eighth',
    'Sixteenth',
  ];

  final List<String> tunings = [
    'Honchoshi (本調子)',
    'Niagari (二上り)',
    'Sansagari (三下り)',
  ];

  final List<int> measureOptions = [4, 8, 12, 16, 24, 32];

  final List<int> repeatLengthOptions = [1, 2];

  final List<double> zoomOptions = [0.75, 1.0, 1.25, 1.5];

  final List<String> techniques = [
    'None',

    'LEFT_HAND_HEADER',
    'Hajiki (弾き) - ハ',
    'Uchi (打ち) - ウ',
    'Oshi (押し) - オ',
    'Yuri (揺り) - ユ',
    'Kesu (消す) - 消',

    'RIGHT_HAND_HEADER',
    'Sukui (救い) - ス',
    'Tataki (叩き) - タ / 叩',
    'Bachi (撥) - バ',
    'Tsuke (付) - ツ',
    'Keshi (消し) - ケ',
    'Oshibachi (押し撥) - 押',
    'Suberi (滑り) - 滑',
  ];

  String selectedTabNumber = '0';
  String selectedRhythm = 'Quarter';
  String selectedTechnique = 'None';
  String selectedTuning = 'Honchoshi (本調子)';

  int selectedTotalMeasures = 12;
  double selectedZoom = 1.0;
  int selectedRepeatLength = 1;
  EditorTool selectedTool = EditorTool.write;

  String statusMessage = 'Ready';

  String? lastExportedFilePath;
  String? lastSavedSongFilePath;
  String? currentSongLibraryFilePath;

  static const double leftMargin = 80;
  static const double topMargin = 280;
  static const double stringSpacing = 80;
  static const double baseSlotSpacing = 25;
  static const double stringHitRadius = 34;
  static const double lyricRowYOffset = 110;

  static const int slotsPerBeat = 4;
  static const int beatsPerMeasure = 4;
  static const int slotsPerMeasure = slotsPerBeat * beatsPerMeasure;

  int rhythmToSlots(String rhythm) {
    switch (rhythm) {
      case 'Whole':
        return 16;
      case 'Half':
        return 8;
      case 'Quarter':
        return 4;
      case 'Eighth':
        return 2;
      case 'Sixteenth':
        return 1;
      default:
        return 4;
    }
  }

  String getSongTitle() {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      return 'Untitled Shamisen Piece';
    }

    return title;
  }

  int getTempoBpm() {
    final parsedTempo = int.tryParse(tempoController.text.trim());

    if (parsedTempo == null || parsedTempo <= 0) {
      return 120;
    }

    return parsedTempo;
  }

  double getCurrentSlotSpacing() {
    return baseSlotSpacing * selectedZoom;
  }

  String sanitizeFileName(String input) {
    final trimmed = input.trim();

    if (trimmed.isEmpty) {
      return 'Untitled Shamisen Piece';
    }

    return trimmed
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<Directory> getSongDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final songDirectory = Directory(
      '${documentsDirectory.path}${Platform.pathSeparator}ShamisenTabComposer',
    );

    if (!await songDirectory.exists()) {
      await songDirectory.create(recursive: true);
    }

    return songDirectory;
  }

  Future<File> getAutoBackupFile() async {
    final songDirectory = await getSongDirectory();

    return File(
      '${songDirectory.path}${Platform.pathSeparator}_autosave_backup.json',
    );
  }

  Future<void> checkForAutoBackupOnStartup() async {
    try {
      final backupFile = await getAutoBackupFile();

      if (!await backupFile.exists()) {
        return;
      }

      if (!mounted) return;

      setState(() {
        lastAutoBackupFilePath = backupFile.path;
        statusMessage =
            'Autosave backup found. Use Recover Autosave Backup if you need it.';
      });
    } catch (_) {
      // Silent startup check only.
    }
  }

  void scheduleAutoBackup() {
    hasUnsavedChanges = true;

    autoBackupTimer?.cancel();

    autoBackupTimer = Timer(const Duration(seconds: 1), () {
      writeAutoBackupNow();
    });
  }

  Future<void> writeAutoBackupNow() async {
    try {
      final backupFile = await getAutoBackupFile();

      final songData = buildCurrentSongData();

      const encoder = JsonEncoder.withIndent('  ');
      await backupFile.writeAsString(encoder.convert(songData));

      lastAutoBackupFilePath = backupFile.path;
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Autosave failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage = 'Autosave failed: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<void> recoverAutoBackup() async {
    final canContinue = await confirmUnsavedChangesBefore(
      'recovering the autosave backup',
    );

    if (!canContinue) return;
    if (!mounted) return;

    try {
      final backupFile = await getAutoBackupFile();

      if (!mounted) return;

      if (!await backupFile.exists()) {
        if (!mounted) return;

        setState(() {
          statusMessage = 'No autosave backup found.';
        });
        return;
      }

      if (!mounted) return;

      final shouldRecover = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Recover autosave backup?'),
            content: const Text(
              'This will replace the current sheet with the latest autosave backup. Use this only if you want to restore recent unsaved work.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                child: const Text('Return'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
                child: const Text('Recover Backup'),
              ),
            ],
          );
        },
      );

      if (shouldRecover != true) return;
      if (!mounted) return;

      await loadSongFromFile(backupFile);

      if (!mounted) return;

      setState(() {
        hasUnsavedChanges = true;
        lastAutoBackupFilePath = backupFile.path;
        statusMessage =
            'Recovered autosave backup. Use Save to store it as a normal song.';
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Autosave recovery failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage =
            'Autosave recovery failed: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<void> deleteAutoBackupFileIfExists() async {
    try {
      final backupFile = await getAutoBackupFile();

      if (await backupFile.exists()) {
        await backupFile.delete();
      }

      lastAutoBackupFilePath = null;
    } catch (_) {
      // Do not block normal saving if backup cleanup fails.
    }
  }

  Future<File> getSaveFileForTitle(String title) async {
    final songDirectory = await getSongDirectory();
    final safeTitle = sanitizeFileName(title);

    return File('${songDirectory.path}/$safeTitle.json');
  }

  Future<Directory> getExportDirectory() async {
    final songDirectory = await getSongDirectory();

    final exportDirectory = Directory(
      '${songDirectory.path}${Platform.pathSeparator}Exports',
    );

    if (!await exportDirectory.exists()) {
      await exportDirectory.create(recursive: true);
    }

    return exportDirectory;
  }

  Future<void> revealFileInFileExplorer({
    required String? filePath,
    required String label,
  }) async {
    try {
      if (filePath == null || filePath.trim().isEmpty) {
        setState(() {
          statusMessage = 'No $label file has been created yet.';
        });
        return;
      }

      final file = File(filePath);

      if (!await file.exists()) {
        setState(() {
          statusMessage = 'The last $label file no longer exists: $filePath';
        });
        return;
      }

      if (Platform.isWindows) {
        await Process.start('explorer.exe', ['/select,${file.absolute.path}']);
      } else if (Platform.isMacOS) {
        await Process.start('open', ['-R', file.absolute.path]);
      } else if (Platform.isLinux) {
        await Process.start('xdg-open', [file.parent.absolute.path]);
      } else {
        setState(() {
          statusMessage = 'Reveal file is not supported on this platform.';
        });
        return;
      }

      setState(() {
        statusMessage = 'Opened $label file location.';
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Reveal file failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage =
            'Could not open $label file location: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<void> revealLastExportedFile() async {
    await revealFileInFileExplorer(
      filePath: lastExportedFilePath,
      label: 'exported',
    );
  }

  Future<void> revealLastSavedSongFile() async {
    await revealFileInFileExplorer(
      filePath: lastSavedSongFilePath,
      label: 'saved song',
    );
  }

  Future<void> openDirectoryInFileExplorer({
    required Directory directory,
    required String label,
  }) async {
    try {
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final folderPath = directory.absolute.path;

      if (Platform.isWindows) {
        await Process.start('explorer.exe', [folderPath]);
      } else if (Platform.isMacOS) {
        await Process.start('open', [folderPath]);
      } else if (Platform.isLinux) {
        await Process.start('xdg-open', [folderPath]);
      } else {
        setState(() {
          statusMessage = 'Open folder is not supported on this platform.';
        });
        return;
      }

      setState(() {
        statusMessage = 'Opened $label folder: $folderPath';
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Open folder failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage =
            'Could not open $label folder: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<void> openSongFolder() async {
    final songDirectory = await getSongDirectory();

    await openDirectoryInFileExplorer(
      directory: songDirectory,
      label: 'song library',
    );
  }

  Future<void> openExportFolder() async {
    final exportDirectory = await getExportDirectory();

    await openDirectoryInFileExplorer(
      directory: exportDirectory,
      label: 'export',
    );
  }

  String createExportTimestamp() {
    final now = DateTime.now();

    String twoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    final year = now.year.toString();
    final month = twoDigits(now.month);
    final day = twoDigits(now.day);
    final hour = twoDigits(now.hour);
    final minute = twoDigits(now.minute);
    final second = twoDigits(now.second);

    return '$year-$month-${day}_$hour-$minute-$second';
  }

  Future<SheetImageCapture> captureSheetAsPngBytes() async {
    await WidgetsBinding.instance.endOfFrame;

    final renderObject = sheetExportKey.currentContext?.findRenderObject();

    if (renderObject == null || renderObject is! RenderRepaintBoundary) {
      throw Exception('sheet boundary was not found');
    }

    final logicalWidth = renderObject.size.width;
    final logicalHeight = renderObject.size.height;

    double exportPixelRatio = 2.0;

    if (logicalWidth > 10000) {
      exportPixelRatio = 1.25;
    }

    final image = await renderObject.toImage(pixelRatio: exportPixelRatio);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('could not create PNG data');
    }

    return SheetImageCapture(
      pngBytes: byteData.buffer.asUint8List(),
      logicalWidth: logicalWidth,
      logicalHeight: logicalHeight,
    );
  }

  Future<void> showExportCompleteDialog({
    required File exportFile,
    required String exportType,
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('$exportType export complete'),
          content: SizedBox(
            width: 520,
            child: SelectableText(
              'Saved to:\n${exportFile.path}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Return'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await revealFileInFileExplorer(
                  filePath: exportFile.path,
                  label: exportType.toLowerCase(),
                );
              },
              icon: const Icon(Icons.folder_open),
              label: const Text('Open File Location'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showSaveAsCompleteDialog({
    required File savedFile,
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Save As complete'),
          content: SizedBox(
            width: 520,
            child: SelectableText(
              'Saved to:\n${savedFile.path}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Return'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await revealFileInFileExplorer(
                  filePath: savedFile.path,
                  label: 'saved song copy',
                );
              },
              icon: const Icon(Icons.folder_open),
              label: const Text('Open File Location'),
            ),
          ],
        );
      },
    );
  }

  Future<void> exportSheetAsPng() async {
    try {
      setState(() {
        statusMessage = 'Exporting PNG...';
      });

      final capture = await captureSheetAsPngBytes();

      final exportDirectory = await getExportDirectory();
      final safeTitle = sanitizeFileName(getSongTitle());
      final timestamp = createExportTimestamp();

      final exportFile = File(
        '${exportDirectory.path}/${safeTitle}_$timestamp.png',
      );

      await exportFile.writeAsBytes(capture.pngBytes);

      setState(() {
        lastExportedFilePath = exportFile.path;
        statusMessage = 'Exported PNG: ${exportFile.path}';
      });

      await showExportCompleteDialog(
        exportFile: exportFile,
        exportType: 'PNG',
      );
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'PNG export failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage = 'Export failed: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<void> exportSheetAsPdf() async {
    try {
      setState(() {
        statusMessage = 'Exporting PDF...';
      });

      final capture = await captureSheetAsPngBytes();

      final document = pw.Document();
      final sheetImage = pw.MemoryImage(capture.pngBytes);

      document.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
            capture.logicalWidth,
            capture.logicalHeight,
            marginAll: 0,
          ),
          build: (context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Image(sheetImage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );

      final exportDirectory = await getExportDirectory();
      final safeTitle = sanitizeFileName(getSongTitle());
      final timestamp = createExportTimestamp();

      final exportFile = File(
        '${exportDirectory.path}/${safeTitle}_$timestamp.pdf',
      );

      await exportFile.writeAsBytes(await document.save());

      setState(() {
        lastExportedFilePath = exportFile.path;
        statusMessage = 'Exported PDF: ${exportFile.path}';
      });

      await showExportCompleteDialog(
        exportFile: exportFile,
        exportType: 'PDF',
      );
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'PDF export failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage = 'PDF export failed: ${readableErrorMessage(error)}';
      });
    }
  }

  String displayNameFromPath(String filePath) {
    final fileName = filePath.split(Platform.pathSeparator).last;

    if (fileName.toLowerCase().endsWith('.json')) {
      return fileName.substring(0, fileName.length - 5);
    }

    return fileName;
  }

  String getCurrentFileStateText() {
    if (currentSongLibraryFilePath != null) {
      final displayName = displayNameFromPath(currentSongLibraryFilePath!);
      return 'Library file: $displayName';
    }

    if (hasUnsavedChanges) {
      return 'Not saved to library';
    }

    return 'No library file selected';
  }

  String displayNameFromFile(File file) {
    final fileName = file.uri.pathSegments.last;

    if (fileName.toLowerCase().endsWith('.json')) {
      return fileName.substring(0, fileName.length - 5);
    }

    return fileName;
  }

  String ensureJsonExtension(String path) {
    if (path.toLowerCase().endsWith('.json')) {
      return path;
    }

    return '$path.json';
  }

  String ensureTxtExtension(String path) {
    final lowerPath = path.toLowerCase();

    if (lowerPath.endsWith('.txt') || lowerPath.endsWith('.log')) {
      return path;
    }

    return '$path.txt';
  }

  String createErrorReportFileName() {
    return 'ShamisenTabComposer_ErrorReport_${createExportTimestamp()}.txt';
  }

  Future<void> exportErrorReport() async {
    try {
      final logFile = await LocalErrorLogger.getErrorLogFile();

      if (!await logFile.exists()) {
        if (!mounted) return;

        setState(() {
          statusMessage = 'No error log has been created yet.';
        });
        return;
      }

      final logContents = await logFile.readAsString();

      if (logContents.trim().isEmpty) {
        if (!mounted) return;

        setState(() {
          statusMessage = 'The error log is currently empty.';
        });
        return;
      }

      final textTypeGroup = XTypeGroup(
        label: 'Text error report',
        extensions: <String>['txt', 'log'],
      );

      final saveLocation = await getSaveLocation(
        suggestedName: createErrorReportFileName(),
        acceptedTypeGroups: <XTypeGroup>[textTypeGroup],
      );

      if (saveLocation == null) {
        if (!mounted) return;

        setState(() {
          statusMessage = 'Export Error Report cancelled.';
        });
        return;
      }

      final exportPath = ensureTxtExtension(saveLocation.path);
      final exportFile = File(exportPath);

      await exportFile.writeAsString(logContents);

      if (!mounted) return;

      setState(() {
        statusMessage = 'Exported error report: $exportPath';
      });

      await revealFileInFileExplorer(
        filePath: exportPath,
        label: 'error report',
      );
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Export Error Report failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage = 'Export Error Report failed: ${readableErrorMessage(error)}';
      });
    }
  }

  Map<String, dynamic> buildCurrentSongData() {
    final songTitle = getSongTitle();

    return {
      'fileFormatVersion': currentSongFileVersion,
      'createdWithApp': appName,
      'appVersion': appVersion,
      'title': songTitle,
      'tuning': selectedTuning,
      'tempoBpm': getTempoBpm(),
      'totalMeasures': selectedTotalMeasures,
      'zoom': selectedZoom,
      'notes': notes.map((note) => note.toJson()).toList(),
      'rests': rests.map((rest) => rest.toJson()).toList(),
      'suriSlides': suriSlides.map((slide) => slide.toJson()).toList(),
      'simileRepeats': simileRepeats.map((repeat) => repeat.toJson()).toList(),
      'lyrics': lyricEntries.map((lyric) => lyric.toJson()).toList(),
      'sectionLabels': sectionLabels.map((label) => label.toJson()).toList(),
    };
  }

  Future<bool> confirmOverwriteSongFile({
    required File file,
    required String songTitle,
  }) async {
    if (!await file.exists()) {
      return true;
    }

    if (currentSongLibraryFilePath == file.path) {
      return true;
    }

    if (!mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Overwrite saved song?'),
          content: Text(
            'A saved song named "$songTitle" already exists.\n\n'
            'Do you want to replace it?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Return'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Overwrite'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> saveSong() async {
    try {
      final songTitle = getSongTitle();
      final file = await getSaveFileForTitle(songTitle);

      if (!mounted) return;

      final canOverwrite = await confirmOverwriteSongFile(
        file: file,
        songTitle: songTitle,
      );

      if (!canOverwrite) {
        if (!mounted) return;

        setState(() {
          statusMessage = 'Save cancelled to avoid overwriting "$songTitle".';
        });
        return;
      }

      final songData = buildCurrentSongData();

      const encoder = JsonEncoder.withIndent('  ');
      await file.writeAsString(encoder.convert(songData));

      await deleteAutoBackupFileIfExists();

      if (!mounted) return;

      setState(() {
        lastSavedSongFilePath = file.path;
        currentSongLibraryFilePath = file.path;
        hasUnsavedChanges = false;
        statusMessage = 'Saved "$songTitle": ${file.path}';
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Save song failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage = 'Save failed: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<void> exportSongJsonFile() async {
    try {
      final jsonTypeGroup = XTypeGroup(
        label: 'Shamisen song JSON',
        extensions: <String>['json'],
      );

      final safeTitle = sanitizeFileName(getSongTitle());

      final saveLocation = await getSaveLocation(
        suggestedName: '$safeTitle.json',
        acceptedTypeGroups: <XTypeGroup>[jsonTypeGroup],
      );

      if (saveLocation == null) {
        setState(() {
        statusMessage = 'Save As cancelled.';
        });
        return;
      }

      final exportPath = ensureJsonExtension(saveLocation.path);
      final exportFile = File(exportPath);

      final songData = buildCurrentSongData();

      const encoder = JsonEncoder.withIndent('  ');
      await exportFile.writeAsString(encoder.convert(songData));

      setState(() {
        lastSavedSongFilePath = exportFile.path;
        statusMessage = 'Saved song copy: $exportPath';
      });

      await showSaveAsCompleteDialog(savedFile: exportFile);
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Save As failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage = 'Save As failed: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<void> importSongJsonFile() async {
    final canContinue = await confirmUnsavedChangesBefore(
      'importing another song file',
    );

    if (!canContinue) return;
    if (!mounted) return;

    try {
      final jsonTypeGroup = XTypeGroup(
        label: 'Shamisen song JSON',
        extensions: <String>['json'],
      );

      final selectedFile = await openFile(
        acceptedTypeGroups: <XTypeGroup>[jsonTypeGroup],
      );

      if (selectedFile == null) {
        setState(() {
          statusMessage = 'Open File cancelled.';
        });
        return;
      }

      final importedFile = File(selectedFile.path);

      if (!await importedFile.exists()) {
        setState(() {
          statusMessage = 'Import failed: selected file does not exist.';
        });
        return;
      }

      await loadSongFromFile(importedFile);

      if (!mounted) return;

      scheduleAutoBackup();

      setState(() {
        hasUnsavedChanges = true;
        statusMessage =
            'Opened song file: ${importedFile.path}. Use Save to add it to your song library.';
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Open File failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage = 'Open File failed: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<List<File>> getSavedSongFiles() async {
    final songDirectory = await getSongDirectory();

    final files = songDirectory.listSync().whereType<File>().where((file) {
      final fileName = file.uri.pathSegments.last.toLowerCase();

      return fileName.endsWith('.json') && fileName != '_autosave_backup.json';
    }).toList();

    files.sort((a, b) {
      final aModified = a.lastModifiedSync();
      final bModified = b.lastModifiedSync();
      return bModified.compareTo(aModified);
    });

    return files;
  }

  bool isCurrentLibrarySongFile(File file) {
    return currentSongLibraryFilePath != null &&
        currentSongLibraryFilePath == file.path;
  }

  Future<void> deleteSavedSongFile(File file) async {
    try {
      final deletedCurrentSong = isCurrentLibrarySongFile(file);
      final deletedSongName = displayNameFromFile(file);

      if (await file.exists()) {
        await file.delete();
      }

      setState(() {
        if (deletedCurrentSong) {
          currentSongLibraryFilePath = null;
          lastSavedSongFilePath = null;
          hasUnsavedChanges = true;
          statusMessage =
              'Deleted "$deletedSongName". The current sheet is still open, but it is no longer saved.';
        } else {
          statusMessage = 'Deleted saved song "$deletedSongName".';
        }
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Delete saved song failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage = 'Delete failed: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<void> loadSong() async {
    final canContinue = await confirmUnsavedChangesBefore(
      'loading another song',
    );

    if (!canContinue) return;
    if (!mounted) return;

    try {
      List<File> savedFiles = await getSavedSongFiles();

      if (savedFiles.isEmpty) {
        setState(() {
          statusMessage = 'No saved songs found.';
        });
        return;
      }

      if (!mounted) return;

      final selectedFile = await showDialog<File>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Load Song'),
                content: SizedBox(
                  width: 460,
                  height: 380,
                  child: savedFiles.isEmpty
                      ? const Center(child: Text('No saved songs found.'))
                      : ListView.builder(
                          itemCount: savedFiles.length,
                          itemBuilder: (context, index) {
                            final file = savedFiles[index];
                            final displayName = displayNameFromFile(file);
                            final modified = file.lastModifiedSync();

                            return ListTile(
                              leading: const Icon(Icons.music_note),
                              title: Text(displayName),
                              subtitle: Text('Modified: $modified'),
                              onTap: () {
                                Navigator.of(dialogContext).pop(file);
                              },
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                                tooltip: 'Delete saved song',
                                onPressed: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: dialogContext,
                                    builder: (confirmContext) {
                                      return AlertDialog(
                                        title: const Text('Delete saved song?'),
                                        content: Text(
                                          isCurrentLibrarySongFile(file)
                                              ? 'Delete "$displayName"? This is the song currently open in the editor.\n\nThe sheet will stay open, but it will become unsaved.'
                                              : 'Delete "$displayName"? This cannot be undone.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(
                                                confirmContext,
                                              ).pop(false);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(
                                                confirmContext,
                                              ).pop(true);
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (shouldDelete != true) return;

                                  await deleteSavedSongFile(file);

                                  final refreshedFiles =
                                      await getSavedSongFiles();

                                  setDialogState(() {
                                    savedFiles = refreshedFiles;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(null);
                    },
                    child: const Text('Return'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (selectedFile == null) return;

      await loadSongFromFile(
        selectedFile,
        isLibraryFile: true,
      );
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Load song dialog failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage = 'Load failed: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<void> loadSongFromFile(
    File file, {
    bool isLibraryFile = false,
  }) async {
    try {
      if (!await file.exists()) {
        if (!mounted) return;

        setState(() {
          statusMessage = 'Load failed: selected song file no longer exists.';
        });
        return;
      }

      final contents = await file.readAsString();

      final decodedData = jsonDecode(contents);
      final data = asStringKeyedMap(decodedData);

      if (data == null) {
        throw const FormatException(
          'This JSON file is not a valid Shamisen song file.',
        );
      }

      final fileFormatVersionData = data['fileFormatVersion'];
      int fileFormatVersion = 1;

      if (fileFormatVersionData is int) {
        fileFormatVersion = fileFormatVersionData;
      } else if (fileFormatVersionData is String) {
        fileFormatVersion = int.tryParse(fileFormatVersionData.trim()) ?? 1;
      }

      if (fileFormatVersion > currentSongFileVersion) {
        if (!mounted) return;

        setState(() {
          statusMessage =
              'Load failed: this song file uses a newer file format. Please update the app.';
        });
        return;
      }

      final loadedTitle = readJsonString(
        data,
        'title',
        'Untitled Shamisen Piece',
      );

      final loadedTuning = readJsonString(
        data,
        'tuning',
        'Honchoshi (本調子)',
      );

      final loadedTempo = data['tempoBpm'];
      String loadedTempoText = '120';

      if (loadedTempo is int) {
        loadedTempoText = loadedTempo.toString();
      } else if (loadedTempo is String) {
        final parsedTempo = int.tryParse(loadedTempo.trim());
        loadedTempoText = parsedTempo == null || parsedTempo <= 0
            ? '120'
            : parsedTempo.toString();
      }

      final loadedTotalMeasures = data['totalMeasures'];
      int loadedMeasureCount = 12;

      if (loadedTotalMeasures is int &&
          measureOptions.contains(loadedTotalMeasures)) {
        loadedMeasureCount = loadedTotalMeasures;
      } else if (loadedTotalMeasures is String) {
        final parsedMeasureCount = int.tryParse(loadedTotalMeasures.trim());

        if (parsedMeasureCount != null &&
            measureOptions.contains(parsedMeasureCount)) {
          loadedMeasureCount = parsedMeasureCount;
        }
      }

      final loadedZoom = readJsonDouble(data, 'zoom', 1.0);
      double loadedZoomValue = 1.0;

      if (zoomOptions.contains(loadedZoom)) {
        loadedZoomValue = loadedZoom;
      }

      final totalSlots = loadedMeasureCount * slotsPerMeasure;

      final loadedNotes = readJsonObjectList(data['notes'])
          .map(TabNote.fromJson)
          .where(
            (note) =>
                note.slot >= 0 &&
                note.slot < totalSlots &&
                note.durationSlots > 0 &&
                note.slot + note.durationSlots <= totalSlots,
          )
          .toList();

      final loadedRests = readJsonObjectList(data['rests'])
          .map(TabRest.fromJson)
          .where(
            (rest) =>
                rest.slot >= 0 &&
                rest.slot < totalSlots &&
                rest.durationSlots > 0 &&
                rest.slot + rest.durationSlots <= totalSlots,
          )
          .toList();

      final loadedSuriSlides = readJsonObjectList(data['suriSlides'])
          .map(SuriSlide.fromJson)
          .where(
            (slide) =>
                slide.startSlot >= 0 &&
                slide.endSlot >= 0 &&
                slide.startSlot < totalSlots &&
                slide.endSlot < totalSlots &&
                slide.startSlot != slide.endSlot,
          )
          .toList();

      final loadedSimileRepeats = readJsonObjectList(data['simileRepeats'])
          .map(SimileRepeat.fromJson)
          .where(
            (repeat) => repeat.repeatLength == 1 || repeat.repeatLength == 2,
          )
          .where(
            (repeat) =>
                repeat.measureIndex >= 0 &&
                repeat.measureIndex + repeat.repeatLength <= loadedMeasureCount,
          )
          .toList();

      final loadedLyrics = readJsonObjectList(data['lyrics'])
          .map(LyricEntry.fromJson)
          .where(
            (lyric) =>
                lyric.slot >= 0 &&
                lyric.slot < totalSlots &&
                lyric.text.trim().isNotEmpty,
          )
          .toList();

      final loadedSectionLabels = readJsonObjectList(data['sectionLabels'])
          .map(SectionLabel.fromJson)
          .where(
            (label) =>
                label.measureIndex >= 0 &&
                label.measureIndex < loadedMeasureCount &&
                label.text.trim().isNotEmpty,
          )
          .toList();

      if (!mounted) return;

      setState(() {
        titleController.text = loadedTitle;

        if (tunings.contains(loadedTuning)) {
          selectedTuning = loadedTuning;
        } else {
          selectedTuning = 'Honchoshi (本調子)';
        }

        tempoController.text = loadedTempoText;
        selectedTotalMeasures = loadedMeasureCount;
        selectedZoom = loadedZoomValue;

        notes
          ..clear()
          ..addAll(loadedNotes);

        rests
          ..clear()
          ..addAll(loadedRests);

        suriSlides
          ..clear()
          ..addAll(loadedSuriSlides);

        simileRepeats
          ..clear()
          ..addAll(loadedSimileRepeats);

        lyricEntries
          ..clear()
          ..addAll(loadedLyrics);

        sectionLabels
          ..clear()
          ..addAll(loadedSectionLabels);

        pendingSuriStart = null;
        selectedNoteAnchor = null;

        undoStack.clear();
        redoStack.clear();

        hasUnsavedChanges = false;

        if (isLibraryFile) {
          currentSongLibraryFilePath = file.path;
          lastSavedSongFilePath = file.path;
        } else {
          currentSongLibraryFilePath = null;
        }

        statusMessage = 'Loaded "$loadedTitle".';
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Load song failed: ${file.path}',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        statusMessage = 'Load failed: ${readableErrorMessage(error)}';
      });
    }
  }

  Future<bool> confirmUnsavedChangesBefore(String actionName) async {
    if (!hasUnsavedChanges) {
      return true;
    }

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Unsaved changes'),
          content: Text(
            'You have unsaved changes. What do you want to do before $actionName?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('cancel');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('continue');
              },
              child: const Text('Continue Without Saving'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('save');
              },
              child: const Text('Save First'),
            ),
          ],
        );
      },
    );

    if (result == 'save') {
      await saveSong();

      if (!mounted) return false;

      return !hasUnsavedChanges;
    }

    return result == 'continue';
  }

  Future<void> newSong() async {
    final canContinue = await confirmUnsavedChangesBefore(
      'starting a new song',
    );

    if (!canContinue) return;
    if (!mounted) return;

    final shouldCreateNew = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Start a new song?'),
          content: const Text(
            'This will clear the current sheet and reset the title, tuning, tempo, measures, and zoom.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('New Song'),
            ),
          ],
        );
      },
    );

    if (shouldCreateNew != true) return;
    if (!mounted) return;

    saveUndoSnapshot();

    setState(() {
      titleController.text = 'Untitled Shamisen Piece';
      tempoController.text = '120';

      selectedTuning = 'Honchoshi (本調子)';
      selectedTotalMeasures = 12;
      selectedZoom = 1.0;
      selectedRepeatLength = 1;

      selectedTabNumber = '0';
      selectedRhythm = 'Quarter';
      selectedTechnique = 'None';
      selectedTool = EditorTool.write;

      notes.clear();
      rests.clear();
      suriSlides.clear();
      simileRepeats.clear();
      lyricEntries.clear();
      sectionLabels.clear();

      pendingSuriStart = null;
      selectedNoteAnchor = null;

      currentSongLibraryFilePath = null;
      lastSavedSongFilePath = null;
      lastExportedFilePath = null;

      hasUnsavedChanges = true;
      statusMessage = 'Started new song.';
    });
  }

  void showAboutAppDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('About Shamisen Tab Composer'),
          content: const SizedBox(
            width: 460,
            child: Text(
              'Shamisen Tab Composer Beta 0.2.0\n\n'
              'A desktop shamisen tablature editor for creating, saving, loading, and exporting shamisen tab sheets.\n\n'
              'Current beta features:\n'
              '- Note input\n'
              '- Rests\n'
              '- Suri slide markings\n'
              '- Lyrics under notes/rests\n'
              '- Section labels\n'
              '- Simile repeat marks\n'
              '- Save/load song library\n'
              '- Save As and Open File support\n'
              '- PNG/PDF export\n'
              '- Undo/Redo\n'
              '- Keyboard shortcuts\n'
              '- Autosave backup and recovery\n\n'
              'Beta notice:\n'
              'This version is ready for public testing. File formats, layout, and export behavior may still change before the stable 1.0 release.',
              style: TextStyle(fontSize: 14, height: 1.35),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Return'),
            ),
          ],
        );
      },
    );
  }

  void showHelpDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('How to Use Shamisen Tab Composer'),
          content: const SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Text(
                'Basic Workflow\n'
                '1. Choose a tab number, rhythm, and technique.\n'
                '2. Click directly on a string line to place the tab number.\n'
                '3. Click an existing note in Write mode to select and edit it.\n'
                '4. Use Save to store the song in your local song library.\n'
                '5. Use Load to open a saved song from your local song library.\n'
                '6. Use Save As to save a song file anywhere on your computer.\n'
                '7. Use Open File to open a song file from anywhere on your computer.\n\n'
                'Tools\n'
                '8. Use PNG or PDF export to share or print the current sheet.\n\n'
                'Autosave Recovery\n'
                'The app keeps a local autosave backup while you work.\n'
                'Use Recover Autosave Backup if the app closes unexpectedly or you need to restore recent work.\n\n'
                'Write: Place notes or select existing notes.\n'
                'Erase: Smart erase for notes, rests, lyrics, Suri slides, repeats, and section labels.\n'
                'Suri: Click two notes on the same string to add or remove a slide mark.\n'
                'Rest: Place a rhythmic rest on a string line.\n'
                'Repeat: Click a measure to add or remove a simile repeat mark.\n'
                'Lyric: Click a note/rest timing slot to add lyrics under it.\n'
                'Section: Click a measure to add labels like Intro, Verse, or Chorus.\n\n'
                'Song Settings\n'
                'Title: Used for the sheet title and save file name.\n'
                'Tuning: Choose Honchoshi, Niagari, or Sansagari.\n'
                'BPM: Set the tempo.\n'
                'Measures: Control the length of the song.\n'
                'Zoom: Adjust horizontal spacing.\n'
                'Repeat: Choose one-measure or two-measure simile repeat.\n\n'
                'Important Notes\n'
                'Lyrics can only be added under an existing note or rest.\n'
                'Suri slides must connect two notes on the same string.\n'
                'Repeat marks cannot be placed over measures that already contain notes or rests.\n'
                'New Song resets everything.\n'
                'Clear Song clears the notation but does not reset all song settings.',
                style: TextStyle(fontSize: 14, height: 1.35),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Return'),
            ),
          ],
        );
      },
    );
  }

  void showChangelogDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Version History'),
          content: const SizedBox(
            width: 560,
            height: 460,
            child: SingleChildScrollView(
              child: Text(
                'Shamisen Tab Composer Beta 0.2.0\n\n'
                'First public beta release candidate for testing the core tablature editor.\n\n'
                'Included features:\n'
                '- Shamisen tab note input\n'
                '- Three-string sheet layout\n'
                '- Rhythm support: Whole, Half, Quarter, Eighth, Sixteenth\n'
                '- Tab number selection\n'
                '- Shamisen tuning metadata\n'
                '- BPM metadata\n'
                '- Measure count control\n'
                '- Horizontal zoom control\n'
                '- Left-hand technique markings\n'
                '- Right-hand technique markings\n'
                '- Oshibachi and Suberi above-note markings\n'
                '- Suri slide markings\n'
                '- Rest input\n'
                '- Lyric input under notes and rests\n'
                '- Section labels\n'
                '- One-measure simile repeat marks\n'
                '- Two-measure simile repeat marks\n'
                '- Smart erase mode\n'
                '- Selected-note editing\n'
                '- Undo and redo\n'
                '- Save and load local song files\n'
                '- Delete saved songs from the Load window\n'
                '- Save As song file support\n'
                '- Open File song file support\n'
                '- PNG export\n'
                '- PDF export\n'
                '- Open song library folder\n'
                '- Open export folder\n'
                '- Reveal last saved song file\n'
                '- Reveal last exported file\n'
                '- Keyboard shortcuts\n'
                '- Help dialog\n'
                '- About dialog\n\n'
                '- Autosave backup\n'
                '- Autosave recovery button\n'
                '- Unsaved changes status\n'
                'Known Beta Limitations:\n'
                '- Windows desktop is the main testing platform right now.\n'
                '- Export layout may need improvement for long songs.\n'
                '- PDF export currently captures the visual sheet as displayed.\n'
                '- Mobile layout is not ready.\n'
                '- Save file format may change before stable release.\n'
                '- More shamisen notation symbols still need to be added.\n\n'
                'Next Planned Version: Beta 0.3\n\n'
                'Planned improvements:\n'
                '- Cleaner toolbar organization\n'
                '- Better exported sheet layout\n'
                '- More notation symbols\n'
                '- Sample song files\n'
                '- Better beginner instructions\n'
                '- More testing feedback support',
                style: TextStyle(fontSize: 14, height: 1.35),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Return'),
            ),
          ],
        );
      },
    );
  }

  SongSnapshot createSongSnapshot() {
    return SongSnapshot(
      title: titleController.text,
      tempoText: tempoController.text,
      selectedTuning: selectedTuning,
      selectedTotalMeasures: selectedTotalMeasures,
      selectedZoom: selectedZoom,
      selectedRepeatLength: selectedRepeatLength,
      notes: List<TabNote>.from(notes),
      rests: List<TabRest>.from(rests),
      suriSlides: List<SuriSlide>.from(suriSlides),
      simileRepeats: List<SimileRepeat>.from(simileRepeats),
      lyricEntries: List<LyricEntry>.from(lyricEntries),
      sectionLabels: List<SectionLabel>.from(sectionLabels),
    );
  }

  void restoreSongSnapshot(SongSnapshot snapshot) {
    titleController.text = snapshot.title;
    tempoController.text = snapshot.tempoText;

    selectedTuning = snapshot.selectedTuning;
    selectedTotalMeasures = snapshot.selectedTotalMeasures;
    selectedZoom = snapshot.selectedZoom;
    selectedRepeatLength = snapshot.selectedRepeatLength;

    notes
      ..clear()
      ..addAll(snapshot.notes);

    rests
      ..clear()
      ..addAll(snapshot.rests);

    suriSlides
      ..clear()
      ..addAll(snapshot.suriSlides);

    simileRepeats
      ..clear()
      ..addAll(snapshot.simileRepeats);

    lyricEntries
      ..clear()
      ..addAll(snapshot.lyricEntries);

    sectionLabels
      ..clear()
      ..addAll(snapshot.sectionLabels);

    pendingSuriStart = null;
    selectedNoteAnchor = null;
  }

  void saveUndoSnapshot() {
    undoStack.add(createSongSnapshot());
    redoStack.clear();

    if (undoStack.length > maxUndoHistory) {
      undoStack.removeAt(0);
    }

    scheduleAutoBackup();
  }

  void undoLastAction() {
    if (undoStack.isEmpty) {
      setState(() {
        statusMessage = 'Nothing to undo.';
      });
      return;
    }

    final currentSnapshot = createSongSnapshot();
    final previousSnapshot = undoStack.removeLast();

    redoStack.add(currentSnapshot);

    autoBackupTimer?.cancel();

    setState(() {
      restoreSongSnapshot(previousSnapshot);
      hasUnsavedChanges = true;
      statusMessage = 'Undid last action.';
    });

    scheduleAutoBackup();
  }

  void redoLastAction() {
    if (redoStack.isEmpty) {
      setState(() {
        statusMessage = 'Nothing to redo.';
      });
      return;
    }

    final currentSnapshot = createSongSnapshot();
    final nextSnapshot = redoStack.removeLast();

    undoStack.add(currentSnapshot);

    autoBackupTimer?.cancel();

    setState(() {
      restoreSongSnapshot(nextSnapshot);
      hasUnsavedChanges = true;
      statusMessage = 'Redid last action.';
    });

    scheduleAutoBackup();
  }

  void clearCurrentSelection() {
    setState(() {
      pendingSuriStart = null;
      selectedNoteAnchor = null;
      statusMessage = 'Cleared selection.';
    });
  }

  void selectToolFromShortcut(EditorTool tool) {
    setState(() {
      selectedTool = tool;
      pendingSuriStart = null;

      if (tool != EditorTool.write) {
        selectedNoteAnchor = null;
      }

      switch (tool) {
        case EditorTool.write:
          statusMessage = 'Write mode.';
          break;
        case EditorTool.erase:
          statusMessage =
              'Erase mode: click notes, rests, lyrics, Suri slides, repeats, or section labels.';
          break;
        case EditorTool.suri:
          statusMessage =
              'Suri mode: click the starting note, then ending note.';
          break;
        case EditorTool.rest:
          statusMessage = 'Rest mode: click a line to place a rest.';
          break;
        case EditorTool.repeat:
          statusMessage =
              'Repeat mode: click a measure to toggle a simile mark.';
          break;
        case EditorTool.lyric:
          statusMessage =
              'Lyric mode: click a note/rest timing slot to add or edit lyrics.';
          break;
        case EditorTool.section:
          statusMessage = 'Section mode: click a measure to add/edit a label.';
          break;
      }
    });
  }

  Future<void> clearSong() async {
    final canContinue = await confirmUnsavedChangesBefore(
      'clearing the current song',
    );

    if (!canContinue) return;
    if (!mounted) return;

    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear current song?'),
          content: const Text(
            'This will remove all notes, rests, Suri slides, lyrics, repeats, and section labels. Song settings will stay the same.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Clear Song'),
            ),
          ],
        );
      },
    );

    if (shouldClear != true) return;
    if (!mounted) return;

    saveUndoSnapshot();

    setState(() {
      notes.clear();
      rests.clear();
      suriSlides.clear();
      simileRepeats.clear();
      lyricEntries.clear();
      sectionLabels.clear();

      pendingSuriStart = null;
      selectedNoteAnchor = null;

      hasUnsavedChanges = true;
      statusMessage = 'Cleared song.';
    });
  }

  bool notesOverlap({
    required int startA,
    required int durationA,
    required int startB,
    required int durationB,
  }) {
    final endA = startA + durationA;
    final endB = startB + durationB;

    return startA < endB && startB < endA;
  }

  int? getStringFromY(double y) {
    int closestString = -1;
    double closestDistance = double.infinity;

    for (int i = 0; i < 3; i++) {
      final stringY = topMargin + i * stringSpacing;
      final distance = (y - stringY).abs();

      if (distance < closestDistance) {
        closestDistance = distance;
        closestString = i + 1;
      }
    }

    if (closestDistance > stringHitRadius) {
      return null;
    }

    return closestString;
  }

  int? getSlotFromX(double x) {
    final currentSlotSpacing = getCurrentSlotSpacing();

    if (x < leftMargin - currentSlotSpacing / 2) return null;

    final slot = ((x - leftMargin) / currentSlotSpacing).round();
    final totalSlots = selectedTotalMeasures * slotsPerMeasure;

    if (slot < 0 || slot >= totalSlots) return null;

    return slot;
  }

  int getMeasureIndexFromSlot(int slot) {
    return slot ~/ slotsPerMeasure;
  }

  int findLyricIndexAtSlot(int slot) {
    return lyricEntries.indexWhere((lyric) => lyric.slot == slot);
  }

  double getLyricRowY() {
    return topMargin + stringSpacing * 2 + lyricRowYOffset;
  }

  bool isNearLyricRow(double y) {
    return (y - getLyricRowY()).abs() <= 28;
  }

  int findSimileRepeatIndexAtSlot(int slot) {
    final measureIndex = getMeasureIndexFromSlot(slot);

    return simileRepeats.indexWhere((repeat) {
      final repeatStartMeasure = repeat.measureIndex;
      final repeatEndMeasure = repeat.measureIndex + repeat.repeatLength;

      return measureIndex >= repeatStartMeasure &&
          measureIndex < repeatEndMeasure;
    });
  }

  int findSuriSlideIndexNearPosition(Offset position) {
    final currentSlotSpacing = getCurrentSlotSpacing();

    for (int i = 0; i < suriSlides.length; i++) {
      final slide = suriSlides[i];

      final startX = leftMargin + slide.startSlot * currentSlotSpacing;
      final endX = leftMargin + slide.endSlot * currentSlotSpacing;
      final stringY = topMargin + (slide.stringNumber - 1) * stringSpacing;

      final minX = startX < endX ? startX : endX;
      final maxX = startX < endX ? endX : startX;

      final isInsideHorizontalRange =
          position.dx >= minX - 16 && position.dx <= maxX + 16;

      final isNearArcHeight =
          position.dy >= stringY - 100 && position.dy <= stringY - 32;

      if (isInsideHorizontalRange && isNearArcHeight) {
        return i;
      }
    }

    return -1;
  }

  bool slotHasNoteOrRestStart(int slot) {
    final hasNoteStart = notes.any((note) => note.slot == slot);
    final hasRestStart = rests.any((rest) => rest.slot == slot);

    return hasNoteStart || hasRestStart;
  }

  Future<void> handleLyricClick(int slot) async {
    final totalSlots = selectedTotalMeasures * slotsPerMeasure;

    if (slot < 0 || slot >= totalSlots) {
      setState(() {
        statusMessage = 'Click inside the song measure area.';
      });
      return;
    }

    final existingIndex = findLyricIndexAtSlot(slot);

    if (existingIndex < 0 && !slotHasNoteOrRestStart(slot)) {
      setState(() {
        statusMessage = 'Place a note or rest first, then add lyrics under it.';
      });
      return;
    }

    final existingText = existingIndex >= 0
        ? lyricEntries[existingIndex].text
        : '';

    String pendingLyricText = existingText;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Lyric'),
          content: TextFormField(
            initialValue: existingText,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Lyric text',
              hintText: 'Example: sakura / さくら / 桜',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              pendingLyricText = value;
            },
            onFieldSubmitted: (value) {
              Navigator.of(dialogContext).pop(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(null);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('');
              },
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(pendingLyricText);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == null) return;
    if (!mounted) return;

    final trimmedText = result.trim();

    if (trimmedText.isEmpty && existingIndex < 0) {
      setState(() {
        statusMessage = 'No lyric added.';
        pendingSuriStart = null;
        selectedNoteAnchor = null;
      });
      return;
    }

    saveUndoSnapshot();

    setState(() {
      if (trimmedText.isEmpty) {
        lyricEntries.removeAt(existingIndex);
        statusMessage = 'Deleted lyric.';

        pendingSuriStart = null;
        selectedNoteAnchor = null;
        return;
      }

      final newLyric = LyricEntry(slot: slot, text: trimmedText);

      if (existingIndex >= 0) {
        lyricEntries[existingIndex] = newLyric;
        statusMessage = 'Updated lyric.';
      } else {
        lyricEntries.add(newLyric);
        statusMessage = 'Added lyric under note/rest.';
      }

      pendingSuriStart = null;
      selectedNoteAnchor = null;
    });
  }

  int findSectionLabelIndexAtMeasure(int measureIndex) {
    return sectionLabels.indexWhere(
      (label) => label.measureIndex == measureIndex,
    );
  }

  Future<void> handleSectionClick(int slot) async {
    final measureIndex = getMeasureIndexFromSlot(slot);

    if (measureIndex < 0 || measureIndex >= selectedTotalMeasures) {
      setState(() {
        statusMessage = 'Click inside the song measure area.';
      });
      return;
    }

    final existingIndex = findSectionLabelIndexAtMeasure(measureIndex);
    final existingText = existingIndex >= 0
        ? sectionLabels[existingIndex].text
        : '';

    String pendingSectionText = existingText;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Section label for measure ${measureIndex + 1}'),
          content: TextFormField(
            initialValue: existingText,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Section label',
              hintText: 'Example: Intro / Verse / Chorus',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              pendingSectionText = value;
            },
            onFieldSubmitted: (value) {
              Navigator.of(dialogContext).pop(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(null);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('');
              },
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(pendingSectionText);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == null) return;
    if (!mounted) return;

    final trimmedText = result.trim();

    if (trimmedText.isEmpty && existingIndex < 0) {
      setState(() {
        statusMessage = 'No section label added.';
        pendingSuriStart = null;
        selectedNoteAnchor = null;
      });
      return;
    }

    saveUndoSnapshot();

    setState(() {
      if (trimmedText.isEmpty) {
        sectionLabels.removeAt(existingIndex);
        statusMessage = 'Deleted section label.';

        pendingSuriStart = null;
        selectedNoteAnchor = null;
        return;
      }

      final newLabel = SectionLabel(
        measureIndex: measureIndex,
        text: trimmedText,
      );

      if (existingIndex >= 0) {
        sectionLabels[existingIndex] = newLabel;
        statusMessage = 'Updated section label.';
      } else {
        sectionLabels.add(newLabel);
        statusMessage = 'Added section label.';
      }

      pendingSuriStart = null;
      selectedNoteAnchor = null;
    });
  }

  bool measureRangeHasNotesOrRests({
    required int startMeasureIndex,
    required int measureLength,
  }) {
    final rangeStart = startMeasureIndex * slotsPerMeasure;
    final rangeEnd = rangeStart + measureLength * slotsPerMeasure;

    final hasNote = notes.any((note) {
      final noteStart = note.slot;
      final noteEnd = note.slot + note.durationSlots;

      return noteStart < rangeEnd && rangeStart < noteEnd;
    });

    if (hasNote) return true;

    final hasRest = rests.any((rest) {
      final restStart = rest.slot;
      final restEnd = rest.slot + rest.durationSlots;

      return restStart < rangeEnd && rangeStart < restEnd;
    });

    return hasRest;
  }

  bool rangeTouchesSimileRepeat({
    required int startSlot,
    required int durationSlots,
  }) {
    final endSlot = startSlot + durationSlots;

    return simileRepeats.any((repeat) {
      final repeatStart = repeat.measureIndex * slotsPerMeasure;
      final repeatEnd = repeatStart + repeat.repeatLength * slotsPerMeasure;

      return startSlot < repeatEnd && repeatStart < endSlot;
    });
  }

  bool repeatRangeOverlapsExistingRepeat({
    required int startMeasureIndex,
    required int measureLength,
  }) {
    final newStart = startMeasureIndex;
    final newEnd = startMeasureIndex + measureLength;

    return simileRepeats.any((repeat) {
      final existingStart = repeat.measureIndex;
      final existingEnd = repeat.measureIndex + repeat.repeatLength;

      return newStart < existingEnd && existingStart < newEnd;
    });
  }

  int getSelectedNoteIndex() {
    if (selectedNoteAnchor == null) {
      return -1;
    }

    final selected = selectedNoteAnchor!;

    return notes.indexWhere(
      (note) =>
          note.stringNumber == selected.stringNumber &&
          note.slot == selected.slot,
    );
  }

  void selectExistingNote(TabNote note) {
    setState(() {
      selectedNoteAnchor = NoteAnchor(
        stringNumber: note.stringNumber,
        slot: note.slot,
      );

      selectedTabNumber = note.tabNumber;
      selectedRhythm = note.rhythm;
      selectedTechnique = note.technique;

      selectedTool = EditorTool.write;
      pendingSuriStart = null;

      statusMessage =
          'Selected note ${note.tabNumber} on String ${note.stringNumber}.';
    });
  }

  void updateSelectedNote({
    String? tabNumber,
    String? rhythm,
    String? technique,
  }) {
    final selectedIndex = getSelectedNoteIndex();

    if (selectedIndex < 0) {
      return;
    }

    final oldNote = notes[selectedIndex];

    final updatedTabNumber = tabNumber ?? oldNote.tabNumber;
    final updatedRhythm = rhythm ?? oldNote.rhythm;
    final updatedTechnique = technique ?? oldNote.technique;
    final updatedDurationSlots = rhythmToSlots(updatedRhythm);

    if (rangeTouchesSimileRepeat(
      startSlot: oldNote.slot,
      durationSlots: updatedDurationSlots,
    )) {
      setState(() {
        statusMessage =
            'Cannot update selected note: rhythm overlaps a simile repeat measure.';
      });
      return;
    }

    for (int i = 0; i < notes.length; i++) {
      if (i == selectedIndex) continue;

      final otherNote = notes[i];

      if (otherNote.stringNumber != oldNote.stringNumber) continue;

      final overlaps = notesOverlap(
        startA: oldNote.slot,
        durationA: updatedDurationSlots,
        startB: otherNote.slot,
        durationB: otherNote.durationSlots,
      );

      if (overlaps) {
        setState(() {
          statusMessage =
              'Cannot update selected note: rhythm overlaps another note.';
        });
        return;
      }
    }

    for (final rest in rests) {
      if (rest.stringNumber != oldNote.stringNumber) continue;

      final overlaps = notesOverlap(
        startA: oldNote.slot,
        durationA: updatedDurationSlots,
        startB: rest.slot,
        durationB: rest.durationSlots,
      );

      if (overlaps) {
        setState(() {
          statusMessage =
              'Cannot update selected note: rhythm overlaps a rest.';
        });
        return;
      }
    }

    final updatedNote = TabNote(
      stringNumber: oldNote.stringNumber,
      slot: oldNote.slot,
      durationSlots: updatedDurationSlots,
      tabNumber: updatedTabNumber,
      rhythm: updatedRhythm,
      technique: updatedTechnique,
    );

    saveUndoSnapshot();

    setState(() {
      notes[selectedIndex] = updatedNote;

      selectedNoteAnchor = NoteAnchor(
        stringNumber: updatedNote.stringNumber,
        slot: updatedNote.slot,
      );

      selectedTabNumber = updatedNote.tabNumber;
      selectedRhythm = updatedNote.rhythm;
      selectedTechnique = updatedNote.technique;

      selectedTool = EditorTool.write;
      pendingSuriStart = null;

      statusMessage = 'Updated selected note.';
    });
  }

  int findNoteIndexAt(int stringNumber, int clickedSlot) {
    return notes.indexWhere((note) {
      final noteStart = note.slot;
      final noteEnd = note.slot + note.durationSlots;

      return note.stringNumber == stringNumber &&
          clickedSlot >= noteStart &&
          clickedSlot < noteEnd;
    });
  }

  int findRestIndexAt(int stringNumber, int clickedSlot) {
    return rests.indexWhere((rest) {
      final restStart = rest.slot;
      final restEnd = rest.slot + rest.durationSlots;

      return rest.stringNumber == stringNumber &&
          clickedSlot >= restStart &&
          clickedSlot < restEnd;
    });
  }

  void handleCanvasClick(Offset position) {
    final slot = getSlotFromX(position.dx);

    if (slot == null) {
      return;
    }

    if (selectedTool == EditorTool.erase) {
      smartEraseAt(position);
      return;
    }

    if (selectedTool == EditorTool.repeat) {
      handleRepeatClick(slot);
      return;
    }

    if (selectedTool == EditorTool.lyric) {
      handleLyricClick(slot);
      return;
    }

    if (selectedTool == EditorTool.section) {
      handleSectionClick(slot);
      return;
    }

    final stringNumber = getStringFromY(position.dy);

    if (stringNumber == null) {
      return;
    }

    if (selectedTool == EditorTool.suri) {
      handleSuriClick(stringNumber, slot);
    } else if (selectedTool == EditorTool.rest) {
      handleRestClick(stringNumber, slot);
    } else {
      writeNoteAt(stringNumber, slot);
    }
  }

  void writeNoteAt(int stringNumber, int slot) {
    final existingIndex = findNoteIndexAt(stringNumber, slot);

    if (existingIndex >= 0) {
      selectExistingNote(notes[existingIndex]);
      return;
    }

    final durationSlots = rhythmToSlots(selectedRhythm);

    if (rangeTouchesSimileRepeat(
      startSlot: slot,
      durationSlots: durationSlots,
    )) {
      setState(() {
        statusMessage = 'Cannot place note: this measure has a simile repeat.';
      });
      return;
    }

    final overlappingIndex = notes.indexWhere((note) {
      if (note.stringNumber != stringNumber) return false;

      return notesOverlap(
        startA: slot,
        durationA: durationSlots,
        startB: note.slot,
        durationB: note.durationSlots,
      );
    });

    final overlappingRestIndex = rests.indexWhere((rest) {
      if (rest.stringNumber != stringNumber) return false;

      return notesOverlap(
        startA: slot,
        durationA: durationSlots,
        startB: rest.slot,
        durationB: rest.durationSlots,
      );
    });

    if (overlappingRestIndex >= 0) {
      setState(() {
        statusMessage = 'Cannot place note: rhythm overlaps a rest.';
      });
      return;
    }

    if (overlappingIndex >= 0) {
      setState(() {
        statusMessage = 'Cannot place note: rhythm overlaps another note.';
      });
      return;
    }

    final newNote = TabNote(
      stringNumber: stringNumber,
      slot: slot,
      durationSlots: durationSlots,
      tabNumber: selectedTabNumber,
      rhythm: selectedRhythm,
      technique: selectedTechnique,
    );

    saveUndoSnapshot();

    setState(() {
      notes.add(newNote);

      selectedNoteAnchor = NoteAnchor(
        stringNumber: newNote.stringNumber,
        slot: newNote.slot,
      );

      pendingSuriStart = null;
      statusMessage = 'Placed and selected $selectedRhythm note.';
    });
  }

  void handleRestClick(int stringNumber, int slot) {
    final durationSlots = rhythmToSlots(selectedRhythm);

    if (rangeTouchesSimileRepeat(
      startSlot: slot,
      durationSlots: durationSlots,
    )) {
      setState(() {
        statusMessage = 'Cannot place rest: this measure has a simile repeat.';
      });
      return;
    }

    final existingRestIndex = findRestIndexAt(stringNumber, slot);

    if (existingRestIndex >= 0) {
      final removedRest = rests[existingRestIndex];

      saveUndoSnapshot();

      setState(() {
        rests.removeAt(existingRestIndex);

        lyricEntries.removeWhere((lyric) => lyric.slot == removedRest.slot);

        selectedNoteAnchor = null;
        pendingSuriStart = null;
        statusMessage = 'Removed rest and attached lyric.';
      });
      return;
    }

    final overlappingNoteIndex = notes.indexWhere((note) {
      if (note.stringNumber != stringNumber) return false;

      return notesOverlap(
        startA: slot,
        durationA: durationSlots,
        startB: note.slot,
        durationB: note.durationSlots,
      );
    });

    if (overlappingNoteIndex >= 0) {
      setState(() {
        statusMessage = 'Cannot place rest: overlaps a note.';
      });
      return;
    }

    final overlappingRestIndex = rests.indexWhere((rest) {
      if (rest.stringNumber != stringNumber) return false;

      return notesOverlap(
        startA: slot,
        durationA: durationSlots,
        startB: rest.slot,
        durationB: rest.durationSlots,
      );
    });

    if (overlappingRestIndex >= 0) {
      setState(() {
        statusMessage = 'Cannot place rest: overlaps another rest.';
      });
      return;
    }

    final newRest = TabRest(
      stringNumber: stringNumber,
      slot: slot,
      durationSlots: durationSlots,
      rhythm: selectedRhythm,
    );

    saveUndoSnapshot();

    setState(() {
      rests.add(newRest);
      selectedNoteAnchor = null;
      pendingSuriStart = null;
      statusMessage = 'Placed $selectedRhythm rest.';
    });
  }

  void handleRepeatClick(int slot) {
    final measureIndex = getMeasureIndexFromSlot(slot);
    final repeatLength = selectedRepeatLength;

    if (measureIndex < 0 || measureIndex >= selectedTotalMeasures) {
      setState(() {
        statusMessage = 'Click inside the song measure area.';
      });
      return;
    }

    final existingRepeatIndex = findSimileRepeatIndexAtSlot(slot);

    if (existingRepeatIndex >= 0) {
      final removedRepeat = simileRepeats[existingRepeatIndex];

      saveUndoSnapshot();

      setState(() {
        simileRepeats.removeAt(existingRepeatIndex);
        pendingSuriStart = null;
        selectedNoteAnchor = null;
        statusMessage =
            'Removed ${removedRepeat.repeatLength}-measure simile repeat.';
      });
      return;
    }

    if (repeatLength == 1 && measureIndex == 0) {
      setState(() {
        statusMessage =
            'A one-measure simile repeat cannot be placed in measure 1.';
      });
      return;
    }

    if (repeatLength == 2 && measureIndex < 2) {
      setState(() {
        statusMessage =
            'A two-measure simile repeat needs two previous measures to repeat.';
      });
      return;
    }

    if (measureIndex + repeatLength > selectedTotalMeasures) {
      setState(() {
        statusMessage =
            'Not enough space for a $repeatLength-measure simile repeat here.';
      });
      return;
    }

    if (measureRangeHasNotesOrRests(
      startMeasureIndex: measureIndex,
      measureLength: repeatLength,
    )) {
      setState(() {
        statusMessage =
            'Cannot place simile repeat: selected measure range already has notes or rests.';
      });
      return;
    }

    if (repeatRangeOverlapsExistingRepeat(
      startMeasureIndex: measureIndex,
      measureLength: repeatLength,
    )) {
      setState(() {
        statusMessage =
            'Cannot place simile repeat: it overlaps another repeat mark.';
      });
      return;
    }

    saveUndoSnapshot();

    setState(() {
      simileRepeats.add(
        SimileRepeat(measureIndex: measureIndex, repeatLength: repeatLength),
      );

      pendingSuriStart = null;
      selectedNoteAnchor = null;

      if (repeatLength == 1) {
        statusMessage =
            'Added one-measure simile repeat to measure ${measureIndex + 1}.';
      } else {
        statusMessage =
            'Added two-measure simile repeat from measure ${measureIndex + 1} to ${measureIndex + 2}.';
      }
    });
  }

  void handleSuriClick(int stringNumber, int clickedSlot) {
    final noteIndex = findNoteIndexAt(stringNumber, clickedSlot);

    if (noteIndex < 0) {
      setState(() {
        statusMessage = 'Suri mode: click an existing note.';
      });
      return;
    }

    final clickedNote = notes[noteIndex];
    final clickedAnchor = NoteAnchor(
      stringNumber: clickedNote.stringNumber,
      slot: clickedNote.slot,
    );

    if (pendingSuriStart == null) {
      setState(() {
        pendingSuriStart = clickedAnchor;
        statusMessage = 'Suri start selected. Click the ending note.';
      });
      return;
    }

    final start = pendingSuriStart!;

    if (start.stringNumber != clickedAnchor.stringNumber) {
      setState(() {
        pendingSuriStart = null;
        statusMessage = 'Suri must connect notes on the same string.';
      });
      return;
    }

    if (start.slot == clickedAnchor.slot) {
      setState(() {
        pendingSuriStart = null;
        statusMessage = 'Suri needs two different notes.';
      });
      return;
    }

    final startSlot = start.slot < clickedAnchor.slot
        ? start.slot
        : clickedAnchor.slot;

    final endSlot = start.slot < clickedAnchor.slot
        ? clickedAnchor.slot
        : start.slot;

    final existingSlideIndex = suriSlides.indexWhere(
      (slide) =>
          slide.stringNumber == stringNumber &&
          slide.startSlot == startSlot &&
          slide.endSlot == endSlot,
    );

    if (existingSlideIndex >= 0) {
      saveUndoSnapshot();

      setState(() {
        suriSlides.removeAt(existingSlideIndex);
        pendingSuriStart = null;
        statusMessage = 'Removed Suri slide.';
      });
      return;
    }

    saveUndoSnapshot();

    setState(() {
      suriSlides.add(
        SuriSlide(
          stringNumber: stringNumber,
          startSlot: startSlot,
          endSlot: endSlot,
        ),
      );

      pendingSuriStart = null;
      statusMessage = 'Added Suri slide.';
    });
  }

  void deleteSelectedNote() {
    if (selectedNoteAnchor == null) {
      setState(() {
        statusMessage = 'No selected note to delete.';
      });
      return;
    }

    final selected = selectedNoteAnchor!;

    final noteIndex = notes.indexWhere(
      (note) =>
          note.stringNumber == selected.stringNumber &&
          note.slot == selected.slot,
    );

    if (noteIndex < 0) {
      setState(() {
        selectedNoteAnchor = null;
        statusMessage = 'Selected note no longer exists.';
      });
      return;
    }

    final noteToDelete = notes[noteIndex];

    saveUndoSnapshot();

    setState(() {
      notes.removeAt(noteIndex);

      suriSlides.removeWhere(
        (slide) =>
            slide.stringNumber == noteToDelete.stringNumber &&
            (slide.startSlot == noteToDelete.slot ||
                slide.endSlot == noteToDelete.slot),
      );

      lyricEntries.removeWhere((lyric) => lyric.slot == noteToDelete.slot);

      pendingSuriStart = null;
      selectedNoteAnchor = null;

      statusMessage = 'Deleted selected note.';
    });
  }

  void deleteNoteAt(int stringNumber, int clickedSlot) {
    final noteIndex = findNoteIndexAt(stringNumber, clickedSlot);

    if (noteIndex >= 0) {
      final noteToDelete = notes[noteIndex];

      saveUndoSnapshot();

      setState(() {
        notes.removeAt(noteIndex);

        suriSlides.removeWhere(
          (slide) =>
              slide.stringNumber == noteToDelete.stringNumber &&
              (slide.startSlot == noteToDelete.slot ||
                  slide.endSlot == noteToDelete.slot),
        );

        lyricEntries.removeWhere((lyric) => lyric.slot == noteToDelete.slot);

        if (pendingSuriStart != null &&
            pendingSuriStart!.stringNumber == noteToDelete.stringNumber &&
            pendingSuriStart!.slot == noteToDelete.slot) {
          pendingSuriStart = null;
        }

        if (selectedNoteAnchor != null &&
            selectedNoteAnchor!.stringNumber == noteToDelete.stringNumber &&
            selectedNoteAnchor!.slot == noteToDelete.slot) {
          selectedNoteAnchor = null;
        }

        statusMessage =
            'Deleted note, related Suri slides, and attached lyric.';
      });

      return;
    }

    final restIndex = findRestIndexAt(stringNumber, clickedSlot);

    if (restIndex >= 0) {
      final restToDelete = rests[restIndex];

      saveUndoSnapshot();

      setState(() {
        rests.removeAt(restIndex);

        lyricEntries.removeWhere((lyric) => lyric.slot == restToDelete.slot);

        selectedNoteAnchor = null;
        pendingSuriStart = null;
        statusMessage = 'Deleted rest and attached lyric.';
      });

      return;
    }

    setState(() {
      statusMessage = 'No note or rest to erase here.';
    });
  }

  void smartEraseAt(Offset position) {
    final slot = getSlotFromX(position.dx);

    if (slot == null) {
      return;
    }

    final suriSlideIndex = findSuriSlideIndexNearPosition(position);

    if (suriSlideIndex >= 0) {
      saveUndoSnapshot();

      setState(() {
        suriSlides.removeAt(suriSlideIndex);
        pendingSuriStart = null;
        selectedNoteAnchor = null;
        statusMessage = 'Deleted Suri slide.';
      });
      return;
    }

    if (isNearLyricRow(position.dy)) {
      final lyricIndex = findLyricIndexAtSlot(slot);

      if (lyricIndex >= 0) {
        saveUndoSnapshot();

        setState(() {
          lyricEntries.removeAt(lyricIndex);
          pendingSuriStart = null;
          selectedNoteAnchor = null;
          statusMessage = 'Deleted lyric.';
        });
        return;
      }
    }

    final stringNumber = getStringFromY(position.dy);

    if (stringNumber != null) {
      final noteIndex = findNoteIndexAt(stringNumber, slot);

      if (noteIndex >= 0) {
        deleteNoteAt(stringNumber, slot);
        return;
      }

      final restIndex = findRestIndexAt(stringNumber, slot);

      if (restIndex >= 0) {
        deleteNoteAt(stringNumber, slot);
        return;
      }
    }

    final repeatIndex = findSimileRepeatIndexAtSlot(slot);

    if (repeatIndex >= 0) {
      saveUndoSnapshot();

      setState(() {
        final measureNumber = simileRepeats[repeatIndex].measureIndex + 1;

        simileRepeats.removeAt(repeatIndex);
        pendingSuriStart = null;
        selectedNoteAnchor = null;
        statusMessage = 'Deleted simile repeat from measure $measureNumber.';
      });
      return;
    }

    final measureIndex = getMeasureIndexFromSlot(slot);
    final sectionIndex = findSectionLabelIndexAtMeasure(measureIndex);

    if (sectionIndex >= 0) {
      saveUndoSnapshot();

      setState(() {
        sectionLabels.removeAt(sectionIndex);
        pendingSuriStart = null;
        selectedNoteAnchor = null;
        statusMessage = 'Deleted section label.';
      });
      return;
    }

    setState(() {
      statusMessage = 'Nothing to erase here.';
    });
  }

  DropdownMenuItem<String> buildTechniqueDropdownItem(String technique) {
    if (technique == 'LEFT_HAND_HEADER') {
      return const DropdownMenuItem<String>(
        value: 'LEFT_HAND_HEADER',
        enabled: false,
        child: Text(
          'Left-Hand Techniques (左手 - Hidarite)',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      );
    }

    if (technique == 'RIGHT_HAND_HEADER') {
      return const DropdownMenuItem<String>(
        value: 'RIGHT_HAND_HEADER',
        enabled: false,
        child: Text(
          'Right-Hand Techniques (右手 - Migite)',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
    }

    return DropdownMenuItem<String>(value: technique, child: Text(technique));
  }

  Widget buildToolbarSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? label,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  Widget buildSelectableToolbarButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? label,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: isSelected ? selectedColor : Colors.black87,
          side: BorderSide(
            color: isSelected ? selectedColor : Colors.grey.shade400,
            width: isSelected ? 2 : 1,
          ),
          backgroundColor: isSelected
              ? selectedColor.withAlpha(26)
              : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRestMode = selectedTool == EditorTool.rest;
    final isWriteMode = selectedTool == EditorTool.write;
    final isEraseMode = selectedTool == EditorTool.erase;
    final isSuriMode = selectedTool == EditorTool.suri;
    final isRepeatMode = selectedTool == EditorTool.repeat;
    final isLyricMode = selectedTool == EditorTool.lyric;
    final isSectionMode = selectedTool == EditorTool.section;

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): () {
          saveSong();
        },
        const SingleActivator(LogicalKeyboardKey.keyZ, control: true): () {
          undoLastAction();
        },
        const SingleActivator(LogicalKeyboardKey.keyY, control: true): () {
          redoLastAction();
        },
        const SingleActivator(LogicalKeyboardKey.keyN, control: true): () {
          newSong();
        },
        const SingleActivator(LogicalKeyboardKey.keyO, control: true): () {
          loadSong();
        },
        const SingleActivator(LogicalKeyboardKey.keyP, control: true): () {
          exportSheetAsPdf();
        },
        const SingleActivator(
          LogicalKeyboardKey.keyP,
          control: true,
          shift: true,
        ): () {
          exportSheetAsPng();
        },

        const SingleActivator(LogicalKeyboardKey.digit1, control: true): () {
          selectToolFromShortcut(EditorTool.write);
        },
        const SingleActivator(LogicalKeyboardKey.digit2, control: true): () {
          selectToolFromShortcut(EditorTool.erase);
        },
        const SingleActivator(LogicalKeyboardKey.digit3, control: true): () {
          selectToolFromShortcut(EditorTool.suri);
        },
        const SingleActivator(LogicalKeyboardKey.digit4, control: true): () {
          selectToolFromShortcut(EditorTool.rest);
        },
        const SingleActivator(LogicalKeyboardKey.digit5, control: true): () {
          selectToolFromShortcut(EditorTool.repeat);
        },
        const SingleActivator(LogicalKeyboardKey.digit6, control: true): () {
          selectToolFromShortcut(EditorTool.lyric);
        },
        const SingleActivator(LogicalKeyboardKey.digit7, control: true): () {
          selectToolFromShortcut(EditorTool.section);
        },

        const SingleActivator(LogicalKeyboardKey.delete): () {
          deleteSelectedNote();
        },
        const SingleActivator(LogicalKeyboardKey.escape): () {
          clearCurrentSelection();
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: const Text(appFullTitle)),
          body: LayoutBuilder(
            builder: (context, bodyConstraints) {
              final toolbarMaxHeight = (bodyConstraints.maxHeight * 0.38)
                  .clamp(180.0, 420.0)
                  .toDouble();

              return Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: toolbarMaxHeight),
                    child: Scrollbar(
                      controller: toolbarScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: toolbarScrollController,
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          child: Wrap(
                  spacing: 14,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    buildToolbarSection(
                      title: 'Song Settings',
                      children: [
                        SizedBox(
                          width: 260,
                          child: TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) {
                              scheduleAutoBackup();

                              setState(() {
                                statusMessage = 'Updated song title.';
                              });
                            },
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Tuning: '),
                            DropdownButton<String>(
                              value: selectedTuning,
                              items: tunings.map((tuning) {
                                return DropdownMenuItem<String>(
                                  value: tuning,
                                  child: Text(tuning),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;

                                scheduleAutoBackup();

                                setState(() {
                                  selectedTuning = value;
                                  statusMessage = 'Selected tuning: $value.';
                                });
                              },
                            ),
                          ],
                        ),

                        SizedBox(
                          width: 110,
                          child: TextField(
                            controller: tempoController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'BPM',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              scheduleAutoBackup();

                              setState(() {
                                final parsedTempo = int.tryParse(value.trim());

                                if (parsedTempo == null || parsedTempo <= 0) {
                                  statusMessage =
                                      'Tempo should be a positive number.';
                                } else {
                                  statusMessage =
                                      'Updated tempo to $parsedTempo BPM.';
                                }
                              });
                            },
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Measures: '),
                            DropdownButton<int>(
                              value: selectedTotalMeasures,
                              items: measureOptions.map((measureCount) {
                                return DropdownMenuItem<int>(
                                  value: measureCount,
                                  child: Text('$measureCount'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;

                                saveUndoSnapshot();

                                setState(() {
                                  selectedTotalMeasures = value;

                                  simileRepeats.removeWhere(
                                    (repeat) =>
                                        repeat.measureIndex +
                                            repeat.repeatLength >
                                        selectedTotalMeasures,
                                  );

                                  lyricEntries.removeWhere(
                                    (lyric) =>
                                        lyric.slot >=
                                        selectedTotalMeasures * slotsPerMeasure,
                                  );

                                  sectionLabels.removeWhere(
                                    (label) =>
                                        label.measureIndex >=
                                        selectedTotalMeasures,
                                  );

                                  pendingSuriStart = null;
                                  selectedNoteAnchor = null;
                                  statusMessage =
                                      'Set song length to $value measures.';
                                });
                              },
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Zoom: '),
                            DropdownButton<double>(
                              value: selectedZoom,
                              items: zoomOptions.map((zoomValue) {
                                final zoomPercent = (zoomValue * 100).round();

                                return DropdownMenuItem<double>(
                                  value: zoomValue,
                                  child: Text('$zoomPercent%'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;

                                scheduleAutoBackup();

                                setState(() {
                                  selectedZoom = value;
                                  pendingSuriStart = null;
                                  selectedNoteAnchor = null;
                                  statusMessage =
                                      'Set zoom to ${(value * 100).round()}%.';
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    buildToolbarSection(
                      title: 'Note Input',
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Tab Number: '),
                            DropdownButton<String>(
                              value: selectedTabNumber,
                              items: shamisenTabNumbers.map((tabNumber) {
                                return DropdownMenuItem<String>(
                                  value: tabNumber,
                                  child: Text(tabNumber),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;

                                if (getSelectedNoteIndex() >= 0) {
                                  updateSelectedNote(tabNumber: value);
                                  return;
                                }

                                setState(() {
                                  selectedTabNumber = value;
                                  selectedTool = EditorTool.write;
                                  pendingSuriStart = null;
                                  statusMessage = 'Selected tab number $value.';
                                });
                              },
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Rhythm: '),
                            DropdownButton<String>(
                              value: selectedRhythm,
                              items: rhythms.map((rhythm) {
                                return DropdownMenuItem<String>(
                                  value: rhythm,
                                  child: Text(
                                    '$rhythm (${rhythmToSlots(rhythm)} slots)',
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;

                                if (getSelectedNoteIndex() >= 0) {
                                  updateSelectedNote(rhythm: value);
                                  return;
                                }

                                setState(() {
                                  selectedRhythm = value;
                                  selectedTool = EditorTool.write;
                                  pendingSuriStart = null;
                                  statusMessage =
                                      'Selected $value rhythm: ${rhythmToSlots(value)} slots.';
                                });
                              },
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Technique: '),
                            DropdownButton<String>(
                              value: selectedTechnique,
                              items: techniques
                                  .map(buildTechniqueDropdownItem)
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                if (value == 'LEFT_HAND_HEADER') return;
                                if (value == 'RIGHT_HAND_HEADER') return;

                                if (getSelectedNoteIndex() >= 0) {
                                  updateSelectedNote(technique: value);
                                  return;
                                }

                                setState(() {
                                  selectedTechnique = value;
                                  selectedTool = EditorTool.write;
                                  pendingSuriStart = null;
                                  statusMessage = 'Selected technique: $value.';
                                });
                              },
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Repeat: '),
                            DropdownButton<int>(
                              value: selectedRepeatLength,
                              items: repeatLengthOptions.map((length) {
                                return DropdownMenuItem<int>(
                                  value: length,
                                  child: Text(
                                    length == 1 ? '1-measure' : '2-measure',
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;

                                setState(() {
                                  selectedRepeatLength = value;
                                  pendingSuriStart = null;
                                  selectedNoteAnchor = null;
                                  statusMessage =
                                      'Selected ${value == 1 ? 'one-measure' : 'two-measure'} repeat.';
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    buildToolbarSection(
                      title: 'Notation Tools',
                      children: [
                        buildSelectableToolbarButton(
                          icon: Icons.edit,
                          label: 'Write',
                          isSelected: isWriteMode,
                          selectedColor: Colors.blue,
                          onPressed: () {
                            selectToolFromShortcut(EditorTool.write);
                          },
                          tooltip: 'Write note (Ctrl + 1)',
                        ),

                        buildSelectableToolbarButton(
                          icon: Icons.delete,
                          label: 'Erase',
                          isSelected: isEraseMode,
                          selectedColor: Colors.red,
                          onPressed: () {
                            selectToolFromShortcut(EditorTool.erase);
                          },
                          tooltip: 'Smart erase (Ctrl + 2)',
                        ),

                        buildSelectableToolbarButton(
                          icon: Icons.timeline,
                          label: 'Suri',
                          isSelected: isSuriMode,
                          selectedColor: Colors.green,
                          onPressed: () {
                            selectToolFromShortcut(EditorTool.suri);
                          },
                          tooltip: 'Suri slide mode (Ctrl + 3)',
                        ),

                        buildSelectableToolbarButton(
                          icon: Icons.fiber_manual_record,
                          label: 'Rest',
                          isSelected: isRestMode,
                          selectedColor: Colors.purple,
                          onPressed: () {
                            selectToolFromShortcut(EditorTool.rest);
                          },
                          tooltip: 'Rest mode (Ctrl + 4)',
                        ),

                        buildSelectableToolbarButton(
                          icon: Icons.repeat,
                          label: 'Repeat',
                          isSelected: isRepeatMode,
                          selectedColor: Colors.brown,
                          onPressed: () {
                            selectToolFromShortcut(EditorTool.repeat);
                          },
                          tooltip: 'Simile repeat mode (Ctrl + 5)',
                        ),

                        buildSelectableToolbarButton(
                          icon: Icons.text_fields,
                          label: 'Lyric',
                          isSelected: isLyricMode,
                          selectedColor: Colors.teal,
                          onPressed: () {
                            selectToolFromShortcut(EditorTool.lyric);
                          },
                          tooltip: 'Lyric mode (Ctrl + 6)',
                        ),

                        buildSelectableToolbarButton(
                          icon: Icons.label,
                          label: 'Section',
                          isSelected: isSectionMode,
                          selectedColor: Colors.indigo,
                          onPressed: () {
                            selectToolFromShortcut(EditorTool.section);
                          },
                          tooltip: 'Section label mode (Ctrl + 7)',
                        ),
                      ],
                    ),

                        buildToolbarSection(
                          title: 'File',
                          children: [
                            buildToolbarButton(
                              icon: Icons.note_add,
                              label: 'New',
                              onPressed: newSong,
                              tooltip: 'Start a new song',
                            ),

                            buildToolbarButton(
                              icon: Icons.save,
                              label: 'Save',
                              onPressed: saveSong,
                              tooltip: 'Save song to the local song library',
                            ),

                            buildToolbarButton(
                              icon: Icons.folder_open,
                              label: 'Load',
                              onPressed: loadSong,
                              tooltip: 'Load song from the local song library',
                            ),

                            buildToolbarButton(
                              icon: Icons.save_as,
                              label: 'Save As',
                              onPressed: exportSongJsonFile,
                              tooltip: 'Save a copy of this song file anywhere on your computer',
                            ),

                            buildToolbarButton(
                              icon: Icons.file_open,
                              label: 'Open File',
                              onPressed: importSongJsonFile,
                              tooltip: 'Open a song file from anywhere on your computer',
                            ),

                            buildToolbarButton(
                              icon: Icons.restore_page,
                              label: 'Recover',
                              onPressed: recoverAutoBackup,
                              tooltip: 'Recover autosave backup',
                            ),

                            buildToolbarButton(
                              icon: Icons.delete_sweep,
                              label: 'Clear',
                              onPressed: clearSong,
                              tooltip: 'Clear current song notation',
                            ),
                          ],
                        ),

                        buildToolbarSection(
                          title: 'Edit',
                          children: [
                            buildToolbarButton(
                              icon: Icons.undo,
                              label: 'Undo',
                              onPressed: undoLastAction,
                              tooltip: 'Undo last action',
                            ),

                            buildToolbarButton(
                              icon: Icons.redo,
                              label: 'Redo',
                              onPressed: redoLastAction,
                              tooltip: 'Redo last action',
                            ),
                          ],
                        ),

                        buildToolbarSection(
                          title: 'Export',
                          children: [
                            buildToolbarButton(
                              icon: Icons.image,
                              label: 'PNG',
                              onPressed: exportSheetAsPng,
                              tooltip: 'Export sheet as PNG image',
                            ),

                            buildToolbarButton(
                              icon: Icons.picture_as_pdf,
                              label: 'PDF',
                              onPressed: exportSheetAsPdf,
                              tooltip: 'Export sheet as PDF document',
                            ),
                          ],
                        ),

                    buildToolbarSection(
                      title: 'Folders',
                      children: [
                        buildToolbarButton(
                          icon: Icons.library_music,
                          label: 'Songs',
                          onPressed: openSongFolder,
                          tooltip: 'Open song library folder',
                        ),

                        buildToolbarButton(
                          icon: Icons.folder,
                          label: 'Exports',
                          onPressed: openExportFolder,
                          tooltip: 'Open export folder',
                        ),

                        buildToolbarButton(
                          icon: Icons.manage_search,
                          label: 'Last Save',
                          onPressed: revealLastSavedSongFile,
                          tooltip: 'Show last saved song file',
                        ),

                        buildToolbarButton(
                          icon: Icons.find_in_page,
                          label: 'Last Export',
                          onPressed: revealLastExportedFile,
                          tooltip: 'Show last exported file',
                        ),
                      ],
                    ),

                    buildToolbarSection(
                      title: 'Help',
                      children: [
                        buildToolbarButton(
                          icon: Icons.help_outline,
                          label: 'Help',
                          onPressed: showHelpDialog,
                          tooltip: 'Help / Instructions',
                        ),

                        buildToolbarButton(
                          icon: Icons.history,
                          label: 'Changes',
                          onPressed: showChangelogDialog,
                          tooltip: 'Version history',
                        ),

                        buildToolbarButton(
                          icon: Icons.bug_report,
                          label: 'Error Report',
                          onPressed: exportErrorReport,
                          tooltip: 'Export local error log',
                        ),

                        buildToolbarButton(
                          icon: Icons.info_outline,
                          label: 'About',
                          onPressed: showAboutAppDialog,
                          tooltip: 'About app',
                        ),
                      ],
                    ),

                    buildToolbarSection(
                      title: 'Status',
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Text(
                            statusMessage,
                            style: TextStyle(
                              color:
                                  statusMessage.contains('Cannot') ||
                                      statusMessage.contains('must') ||
                                      statusMessage.contains('No note') ||
                                      statusMessage.contains('failed') ||
                                      statusMessage.contains('Nothing')
                                  ? Colors.red
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasUnsavedChanges ? 'Unsaved changes' : 'Saved',
                              style: TextStyle(
                                color: hasUnsavedChanges ? Colors.orange : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              getCurrentFileStateText(),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

                  Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const int slotsPerMeasure = 16;

                    final totalMeasures = selectedTotalMeasures;
                    final currentSlotSpacing = getCurrentSlotSpacing();

                    final canvasWidth =
                        leftMargin +
                        totalMeasures * slotsPerMeasure * currentSlotSpacing +
                        160;

                    final canvasHeight =
                        constraints.maxHeight < 720 ? 720.0 : constraints.maxHeight;

                    return Scrollbar(
                      controller: verticalScrollController,
                      thumbVisibility: true,
                      notificationPredicate: (notification) =>
                          notification.metrics.axis == Axis.vertical,
                      child: SingleChildScrollView(
                        controller: verticalScrollController,
                        child: Scrollbar(
                          controller: horizontalScrollController,
                          thumbVisibility: true,
                          notificationPredicate: (notification) =>
                              notification.metrics.axis == Axis.horizontal,
                          child: SingleChildScrollView(
                            controller: horizontalScrollController,
                            scrollDirection: Axis.horizontal,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (details) {
                                handleCanvasClick(details.localPosition);
                              },
                              child: RepaintBoundary(
                                key: sheetExportKey,
                                child: CustomPaint(
                                  painter: ShamisenPainter(
                                    notes: notes,
                                    rests: rests,
                                    suriSlides: suriSlides,
                                    simileRepeats: simileRepeats,
                                    lyricEntries: lyricEntries,
                                    sectionLabels: sectionLabels,
                                    pendingSuriStart: pendingSuriStart,
                                    selectedNoteAnchor: selectedNoteAnchor,
                                    selectedTool: selectedTool,
                                    totalMeasures: totalMeasures,
                                    songTitle: getSongTitle(),
                                    selectedTuning: selectedTuning,
                                    tempoBpm: getTempoBpm(),
                                    slotSpacing: currentSlotSpacing,
                                  ),
                                  child: SizedBox(
                                    width: canvasWidth,
                                    height: canvasHeight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ShamisenPainter extends CustomPainter {
  final List<TabNote> notes;
  final List<TabRest> rests;
  final List<SuriSlide> suriSlides;
  final List<SimileRepeat> simileRepeats;
  final List<LyricEntry> lyricEntries;
  final List<SectionLabel> sectionLabels;

  final NoteAnchor? pendingSuriStart;
  final NoteAnchor? selectedNoteAnchor;
  final EditorTool selectedTool;
  final int totalMeasures;
  final String songTitle;
  final String selectedTuning;
  final int tempoBpm;
  final double slotSpacing;

  ShamisenPainter({
    required this.notes,
    required this.rests,
    required this.suriSlides,
    required this.simileRepeats,
    required this.lyricEntries,
    required this.sectionLabels,

    required this.pendingSuriStart,
    required this.selectedNoteAnchor,
    required this.selectedTool,
    required this.totalMeasures,
    required this.songTitle,
    required this.selectedTuning,
    required this.tempoBpm,
    required this.slotSpacing,
  });

  static const double leftMargin = 80;
  static const double rightMargin = 40;
  static const double topMargin = 280;
  static const double stringSpacing = 80;

  static const int slotsPerBeat = 4;
  static const int beatsPerMeasure = 4;
  static const int slotsPerMeasure = slotsPerBeat * beatsPerMeasure;

  static const double titleY = 32;
  static const double metadataY = 76;
  static const double modeY = 106;

  static const double sectionLabelYFromTopMargin = 145;
  static const double measureNumberYFromTopMargin = 110;

  static const double gridTopExtension = 95;
  static const double gridBottomExtension = 150;

  static const double lyricRowYOffset = 110;

  static const double tabFontSize = 28;

  static const double belowTechniqueFontSize = 20;
  static const double belowTechniqueVerticalOffset = 30;

  static const double aboveKanjiFontSize = 16;
  static const double aboveKanjiVerticalOffset = 84;

  static const double aboveSymbolFontSize = 26;
  static const double aboveSymbolVerticalOffset = 62;

  static const double rhythmDashYOffset = 24;

  String techniqueSymbol(String technique) {
    switch (technique) {
      case 'Hajiki (弾き) - ハ':
        return 'ハ';
      case 'Uchi (打ち) - ウ':
        return 'ウ';
      case 'Oshi (押し) - オ':
        return 'オ';
      case 'Yuri (揺り) - ユ':
        return 'ユ';
      case 'Kesu (消す) - 消':
        return '消';

      case 'Sukui (救い) - ス':
        return 'ス';
      case 'Tataki (叩き) - タ / 叩':
        return 'タ';
      case 'Bachi (撥) - バ':
        return 'バ';
      case 'Tsuke (付) - ツ':
        return 'ツ';
      case 'Keshi (消し) - ケ':
        return 'ケ';

      default:
        return '';
    }
  }

  bool isAboveTabTechnique(String technique) {
    return technique == 'Oshibachi (押し撥) - 押' || technique == 'Suberi (滑り) - 滑';
  }

  String aboveTabKanji(String technique) {
    switch (technique) {
      case 'Oshibachi (押し撥) - 押':
        return '押';
      case 'Suberi (滑り) - 滑':
        return '滑';
      default:
        return '';
    }
  }

  String aboveTabSymbol(String technique) {
    switch (technique) {
      case 'Oshibachi (押し撥) - 押':
      case 'Suberi (滑り) - 滑':
        return '⌈';
      default:
        return '';
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final stringPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    final slotPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    final beatPaint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 1.5;

    final measurePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5;

    final bottomY = topMargin + stringSpacing * 2;
    final totalSlots = totalMeasures * slotsPerMeasure;
    final gridEndX = leftMargin + totalSlots * slotSpacing;

    drawTitle(canvas);
    drawToolStatus(canvas);
    drawSectionLabels(canvas);
    drawMeasureNumbers(canvas);
    drawGrid(canvas, totalSlots, bottomY, slotPaint, beatPaint, measurePaint);
    drawStrings(canvas, gridEndX, stringPaint);
    drawDurationGuides(canvas);
    drawSuriSlides(canvas);
    drawSimileRepeats(canvas);
    drawRests(canvas);
    drawLyrics(canvas, gridEndX);
    drawSelectedNoteHighlight(canvas);
    drawPendingSuriStart(canvas);
    drawNotes(canvas);
  }

  void drawTitle(Canvas canvas) {
    final titlePainter = TextPainter(
      text: TextSpan(
        text: songTitle,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    );

    titlePainter.layout(maxWidth: 650);
    titlePainter.paint(canvas, const Offset(leftMargin, titleY));

    final metadataPainter = TextPainter(
      text: TextSpan(
        text: 'Tuning: $selectedTuning    Tempo: $tempoBpm BPM',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    );

    metadataPainter.layout(maxWidth: 700);
    metadataPainter.paint(canvas, const Offset(leftMargin, metadataY));
  }

  void drawToolStatus(Canvas canvas) {
    String text;

    if (selectedTool == EditorTool.write) {
      text = 'Mode: Write';
    } else if (selectedTool == EditorTool.erase) {
      text = 'Mode: Smart Erase';
    } else if (selectedTool == EditorTool.rest) {
      text = 'Mode: Rest';
    } else if (selectedTool == EditorTool.repeat) {
      text = 'Mode: Simile Repeat';
    } else if (selectedTool == EditorTool.lyric) {
      text = 'Mode: Lyric';
    } else if (selectedTool == EditorTool.section) {
      text = 'Mode: Section Label';
    } else {
      text = 'Mode: Suri Slide';
    }

    Color color;

    if (selectedTool == EditorTool.write) {
      color = Colors.blue;
    } else if (selectedTool == EditorTool.erase) {
      color = Colors.red;
    } else if (selectedTool == EditorTool.rest) {
      color = Colors.purple;
    } else if (selectedTool == EditorTool.repeat) {
      color = Colors.brown;
    } else if (selectedTool == EditorTool.lyric) {
      color = Colors.teal;
    } else if (selectedTool == EditorTool.section) {
      color = Colors.indigo;
    } else {
      color = Colors.green;
    }

    final statusPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    statusPainter.layout();
    statusPainter.paint(canvas, const Offset(leftMargin, modeY));
  }

  void drawSectionLabels(Canvas canvas) {
    for (final label in sectionLabels) {
      final measureStartX =
          leftMargin + label.measureIndex * slotsPerMeasure * slotSpacing;

      final measureCenterX =
          measureStartX + (slotsPerMeasure * slotSpacing) / 2;

      final labelPainter = TextPainter(
        text: TextSpan(
          text: label.text,
          style: const TextStyle(
            color: Colors.indigo,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      );

      labelPainter.layout(maxWidth: slotsPerMeasure * slotSpacing - 12);

      labelPainter.paint(
        canvas,
        Offset(
          measureCenterX - labelPainter.width / 2,
          topMargin - sectionLabelYFromTopMargin,
        ),
      );
    }
  }

  void drawMeasureNumbers(Canvas canvas) {
    for (int measureIndex = 0; measureIndex < totalMeasures; measureIndex++) {
      final measureNumber = measureIndex + 1;

      final measureStartX =
          leftMargin + measureIndex * slotsPerMeasure * slotSpacing;

      final measureCenterX =
          measureStartX + (slotsPerMeasure * slotSpacing) / 2;

      final numberPainter = TextPainter(
        text: TextSpan(
          text: '$measureNumber',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      numberPainter.layout();

      numberPainter.paint(
        canvas,
        Offset(
          measureCenterX - numberPainter.width / 2,
          topMargin - measureNumberYFromTopMargin,
        ),
      );
    }
  }

  void drawGrid(
    Canvas canvas,
    int totalSlots,
    double bottomY,
    Paint slotPaint,
    Paint beatPaint,
    Paint measurePaint,
  ) {
    for (int slot = 0; slot <= totalSlots; slot++) {
      final x = leftMargin + slot * slotSpacing;

      Paint currentPaint = slotPaint;

      if (slot % slotsPerMeasure == 0) {
        currentPaint = measurePaint;
      } else if (slot % slotsPerBeat == 0) {
        currentPaint = beatPaint;
      }

      canvas.drawLine(
        Offset(x, topMargin - gridTopExtension),
        Offset(x, bottomY + gridBottomExtension),
        currentPaint,
      );
    }
  }

  void drawStrings(Canvas canvas, double maxX, Paint stringPaint) {
    for (int i = 0; i < 3; i++) {
      final y = topMargin + i * stringSpacing;

      canvas.drawLine(Offset(leftMargin, y), Offset(maxX, y), stringPaint);

      final labelPainter = TextPainter(
        text: TextSpan(
          text: 'String ${i + 1}',
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
      );

      labelPainter.layout();
      labelPainter.paint(canvas, Offset(15, y - 10));
    }
  }

  void drawDurationGuides(Canvas canvas) {
    final guidePaint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 1;

    for (final note in notes) {
      if (note.durationSlots <= 1) continue;

      final startX = leftMargin + note.slot * slotSpacing;
      final endX =
          leftMargin + (note.slot + note.durationSlots - 1) * slotSpacing;
      final y = topMargin + (note.stringNumber - 1) * stringSpacing + 42;

      canvas.drawLine(Offset(startX, y), Offset(endX, y), guidePaint);
    }
  }

  void drawSuriSlides(Canvas canvas) {
    final slidePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final slide in suriSlides) {
      final startX = leftMargin + slide.startSlot * slotSpacing;
      final endX = leftMargin + slide.endSlot * slotSpacing;
      final y = topMargin + (slide.stringNumber - 1) * stringSpacing;

      final width = (endX - startX).abs();
      final arcHeight = width < 60 ? 22.0 : 32.0;
      final arcY = y - 52;

      final path = Path()
        ..moveTo(startX, arcY)
        ..quadraticBezierTo(
          (startX + endX) / 2,
          arcY - arcHeight,
          endX,
          arcY,
        );

      canvas.drawPath(path, slidePaint);

      final symbolPainter = TextPainter(
        text: const TextSpan(
          text: '︵',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      symbolPainter.layout();

      symbolPainter.paint(
        canvas,
        Offset(
          (startX + endX) / 2 - symbolPainter.width / 2,
          arcY - arcHeight - symbolPainter.height / 2,
        ),
      );
    }
  }

  void drawPendingSuriStart(Canvas canvas) {
    if (pendingSuriStart == null) return;

    final anchor = pendingSuriStart!;
    final x = leftMargin + anchor.slot * slotSpacing;
    final y = topMargin + (anchor.stringNumber - 1) * stringSpacing;

    final highlightPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(x, y - 12), 18, highlightPaint);
  }

  void drawSelectedNoteHighlight(Canvas canvas) {
    if (selectedNoteAnchor == null) return;

    final selected = selectedNoteAnchor!;
    final x = leftMargin + selected.slot * slotSpacing;
    final y = topMargin + (selected.stringNumber - 1) * stringSpacing;

    final highlightPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCenter(center: Offset(x, y), width: 48, height: 58);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      highlightPaint,
    );
  }

  void drawSimileRepeats(Canvas canvas) {
    for (final repeat in simileRepeats) {
      final repeatStartX =
          leftMargin + repeat.measureIndex * slotsPerMeasure * slotSpacing;

      final repeatWidth = repeat.repeatLength * slotsPerMeasure * slotSpacing;

      final repeatCenterX = repeatStartX + repeatWidth / 2;

      final y = topMargin + stringSpacing;

      final symbol = repeat.repeatLength == 2 ? '𝄏' : '𝄎';

      final repeatPainter = TextPainter(
        text: TextSpan(
          text: symbol,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      repeatPainter.layout();

      final backgroundRect = Rect.fromLTWH(
        repeatCenterX - repeatPainter.width / 2 - 8,
        y - repeatPainter.height / 2 - 4,
        repeatPainter.width + 16,
        repeatPainter.height + 8,
      );

      final backgroundPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(backgroundRect, backgroundPaint);

      repeatPainter.paint(
        canvas,
        Offset(
          repeatCenterX - repeatPainter.width / 2,
          y - repeatPainter.height / 2,
        ),
      );
    }
  }

  void drawLyrics(Canvas canvas, double gridEndX) {
    final lyricY = topMargin + stringSpacing * 2 + lyricRowYOffset;

    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'Lyrics',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    labelPainter.layout();
    labelPainter.paint(canvas, Offset(15, lyricY));

    final lyricGuidePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(leftMargin, lyricY + 24),
      Offset(gridEndX, lyricY + 24),
      lyricGuidePaint,
    );

    for (final lyric in lyricEntries) {
      final x = leftMargin + lyric.slot * slotSpacing;

      final lyricPainter = TextPainter(
        text: TextSpan(
          text: lyric.text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      );

      lyricPainter.layout(maxWidth: 90);

      lyricPainter.paint(canvas, Offset(x - lyricPainter.width / 2, lyricY));
    }
  }

  void drawRests(Canvas canvas) {
    final restPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (final rest in rests) {
      final x = leftMargin + rest.slot * slotSpacing;
      final y = topMargin + (rest.stringNumber - 1) * stringSpacing;

      canvas.drawCircle(Offset(x, y), 7, restPaint);

      drawRhythmDash(canvas, x, y + rhythmDashYOffset, rest.rhythm);
    }
  }

  void drawNotes(Canvas canvas) {
    for (final note in notes) {
      final x = leftMargin + note.slot * slotSpacing;
      final y = topMargin + (note.stringNumber - 1) * stringSpacing;

      final normalTechnique = techniqueSymbol(note.technique);
      final usesAboveTabTechnique = isAboveTabTechnique(note.technique);

      if (usesAboveTabTechnique) {
        drawAboveTabTechnique(canvas, x, y, note.technique);
      }

      final tabPainter = TextPainter(
        text: TextSpan(
          text: note.tabNumber,
          style: const TextStyle(
            color: Colors.red,
            fontSize: tabFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      tabPainter.layout();

      tabPainter.paint(
        canvas,
        Offset(x - tabPainter.width / 2, y - tabPainter.height / 2),
      );

      drawRhythmDash(canvas, x, y + rhythmDashYOffset, note.rhythm);

      if (normalTechnique.isNotEmpty && !usesAboveTabTechnique) {
        final techniquePainter = TextPainter(
          text: TextSpan(
            text: normalTechnique,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: belowTechniqueFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        techniquePainter.layout();

        techniquePainter.paint(
          canvas,
          Offset(
            x - techniquePainter.width / 2,
            y + belowTechniqueVerticalOffset,
          ),
        );
      }
    }
  }

  void drawAboveTabTechnique(
    Canvas canvas,
    double x,
    double y,
    String technique,
  ) {
    final kanji = aboveTabKanji(technique);
    final symbol = aboveTabSymbol(technique);

    final kanjiPainter = TextPainter(
      text: TextSpan(
        text: kanji,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: aboveKanjiFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    kanjiPainter.layout();

    kanjiPainter.paint(
      canvas,
      Offset(x - kanjiPainter.width / 2, y - aboveKanjiVerticalOffset),
    );

    final symbolPainter = TextPainter(
      text: TextSpan(
        text: symbol,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: aboveSymbolFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    symbolPainter.layout();

    symbolPainter.paint(
      canvas,
      Offset(x - symbolPainter.width / 2, y - aboveSymbolVerticalOffset),
    );
  }

  void drawRhythmDash(Canvas canvas, double x, double y, String rhythm) {
    final dashPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    if (rhythm == 'Eighth') {
      canvas.drawLine(Offset(x - 8, y), Offset(x + 8, y), dashPaint);
    }

    if (rhythm == 'Sixteenth') {
      canvas.drawLine(Offset(x - 8, y), Offset(x + 8, y), dashPaint);

      canvas.drawLine(Offset(x - 8, y + 5), Offset(x + 8, y + 5), dashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ShamisenPainter oldDelegate) {
    return true;
  }
}
