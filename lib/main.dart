import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';

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

  ui.PlatformDispatcher.instance.onError =
      (Object error, StackTrace stackTrace) {
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

int readJsonInt(Map<String, dynamic> json, String key, int defaultValue) {
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
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

List<Map<String, dynamic>> readJsonObjectList(dynamic value) {
  if (value is! List) return <Map<String, dynamic>>[];

  return value.map(asStringKeyedMap).whereType<Map<String, dynamic>>().toList();
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

String normalizeRhythmString(String rhythm) {
  final trimmedRhythm = rhythm.trim();

  const validRhythms = <String>{
    'Whole',
    'Half',
    'Quarter',
    'Eighth',
    'Sixteenth',
  };

  if (validRhythms.contains(trimmedRhythm)) {
    return trimmedRhythm;
  }

  return 'Quarter';
}

String normalizeTechniqueString(String technique) {
  final trimmedTechnique = technique.trim();

  const validTechniques = <String>{
    'None',
    'Hajiki (弾き) - ハ',
    'Uchi (打ち) - ウ',
    'Oshi (押し) - オ',
    'Yuri (揺り) - ユ',
    'Kesu (消す) - 消',
    'Sukui (救い) - ス',
    'Tataki (叩き) - タ / 叩',
    'Bachi (撥) - バ',
    'Tsuke (付) - ツ',
    'Keshi (消し) - ケ',
    'Oshibachi (押し撥) - 押',
    'Suberi (滑り) - 滑',
  };

  if (validTechniques.contains(trimmedTechnique)) {
    return trimmedTechnique;
  }

  return 'None';
}

String normalizeTuningString(String tuning) {
  final trimmedTuning = tuning.trim();

  const validTunings = <String>{
    'Honchoshi (本調子)',
    'Niagari (二上り)',
    'Sansagari (三下り)',
  };

  if (validTunings.contains(trimmedTuning)) {
    return trimmedTuning;
  }

  return 'Honchoshi (本調子)';
}

double normalizeZoomValue(double zoom) {
  const validZoomValues = <double>[0.75, 1.0, 1.25, 1.5];

  if (validZoomValues.contains(zoom)) {
    return zoom;
  }

  return 1.0;
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

class ShamisenTabApp extends StatefulWidget {
  const ShamisenTabApp({super.key});

  @override
  State<ShamisenTabApp> createState() => _ShamisenTabAppState();
}

class _ShamisenTabAppState extends State<ShamisenTabApp> {
  Locale? selectedLocale;

  void updateLocale(Locale? locale) {
    setState(() {
      selectedLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appFullTitle,
      locale: selectedLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ja')],
      home: EditorScreen(
        selectedLocale: selectedLocale,
        onLocaleChanged: updateLocale,
      ),
    );
  }
}

enum EditorTool { write, erase, suri, rest, repeat, lyric, section }

enum StatusLevel { info, success, warning, error }

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
    final rhythm = normalizeRhythmString(
      readJsonString(json, 'rhythm', 'Quarter'),
    );

    final fallbackDurationSlots = durationSlotsFromRhythmString(rhythm);

    final durationSlots = readJsonInt(
      json,
      'durationSlots',
      fallbackDurationSlots,
    );

    final technique = normalizeTechniqueString(
      readJsonString(json, 'technique', 'None'),
    );

    return TabNote(
      stringNumber: clampJsonInt(readJsonInt(json, 'stringNumber', 1), 1, 3),
      slot: readJsonInt(json, 'slot', 0),
      durationSlots: durationSlots <= 0 ? fallbackDurationSlots : durationSlots,
      tabNumber: readJsonString(json, 'tabNumber', '0'),
      rhythm: rhythm,
      technique: technique,
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
    final rhythm = normalizeRhythmString(
      readJsonString(json, 'rhythm', 'Quarter'),
    );

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

class SheetMetrics {
  const SheetMetrics._();

  static const double leftMargin = 80;
  static const double rightMargin = 40;
  static const double topMargin = 280;
  static const double stringSpacing = 80;
  static const double baseSlotSpacing = 25;
  static const double stringHitRadius = 34;
  static const double lyricRowYOffset = 110;

  static const int slotsPerBeat = 4;
  static const int beatsPerMeasure = 4;
  static const int slotsPerMeasure = slotsPerBeat * beatsPerMeasure;
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
  final Locale? selectedLocale;
  final ValueChanged<Locale?> onLocaleChanged;

  const EditorScreen({
    super.key,
    required this.selectedLocale,
    required this.onLocaleChanged,
  });

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
      loadRecentSongFiles();
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
  StatusLevel statusLevel = StatusLevel.info;

  String? lastExportedFilePath;
  String? lastSavedSongFilePath;
  String? currentSongLibraryFilePath;

  final List<String> recentSongFilePaths = [];

  static const double leftMargin = SheetMetrics.leftMargin;
  static const double topMargin = SheetMetrics.topMargin;
  static const double stringSpacing = SheetMetrics.stringSpacing;
  static const double baseSlotSpacing = SheetMetrics.baseSlotSpacing;
  static const double stringHitRadius = SheetMetrics.stringHitRadius;
  static const double lyricRowYOffset = SheetMetrics.lyricRowYOffset;

  static const int slotsPerMeasure = SheetMetrics.slotsPerMeasure;

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

  int totalSlotsForMeasureCount(int measureCount) {
    return measureCount * slotsPerMeasure;
  }

  int removeOutOfRangeNotationForMeasureCount(int measureCount) {
    final totalSlots = totalSlotsForMeasureCount(measureCount);

    int removedCount = 0;

    final notesBefore = notes.length;
    notes.removeWhere(
      (note) =>
          note.slot < 0 ||
          note.slot >= totalSlots ||
          note.durationSlots <= 0 ||
          note.slot + note.durationSlots > totalSlots,
    );
    removedCount += notesBefore - notes.length;

    final restsBefore = rests.length;
    rests.removeWhere(
      (rest) =>
          rest.slot < 0 ||
          rest.slot >= totalSlots ||
          rest.durationSlots <= 0 ||
          rest.slot + rest.durationSlots > totalSlots,
    );
    removedCount += restsBefore - rests.length;

    final slidesBefore = suriSlides.length;
    suriSlides.removeWhere(
      (slide) =>
          slide.startSlot < 0 ||
          slide.endSlot < 0 ||
          slide.startSlot >= totalSlots ||
          slide.endSlot >= totalSlots ||
          slide.startSlot == slide.endSlot,
    );
    removedCount += slidesBefore - suriSlides.length;

    final repeatsBefore = simileRepeats.length;
    simileRepeats.removeWhere(
      (repeat) =>
          repeat.measureIndex < 0 ||
          repeat.measureIndex + repeat.repeatLength > measureCount,
    );
    removedCount += repeatsBefore - simileRepeats.length;

    final lyricsBefore = lyricEntries.length;
    lyricEntries.removeWhere(
      (lyric) =>
          lyric.slot < 0 ||
          lyric.slot >= totalSlots ||
          lyric.text.trim().isEmpty,
    );
    removedCount += lyricsBefore - lyricEntries.length;

    final sectionLabelsBefore = sectionLabels.length;
    sectionLabels.removeWhere(
      (label) =>
          label.measureIndex < 0 ||
          label.measureIndex >= measureCount ||
          label.text.trim().isEmpty,
    );
    removedCount += sectionLabelsBefore - sectionLabels.length;

    return removedCount;
  }

  AppLocalizations get loc {
    return AppLocalizations.of(context)!;
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

  void changeZoomByStep(int direction) {
    final currentIndex = zoomOptions.indexOf(selectedZoom);

    if (currentIndex < 0) {
      setState(() {
        selectedZoom = 1.0;
        pendingSuriStart = null;
        selectedNoteAnchor = null;
        updateStatusFields(loc.statusResetZoom, StatusLevel.info);
      });

      scheduleAutoBackup();
      return;
    }

    final nextIndex = (currentIndex + direction).clamp(
      0,
      zoomOptions.length - 1,
    );

    if (nextIndex == currentIndex) {
      setState(() {
        updateStatusFields(
          direction < 0 ? loc.statusMinimumZoom : loc.statusMaximumZoom,
          StatusLevel.warning,
        );
      });
      return;
    }

    final nextZoom = zoomOptions[nextIndex];

    setState(() {
      selectedZoom = nextZoom;
      pendingSuriStart = null;
      selectedNoteAnchor = null;
      updateStatusFields(
        loc.statusSetZoom((nextZoom * 100).round()),
        StatusLevel.info,
      );
    });

    scheduleAutoBackup();
  }

  void updateStatusFields(String message, StatusLevel level) {
    statusMessage = message;
    statusLevel = level;
  }

  void showStatus(String message, {StatusLevel level = StatusLevel.info}) {
    if (!mounted) return;

    setState(() {
      updateStatusFields(message, level);
    });
  }

  Color getStatusColor() {
    switch (statusLevel) {
      case StatusLevel.success:
        return Colors.green.shade700;
      case StatusLevel.warning:
        return Colors.orange.shade800;
      case StatusLevel.error:
        return Colors.red.shade700;
      case StatusLevel.info:
        return Colors.black87;
    }
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

  Future<File> getRecentFilesStoreFile() async {
    final songDirectory = await getSongDirectory();

    return File(
      '${songDirectory.path}${Platform.pathSeparator}_recent_files.json',
    );
  }

  Future<void> loadRecentSongFiles() async {
    try {
      final recentFile = await getRecentFilesStoreFile();

      if (!await recentFile.exists()) {
        return;
      }

      final contents = await recentFile.readAsString();

      if (contents.trim().isEmpty) {
        return;
      }

      final decodedData = jsonDecode(contents);

      List<dynamic> rawPaths;

      if (decodedData is List) {
        rawPaths = decodedData;
      } else if (decodedData is Map && decodedData['recentFiles'] is List) {
        rawPaths = decodedData['recentFiles'] as List<dynamic>;
      } else {
        rawPaths = <dynamic>[];
      }

      final cleanedPaths = <String>[];

      for (final rawPath in rawPaths) {
        if (rawPath is! String) continue;

        final path = rawPath.trim();

        if (path.isEmpty) continue;
        if (cleanedPaths.contains(path)) continue;

        final file = File(path);

        if (await file.exists()) {
          cleanedPaths.add(path);
        }
      }

      if (!mounted) return;

      setState(() {
        recentSongFilePaths
          ..clear()
          ..addAll(cleanedPaths.take(10));
      });

      await saveRecentSongFiles();
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Load recent files failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> saveRecentSongFiles() async {
    try {
      final recentFile = await getRecentFilesStoreFile();

      const encoder = JsonEncoder.withIndent('  ');

      final data = {'recentFiles': recentSongFilePaths.take(10).toList()};

      await recentFile.writeAsString(encoder.convert(data));
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Save recent files failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> rememberRecentSongFile(String filePath) async {
    final trimmedPath = filePath.trim();

    if (trimmedPath.isEmpty) return;

    recentSongFilePaths.remove(trimmedPath);
    recentSongFilePaths.insert(0, trimmedPath);

    if (recentSongFilePaths.length > 10) {
      recentSongFilePaths.removeRange(10, recentSongFilePaths.length);
    }

    await saveRecentSongFiles();

    if (!mounted) return;

    setState(() {});
  }

  Future<void> forgetRecentSongFile(String filePath) async {
    recentSongFilePaths.remove(filePath);

    await saveRecentSongFiles();

    if (!mounted) return;

    setState(() {});
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
        updateStatusFields(
          'Autosave backup found. Use Recover Autosave Backup if you need it.',
          StatusLevel.warning,
        );
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
        updateStatusFields(
          'Autosave failed: ${readableErrorMessage(error)}',
          StatusLevel.error,
        );
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
          updateStatusFields('No autosave backup found.', StatusLevel.warning);
        });
        return;
      }

      if (!mounted) return;

      final shouldRecover = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(loc.recoverAutosaveTitle),
            content: Text(loc.recoverAutosaveBody),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                child: Text(loc.returnButton),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
                child: Text(loc.recoverBackup),
              ),
            ],
          );
        },
      );

      if (shouldRecover != true) return;
      if (!mounted) return;

      final backupLoaded = await loadSongFromFile(
        backupFile,
        rememberRecent: false,
      );

      if (!backupLoaded) return;
      if (!mounted) return;

      setState(() {
        hasUnsavedChanges = true;
        lastAutoBackupFilePath = backupFile.path;
        updateStatusFields(
          'Recovered autosave backup. Use Save to store it as a normal song.',
          StatusLevel.success,
        );
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Autosave recovery failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          'Autosave recovery failed: ${readableErrorMessage(error)}',
          StatusLevel.error,
        );
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
          updateStatusFields(
            'No $label file has been created yet.',
            StatusLevel.warning,
          );
        });
        return;
      }

      final file = File(filePath);

      if (!await file.exists()) {
        setState(() {
          updateStatusFields(
            'The last $label file no longer exists: $filePath',
            StatusLevel.warning,
          );
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
          updateStatusFields(
            'Reveal file is not supported on this platform.',
            StatusLevel.warning,
          );
        });
        return;
      }

      setState(() {
        updateStatusFields('Opened $label file location.', StatusLevel.success);
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Reveal file failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          'Could not open $label file location: ${readableErrorMessage(error)}',
          StatusLevel.error,
        );
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
          updateStatusFields(
            'Open folder is not supported on this platform.',
            StatusLevel.warning,
          );
        });
        return;
      }

      setState(() {
        updateStatusFields('Opened $label folder.', StatusLevel.success);
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Open folder failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          'Could not open $label folder: ${readableErrorMessage(error)}',
          StatusLevel.error,
        );
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
          title: Text(loc.exportCompleteTitle(exportType)),
          content: SizedBox(
            width: 520,
            child: SelectableText(loc.savedToPath(exportFile.path)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(loc.returnButton),
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
              label: Text(loc.openFileLocation),
            ),
          ],
        );
      },
    );
  }

  Future<void> showSaveCopyCompleteDialog({required File savedFile}) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(loc.saveCopyCompleteTitle),
          content: SizedBox(
            width: 520,
            child: SelectableText(loc.savedCopyToPath(savedFile.path)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(loc.returnButton),
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
              label: Text(loc.openFileLocation),
            ),
          ],
        );
      },
    );
  }

  Future<void> exportSheetAsPng() async {
    try {
      setState(() {
        updateStatusFields('Exporting PNG...', StatusLevel.info);
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
        updateStatusFields(
          'PNG export completed successfully.',
          StatusLevel.success,
        );
      });

      await showExportCompleteDialog(exportFile: exportFile, exportType: 'PNG');
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'PNG export failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          'PNG export failed: ${readableErrorMessage(error)}',
          StatusLevel.error,
        );
      });
    }
  }

  Future<void> exportSheetAsPdf() async {
    try {
      setState(() {
        updateStatusFields('Exporting PDF...', StatusLevel.info);
      });

      final capture = await captureSheetAsPngBytes();

      final document = pw.Document();
      final sheetImage = pw.MemoryImage(capture.pngBytes);

      document.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.letter.landscape,
          margin: const pw.EdgeInsets.all(24),
          build: (context) {
            return pw.Center(
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
        updateStatusFields(
          'PDF export completed successfully.',
          StatusLevel.success,
        );
      });

      await showExportCompleteDialog(exportFile: exportFile, exportType: 'PDF');
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'PDF export failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          'PDF export failed: ${readableErrorMessage(error)}',
          StatusLevel.error,
        );
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
      return loc.libraryFile(displayName);
    }

    if (hasUnsavedChanges) {
      return loc.notSavedToLibrary;
    }

    return loc.noLibraryFileSelected;
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
          updateStatusFields(
            'No error log has been created yet.',
            StatusLevel.warning,
          );
        });
        return;
      }

      final logContents = await logFile.readAsString();

      if (logContents.trim().isEmpty) {
        if (!mounted) return;

        setState(() {
          updateStatusFields(
            'The error log is currently empty.',
            StatusLevel.warning,
          );
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
          updateStatusFields(
            'Export Error Report cancelled.',
            StatusLevel.warning,
          );
        });
        return;
      }

      final exportPath = ensureTxtExtension(saveLocation.path);
      final exportFile = File(exportPath);

      await exportFile.writeAsString(logContents);

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          'Exported error report successfully.',
          StatusLevel.success,
        );
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
        updateStatusFields(
          'Export Error Report failed: ${readableErrorMessage(error)}',
          StatusLevel.error,
        );
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
          title: Text(loc.overwriteSavedSongTitle),
          content: Text(loc.overwriteSavedSongBody(songTitle)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(loc.returnButton),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(loc.overwrite),
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
          updateStatusFields(
            loc.statusSaveCancelledOverwrite(songTitle),
            StatusLevel.warning,
          );
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
        updateStatusFields(loc.statusSavedSong(songTitle), StatusLevel.success);
      });

      await rememberRecentSongFile(file.path);
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Save song failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          loc.statusSaveFailed(readableErrorMessage(error)),
          StatusLevel.error,
        );
      });
    }
  }

  Future<void> saveSongCopy() async {
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
        if (!mounted) return;

        setState(() {
          updateStatusFields(loc.statusSaveCopyCancelled, StatusLevel.warning);
        });
        return;
      }

      final exportPath = ensureJsonExtension(saveLocation.path);
      final exportFile = File(exportPath);

      final songData = buildCurrentSongData();

      const encoder = JsonEncoder.withIndent('  ');
      await exportFile.writeAsString(encoder.convert(songData));

      if (!mounted) return;

      setState(() {
        updateStatusFields(loc.statusSaveCopySuccess, StatusLevel.success);
      });

      await showSaveCopyCompleteDialog(savedFile: exportFile);
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: loc.statusSaveCopyFailed(readableErrorMessage(error)),
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          loc.statusSaveCopyFailed(readableErrorMessage(error)),
          StatusLevel.error,
        );
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
          updateStatusFields(loc.statusOpenFileCancelled, StatusLevel.warning);
        });
        return;
      }

      final importedFile = File(selectedFile.path);

      if (!await importedFile.exists()) {
        setState(() {
          updateStatusFields(loc.statusOpenFileMissing, StatusLevel.error);
        });
        return;
      }

      final importedSuccessfully = await loadSongFromFile(importedFile);

      if (!importedSuccessfully) return;
      if (!mounted) return;

      scheduleAutoBackup();

      setState(() {
        hasUnsavedChanges = true;
        updateStatusFields(loc.statusOpenFileSuccess, StatusLevel.success);
      });
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Open File failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          loc.statusOpenFileFailed(readableErrorMessage(error)),
          StatusLevel.error,
        );
      });
    }
  }

  Future<List<File>> getSavedSongFiles() async {
    final songDirectory = await getSongDirectory();

    final files = songDirectory.listSync().whereType<File>().where((file) {
      final fileName = file.uri.pathSegments.last.toLowerCase();

      return fileName.endsWith('.json') && !fileName.startsWith('_');
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

      await forgetRecentSongFile(file.path);

      setState(() {
        if (deletedCurrentSong) {
          currentSongLibraryFilePath = null;
          lastSavedSongFilePath = null;
          hasUnsavedChanges = true;
          updateStatusFields(
            'Deleted "$deletedSongName". The current sheet is still open, but it is no longer saved.',
            StatusLevel.warning,
          );
        } else {
          updateStatusFields(
            'Deleted saved song "$deletedSongName".',
            StatusLevel.success,
          );
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
        updateStatusFields(
          'Delete failed: ${readableErrorMessage(error)}',
          StatusLevel.error,
        );
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
          updateStatusFields(loc.noSavedSongsFound, StatusLevel.warning);
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
                title: Text(loc.loadSongTitle),
                content: SizedBox(
                  width: 460,
                  height: 380,
                  child: savedFiles.isEmpty
                      ? Center(child: Text(loc.noSavedSongsFound))
                      : ListView.builder(
                          itemCount: savedFiles.length,
                          itemBuilder: (context, index) {
                            final file = savedFiles[index];
                            final displayName = displayNameFromFile(file);
                            final modified = file.lastModifiedSync();

                            return ListTile(
                              leading: const Icon(Icons.music_note),
                              title: Text(displayName),
                              subtitle: Text(
                                loc.modifiedDate(modified.toString()),
                              ),
                              onTap: () {
                                Navigator.of(dialogContext).pop(file);
                              },
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                                tooltip: loc.deleteSavedSongTooltip,
                                onPressed: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: dialogContext,
                                    builder: (confirmContext) {
                                      return AlertDialog(
                                        title: Text(loc.deleteSavedSongTitle),
                                        content: Text(
                                          isCurrentLibrarySongFile(file)
                                              ? loc.deleteCurrentSongBody(
                                                  displayName,
                                                )
                                              : loc.deleteSavedSongBody(
                                                  displayName,
                                                ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(
                                                confirmContext,
                                              ).pop(false);
                                            },
                                            child: Text(loc.cancel),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(
                                                confirmContext,
                                              ).pop(true);
                                            },
                                            child: Text(loc.delete),
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
                    child: Text(loc.returnButton),
                  ),
                ],
              );
            },
          );
        },
      );

      if (selectedFile == null) return;

      final loadedSuccessfully = await loadSongFromFile(
        selectedFile,
        isLibraryFile: true,
      );

      if (!loadedSuccessfully) return;
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Load song dialog failed',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          loc.statusLoadFailed(readableErrorMessage(error)),
          StatusLevel.error,
        );
      });
    }
  }

  Future<void> showRecentFilesDialog() async {
    final canContinue = await confirmUnsavedChangesBefore(
      'opening a recent song file',
    );

    if (!canContinue) return;
    if (!mounted) return;

    if (recentSongFilePaths.isEmpty) {
      setState(() {
        updateStatusFields(loc.noRecentFiles, StatusLevel.warning);
      });
      return;
    }

    final selectedPath = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(loc.recentFilesTitle),
              content: SizedBox(
                width: 560,
                height: 360,
                child: recentSongFilePaths.isEmpty
                    ? Center(child: Text(loc.noRecentFiles))
                    : ListView.builder(
                        itemCount: recentSongFilePaths.length,
                        itemBuilder: (context, index) {
                          final path = recentSongFilePaths[index];
                          final displayName = displayNameFromPath(path);

                          return ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(displayName),
                            subtitle: Text(
                              path,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.of(dialogContext).pop(path);
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: loc.removeFromRecentFiles,
                              onPressed: () async {
                                await forgetRecentSongFile(path);

                                setDialogState(() {});
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
                  child: Text(loc.returnButton),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedPath == null) return;
    if (!mounted) return;

    final selectedFile = File(selectedPath);

    if (!await selectedFile.exists()) {
      await forgetRecentSongFile(selectedPath);

      if (!mounted) return;

      setState(() {
        updateStatusFields(
          'Recent file no longer exists. Removed it from the list.',
          StatusLevel.warning,
        );
      });
      return;
    }

    final songDirectory = await getSongDirectory();
    final isLibraryRecentFile = selectedFile.parent.path == songDirectory.path;

    final loadedSuccessfully = await loadSongFromFile(
      selectedFile,
      isLibraryFile: isLibraryRecentFile,
    );

    if (!loadedSuccessfully) return;

    await rememberRecentSongFile(selectedFile.path);

    if (!mounted) return;

    setState(() {
      hasUnsavedChanges = !isLibraryRecentFile;
      updateStatusFields(
        isLibraryRecentFile
            ? loc.statusLoadedSong(displayNameFromFile(selectedFile))
            : loc.statusOpenFileSuccess,
        StatusLevel.success,
      );
    });
  }

  Future<bool> loadSongFromFile(
    File file, {
    bool isLibraryFile = false,
    bool rememberRecent = true,
  }) async {
    try {
      if (!await file.exists()) {
        if (!mounted) return false;

        setState(() {
          updateStatusFields(
            'Load failed: selected song file no longer exists.',
            StatusLevel.error,
          );
        });

        return false;
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
        if (!mounted) return false;

        setState(() {
          updateStatusFields(
            'Load failed: this song file uses a newer file format. Please update the app.',
            StatusLevel.error,
          );
        });

        return false;
      }

      final loadedTitle = readJsonString(
        data,
        'title',
        'Untitled Shamisen Piece',
      );

      final loadedTuning = normalizeTuningString(
        readJsonString(data, 'tuning', 'Honchoshi (本調子)'),
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

      final loadedZoomValue = normalizeZoomValue(
        readJsonDouble(data, 'zoom', 1.0),
      );

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

      if (!mounted) return false;

      setState(() {
        titleController.text = loadedTitle;

        selectedTuning = loadedTuning;

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

        updateStatusFields(
          loc.statusLoadedSong(loadedTitle),
          StatusLevel.success,
        );
      });

    if (rememberRecent) {
      await rememberRecentSongFile(file.path);
    }
      return true;
    } catch (error, stackTrace) {
      await LocalErrorLogger.writeError(
        source: 'Load song failed: ${file.path}',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) return false;

      setState(() {
        updateStatusFields(
          loc.statusLoadFailed(readableErrorMessage(error)),
          StatusLevel.error,
        );
      });

      return false;
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
          title: Text(loc.unsavedChangesTitle),
          content: Text(loc.unsavedChangesBody(actionName)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('cancel');
              },
              child: Text(loc.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('continue');
              },
              child: Text(loc.continueWithoutSaving),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('save');
              },
              child: Text(loc.saveFirst),
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
          title: Text(loc.startNewSongTitle),
          content: Text(loc.startNewSongBody),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(loc.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(loc.newSong),
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
      updateStatusFields(loc.statusStartedNewSong, StatusLevel.success);
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
              '- Save Copy and Open File support\n'
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
              child: Text(loc.returnButton),
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
                '6. Use Save Copy to save a JSON copy anywhere on your computer.\n'
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
              child: Text(loc.returnButton),
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
                '- Save Copy song file support\n'
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
              child: Text(loc.returnButton),
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
        updateStatusFields(loc.statusNothingToUndo, StatusLevel.warning);
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
      updateStatusFields(loc.statusUndidLastAction, StatusLevel.info);
    });

    scheduleAutoBackup();
  }

  void redoLastAction() {
    if (redoStack.isEmpty) {
      setState(() {
        updateStatusFields(loc.statusNothingToRedo, StatusLevel.warning);
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
      updateStatusFields(loc.statusRedidLastAction, StatusLevel.info);
    });

    scheduleAutoBackup();
  }

  void clearCurrentSelection() {
    setState(() {
      pendingSuriStart = null;
      selectedNoteAnchor = null;
      updateStatusFields(loc.statusClearedSelection, StatusLevel.info);
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
          updateStatusFields('Write mode.', StatusLevel.info);
          break;

        case EditorTool.erase:
          updateStatusFields(
            'Erase mode: click notes, rests, lyrics, Suri slides, repeats, or section labels.',
            StatusLevel.info,
          );
          break;

        case EditorTool.suri:
          updateStatusFields(
            'Suri mode: click the starting note, then ending note.',
            StatusLevel.info,
          );
          break;

        case EditorTool.rest:
          updateStatusFields(
            'Rest mode: click a line to place a rest.',
            StatusLevel.info,
          );
          break;

        case EditorTool.repeat:
          updateStatusFields(
            'Repeat mode: click a measure to toggle a simile mark.',
            StatusLevel.info,
          );
          break;

        case EditorTool.lyric:
          updateStatusFields(
            'Lyric mode: click a note/rest timing slot to add or edit lyrics.',
            StatusLevel.info,
          );
          break;

        case EditorTool.section:
          updateStatusFields(
            'Section mode: click a measure to add/edit a label.',
            StatusLevel.info,
          );
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
          title: Text(loc.clearCurrentSongTitle),
          content: Text(loc.clearCurrentSongBody),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(loc.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(loc.clear),
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
      updateStatusFields(loc.statusClearedSong, StatusLevel.success);
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
        updateStatusFields(
          loc.statusClickInsideMeasureArea,
          StatusLevel.warning,
        );
      });
      return;
    }

    final existingIndex = findLyricIndexAtSlot(slot);

    if (existingIndex < 0 && !slotHasNoteOrRestStart(slot)) {
      setState(() {
        updateStatusFields(
          loc.statusPlaceNoteOrRestBeforeLyric,
          StatusLevel.warning,
        );
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
          title: Text(loc.lyricDialogTitle),
          content: TextFormField(
            initialValue: existingText,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: loc.lyricTextLabel,
              hintText: loc.lyricTextHint,
              border: const OutlineInputBorder(),
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
              child: Text(loc.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('');
              },
              child: Text(loc.delete),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(pendingLyricText);
              },
              child: Text(loc.save),
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
        updateStatusFields(loc.statusNoLyricAdded, StatusLevel.warning);
        pendingSuriStart = null;
        selectedNoteAnchor = null;
      });
      return;
    }

    saveUndoSnapshot();

    setState(() {
      if (trimmedText.isEmpty) {
        lyricEntries.removeAt(existingIndex);
        updateStatusFields(loc.statusDeletedLyric, StatusLevel.success);

        pendingSuriStart = null;
        selectedNoteAnchor = null;
        return;
      }

      final newLyric = LyricEntry(slot: slot, text: trimmedText);

      if (existingIndex >= 0) {
        lyricEntries[existingIndex] = newLyric;
        updateStatusFields(loc.statusUpdatedLyric, StatusLevel.success);
      } else {
        lyricEntries.add(newLyric);
        updateStatusFields(loc.statusAddedLyric, StatusLevel.success);
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
        updateStatusFields(
          loc.statusClickInsideMeasureArea,
          StatusLevel.warning,
        );
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
          title: Text(loc.sectionDialogTitle(measureIndex + 1)),
          content: TextFormField(
            initialValue: existingText,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: loc.sectionLabelText,
              hintText: loc.sectionLabelHint,
              border: const OutlineInputBorder(),
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
              child: Text(loc.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('');
              },
              child: Text(loc.delete),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(pendingSectionText);
              },
              child: Text(loc.save),
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
        updateStatusFields(loc.statusNoSectionLabelAdded, StatusLevel.warning);
        pendingSuriStart = null;
        selectedNoteAnchor = null;
      });
      return;
    }

    saveUndoSnapshot();

    setState(() {
      if (trimmedText.isEmpty) {
        sectionLabels.removeAt(existingIndex);
        updateStatusFields(loc.statusDeletedSectionLabel, StatusLevel.success);

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
        updateStatusFields(loc.statusUpdatedSectionLabel, StatusLevel.success);
      } else {
        sectionLabels.add(newLabel);
        updateStatusFields(loc.statusAddedSectionLabel, StatusLevel.success);
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

      updateStatusFields(
        'Selected note ${note.tabNumber} on String ${note.stringNumber}.',
        StatusLevel.info,
      );
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
        updateStatusFields(
          'Cannot update selected note: rhythm overlaps a simile repeat measure.',
          StatusLevel.error,
        );
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
          updateStatusFields(
            'Cannot update selected note: rhythm overlaps another note.',
            StatusLevel.error,
          );
        });
        return;
      }
    }

    for (final rest in rests) {

      final overlaps = notesOverlap(
        startA: oldNote.slot,
        durationA: updatedDurationSlots,
        startB: rest.slot,
        durationB: rest.durationSlots,
      );

      if (overlaps) {
        setState(() {
          updateStatusFields(
            'Cannot update selected note: rhythm overlaps a rest.',
            StatusLevel.error,
          );
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

      updateStatusFields('Updated selected note.', StatusLevel.success);
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

  int findAnyRestIndexAtSlot(int clickedSlot) {
    return rests.indexWhere((rest) {
      final restStart = rest.slot;
      final restEnd = rest.slot + rest.durationSlots;

      return clickedSlot >= restStart && clickedSlot < restEnd;
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
        updateStatusFields(
          'Cannot place note: this measure has a simile repeat.',
          StatusLevel.error,
        );
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
      return notesOverlap(
        startA: slot,
        durationA: durationSlots,
        startB: rest.slot,
        durationB: rest.durationSlots,
      );
    });

    if (overlappingRestIndex >= 0) {
      setState(() {
        updateStatusFields(
          'Cannot place note: rhythm overlaps a rest.',
          StatusLevel.error,
        );
      });
      return;
    }

    if (overlappingIndex >= 0) {
      setState(() {
        updateStatusFields(
          'Cannot place note: rhythm overlaps another note.',
          StatusLevel.error,
        );
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
      updateStatusFields(
        'Placed and selected $selectedRhythm note.',
        StatusLevel.success,
      );
    });
  }

  void handleRestClick(int stringNumber, int slot) {
    final durationSlots = rhythmToSlots(selectedRhythm);

    if (rangeTouchesSimileRepeat(
      startSlot: slot,
      durationSlots: durationSlots,
    )) {
      setState(() {
        updateStatusFields(
          'Cannot place rest: this measure has a simile repeat.',
          StatusLevel.error,
        );
      });
      return;
    }

    final existingRestIndex = findAnyRestIndexAtSlot(slot);

    if (existingRestIndex >= 0) {
      final removedRest = rests[existingRestIndex];

      saveUndoSnapshot();

      setState(() {
        rests.removeAt(existingRestIndex);

        lyricEntries.removeWhere((lyric) => lyric.slot == removedRest.slot);

        selectedNoteAnchor = null;
        pendingSuriStart = null;
        updateStatusFields(
          'Removed rest and attached lyric.',
          StatusLevel.success,
        );
      });
      return;
    }

    final overlappingNoteIndex = notes.indexWhere((note) {
      return notesOverlap(
        startA: slot,
        durationA: durationSlots,
        startB: note.slot,
        durationB: note.durationSlots,
      );
    });

    if (overlappingNoteIndex >= 0) {
      setState(() {
        updateStatusFields(
          'Cannot place rest: overlaps a note.',
          StatusLevel.error,
        );
      });
      return;
    }

    final overlappingRestIndex = rests.indexWhere((rest) {
      return notesOverlap(
        startA: slot,
        durationA: durationSlots,
        startB: rest.slot,
        durationB: rest.durationSlots,
      );
    });

    if (overlappingRestIndex >= 0) {
      setState(() {
        updateStatusFields(
          'Cannot place rest: overlaps another rest.',
          StatusLevel.error,
        );
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
      updateStatusFields('Placed $selectedRhythm rest.', StatusLevel.success);
    });
  }

  void handleRepeatClick(int slot) {
    final measureIndex = getMeasureIndexFromSlot(slot);
    final repeatLength = selectedRepeatLength;

    if (measureIndex < 0 || measureIndex >= selectedTotalMeasures) {
      setState(() {
        updateStatusFields(
          loc.statusClickInsideMeasureArea,
          StatusLevel.warning,
        );
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
        updateStatusFields(
          'Removed ${removedRepeat.repeatLength}-measure simile repeat.',
          StatusLevel.success,
        );
      });
      return;
    }

    if (repeatLength == 1 && measureIndex == 0) {
      setState(() {
        updateStatusFields(
          'A one-measure simile repeat cannot be placed in measure 1.',
          StatusLevel.warning,
        );
      });
      return;
    }

    if (repeatLength == 2 && measureIndex < 2) {
      setState(() {
        updateStatusFields(
          'A two-measure simile repeat needs two previous measures to repeat.',
          StatusLevel.warning,
        );
      });
      return;
    }

    if (measureIndex + repeatLength > selectedTotalMeasures) {
      setState(() {
        updateStatusFields(
          'Not enough space for a $repeatLength-measure simile repeat here.',
          StatusLevel.warning,
        );
      });
      return;
    }

    if (measureRangeHasNotesOrRests(
      startMeasureIndex: measureIndex,
      measureLength: repeatLength,
    )) {
      setState(() {
        updateStatusFields(
          'Cannot place simile repeat: selected measure range already has notes or rests.',
          StatusLevel.error,
        );
      });
      return;
    }

    if (repeatRangeOverlapsExistingRepeat(
      startMeasureIndex: measureIndex,
      measureLength: repeatLength,
    )) {
      setState(() {
        updateStatusFields(
          'Cannot place simile repeat: it overlaps another repeat mark.',
          StatusLevel.error,
        );
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
        updateStatusFields(
          'Added one-measure simile repeat to measure ${measureIndex + 1}.',
          StatusLevel.success,
        );
      } else {
        updateStatusFields(
          'Added two-measure simile repeat from measure ${measureIndex + 1} to ${measureIndex + 2}.',
          StatusLevel.success,
        );
      }
    });
  }

  void handleSuriClick(int stringNumber, int clickedSlot) {
    final noteIndex = findNoteIndexAt(stringNumber, clickedSlot);

    if (noteIndex < 0) {
      setState(() {
        updateStatusFields(
          'Suri mode: click an existing note.',
          StatusLevel.warning,
        );
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
        updateStatusFields(
          'Suri start selected. Click the ending note.',
          StatusLevel.info,
        );
      });
      return;
    }

    final start = pendingSuriStart!;

    if (start.stringNumber != clickedAnchor.stringNumber) {
      setState(() {
        pendingSuriStart = null;
        updateStatusFields(
          'Suri must connect notes on the same string.',
          StatusLevel.error,
        );
      });
      return;
    }

    if (start.slot == clickedAnchor.slot) {
      setState(() {
        pendingSuriStart = null;
        updateStatusFields(
          'Suri needs two different notes.',
          StatusLevel.warning,
        );
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
        updateStatusFields('Removed Suri slide.', StatusLevel.success);
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
      updateStatusFields('Added Suri slide.', StatusLevel.success);
    });
  }

  void deleteSelectedNote() {
    if (selectedNoteAnchor == null) {
      setState(() {
        updateStatusFields('No selected note to delete.', StatusLevel.warning);
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
        updateStatusFields(
          'Selected note no longer exists.',
          StatusLevel.warning,
        );
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

      updateStatusFields('Deleted selected note.', StatusLevel.success);
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

        updateStatusFields(
          'Deleted note, related Suri slides, and attached lyric.',
          StatusLevel.success,
        );
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
        updateStatusFields(
          'Deleted rest and attached lyric.',
          StatusLevel.success,
        );
      });

      return;
    }

    setState(() {
      updateStatusFields('No note or rest to erase here.', StatusLevel.warning);
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
        updateStatusFields('Deleted Suri slide.', StatusLevel.success);
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
          updateStatusFields(loc.statusDeletedLyric, StatusLevel.success);
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
        updateStatusFields(
          'Deleted simile repeat from measure $measureNumber.',
          StatusLevel.success,
        );
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
        updateStatusFields(loc.statusDeletedSectionLabel, StatusLevel.success);
      });
      return;
    }

    setState(() {
      updateStatusFields('Nothing to erase here.', StatusLevel.warning);
    });
  }

  DropdownMenuItem<String> buildTechniqueDropdownItem(String technique) {
    if (technique == 'LEFT_HAND_HEADER') {
      return const DropdownMenuItem<String>(
        value: 'LEFT_HAND_HEADER',
        enabled: false,
        child: Text(
          'Left-Hand Techniques (左手 - Hidarite)',
          overflow: TextOverflow.ellipsis,
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
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
    }

    return DropdownMenuItem<String>(
      value: technique,
      child: Text(technique, overflow: TextOverflow.ellipsis),
    );
  }

  Widget buildDropdownControl<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    double width = 260,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Expanded(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
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
          appBar: AppBar(title: Text(loc.appTitle)),
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
                                title: loc.language,
                                children: [
                                  buildDropdownControl<Locale?>(
                                    label: '${loc.language}:',
                                    value: widget.selectedLocale,
                                    width: 220,
                                    items: [
                                      DropdownMenuItem<Locale?>(
                                        value: null,
                                        child: Text(loc.systemDefault),
                                      ),
                                      DropdownMenuItem<Locale?>(
                                        value: const Locale('en'),
                                        child: Text(loc.english),
                                      ),
                                      DropdownMenuItem<Locale?>(
                                        value: const Locale('ja'),
                                        child: Text(loc.japanese),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      widget.onLocaleChanged(value);

                                      setState(() {
                                        updateStatusFields(
                                          value == null
                                              ? loc.statusLanguageSystem
                                              : value.languageCode == 'ja'
                                              ? loc.statusLanguageJapanese
                                              : loc.statusLanguageEnglish,
                                          StatusLevel.info,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                              buildToolbarSection(
                                title: loc.songSettings,
                                children: [
                                  SizedBox(
                                    width: 260,
                                    child: TextField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                        labelText: loc.title,
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                      ),
                                      onChanged: (_) {
                                        scheduleAutoBackup();

                                        setState(() {
                                          updateStatusFields(
                                            loc.statusUpdatedTitle,
                                            StatusLevel.info,
                                          );
                                        });
                                      },
                                    ),
                                  ),

                                  buildDropdownControl<String>(
                                    label: '${loc.tuning}:',
                                    value: selectedTuning,
                                    width: 260,
                                    items: tunings.map((tuning) {
                                      return DropdownMenuItem<String>(
                                        value: tuning,
                                        child: Text(
                                          tuning,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value == null) return;

                                      scheduleAutoBackup();

                                      setState(() {
                                        selectedTuning = value;
                                        updateStatusFields(
                                          loc.statusSelectedTuning(value),
                                          StatusLevel.info,
                                        );
                                      });
                                    },
                                  ),

                                  SizedBox(
                                    width: 110,
                                    child: TextField(
                                      controller: tempoController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: loc.bpm,
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        scheduleAutoBackup();

                                        setState(() {
                                          final parsedTempo = int.tryParse(
                                            value.trim(),
                                          );

                                          if (parsedTempo == null ||
                                              parsedTempo <= 0) {
                                            updateStatusFields(
                                              loc.statusTempoPositiveNumber,
                                              StatusLevel.warning,
                                            );
                                          } else {
                                            updateStatusFields(
                                              loc.statusUpdatedTempo(
                                                parsedTempo,
                                              ),
                                              StatusLevel.info,
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),

                                  buildDropdownControl<int>(
                                    label: '${loc.measures}:',
                                    value: selectedTotalMeasures,
                                    width: 160,
                                    items: measureOptions.map((measureCount) {
                                      return DropdownMenuItem<int>(
                                        value: measureCount,
                                        child: Text('$measureCount'),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value == null) return;

                                      if (value == selectedTotalMeasures) {
                                        return;
                                      }

                                      saveUndoSnapshot();

                                      setState(() {
                                        selectedTotalMeasures = value;

                                        final removedCount =
                                            removeOutOfRangeNotationForMeasureCount(
                                              value,
                                            );

                                        pendingSuriStart = null;
                                        selectedNoteAnchor = null;

                                        if (removedCount > 0) {
                                          updateStatusFields(
                                            loc.statusSetMeasuresRemovedItems(
                                              value,
                                              removedCount,
                                            ),
                                            StatusLevel.warning,
                                          );
                                        } else {
                                          updateStatusFields(
                                            loc.statusSetMeasures(value),
                                            StatusLevel.info,
                                          );
                                        }
                                      });
                                    },
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildToolbarButton(
                                        icon: Icons.remove,
                                        label: loc.zoomOutButton,
                                        onPressed: () {
                                          changeZoomByStep(-1);
                                        },
                                        tooltip: loc.tooltipZoomOut,
                                      ),
                                      const SizedBox(width: 8),
                                      buildDropdownControl<double>(
                                        label: '${loc.zoom}:',
                                        value: selectedZoom,
                                        width: 160,
                                        items: zoomOptions.map((zoomValue) {
                                          final zoomPercent = (zoomValue * 100)
                                              .round();

                                          return DropdownMenuItem<double>(
                                            value: zoomValue,
                                            child: Text('$zoomPercent%'),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value == null) return;

                                          setState(() {
                                            selectedZoom = value;
                                            pendingSuriStart = null;
                                            selectedNoteAnchor = null;
                                            updateStatusFields(
                                              loc.statusSetZoom(
                                                (value * 100).round(),
                                              ),
                                              StatusLevel.info,
                                            );
                                          });

                                          scheduleAutoBackup();
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      buildToolbarButton(
                                        icon: Icons.add,
                                        label: loc.zoomInButton,
                                        onPressed: () {
                                          changeZoomByStep(1);
                                        },
                                        tooltip: loc.tooltipZoomIn,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              buildToolbarSection(
                                title: loc.noteInput,
                                children: [
                                  buildDropdownControl<String>(
                                    label: '${loc.tabNumber}:',
                                    value: selectedTabNumber,
                                    width: 190,
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
                                        updateStatusFields(
                                          loc.statusSelectedTabNumber(value),
                                          StatusLevel.info,
                                        );
                                      });
                                    },
                                  ),

                                  buildDropdownControl<String>(
                                    label: '${loc.rhythm}:',
                                    value: selectedRhythm,
                                    width: 230,
                                    items: rhythms.map((rhythm) {
                                      return DropdownMenuItem<String>(
                                        value: rhythm,
                                        child: Text(
                                          '$rhythm (${rhythmToSlots(rhythm)} slots)',
                                          overflow: TextOverflow.ellipsis,
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
                                        updateStatusFields(
                                          loc.statusSelectedRhythm(
                                            value,
                                            rhythmToSlots(value),
                                          ),
                                          StatusLevel.info,
                                        );
                                      });
                                    },
                                  ),

                                  buildDropdownControl<String>(
                                    label: '${loc.technique}:',
                                    value: selectedTechnique,
                                    width: 320,
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
                                        updateStatusFields(
                                          loc.statusSelectedTechnique(value),
                                          StatusLevel.info,
                                        );
                                      });
                                    },
                                  ),

                                  buildDropdownControl<int>(
                                    label: '${loc.repeat}:',
                                    value: selectedRepeatLength,
                                    width: 210,
                                    items: repeatLengthOptions.map((length) {
                                      return DropdownMenuItem<int>(
                                        value: length,
                                        child: Text(
                                          length == 1
                                              ? '1-measure'
                                              : '2-measure',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value == null) return;

                                      setState(() {
                                        selectedRepeatLength = value;
                                        pendingSuriStart = null;
                                        selectedNoteAnchor = null;
                                        updateStatusFields(
                                          loc.statusSelectedRepeat(
                                            value == 1
                                                ? loc.oneMeasure
                                                : loc.twoMeasure,
                                          ),
                                          StatusLevel.info,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),

                              buildToolbarSection(
                                title: loc.notationTools,
                                children: [
                                  buildSelectableToolbarButton(
                                    icon: Icons.edit,
                                    label: loc.write,
                                    isSelected: isWriteMode,
                                    selectedColor: Colors.blue,
                                    onPressed: () {
                                      selectToolFromShortcut(EditorTool.write);
                                    },
                                    tooltip: loc.tooltipWrite,
                                  ),

                                  buildSelectableToolbarButton(
                                    icon: Icons.delete,
                                    label: loc.erase,
                                    isSelected: isEraseMode,
                                    selectedColor: Colors.red,
                                    onPressed: () {
                                      selectToolFromShortcut(EditorTool.erase);
                                    },
                                    tooltip: loc.tooltipErase,
                                  ),

                                  buildSelectableToolbarButton(
                                    icon: Icons.timeline,
                                    label: loc.suri,
                                    isSelected: isSuriMode,
                                    selectedColor: Colors.green,
                                    onPressed: () {
                                      selectToolFromShortcut(EditorTool.suri);
                                    },
                                    tooltip: loc.tooltipSuri,
                                  ),

                                  buildSelectableToolbarButton(
                                    icon: Icons.fiber_manual_record,
                                    label: loc.rest,
                                    isSelected: isRestMode,
                                    selectedColor: Colors.purple,
                                    onPressed: () {
                                      selectToolFromShortcut(EditorTool.rest);
                                    },
                                    tooltip: loc.tooltipRest,
                                  ),

                                  buildSelectableToolbarButton(
                                    icon: Icons.repeat,
                                    label: loc.repeat,
                                    isSelected: isRepeatMode,
                                    selectedColor: Colors.brown,
                                    onPressed: () {
                                      selectToolFromShortcut(EditorTool.repeat);
                                    },
                                    tooltip: loc.tooltipRepeat,
                                  ),

                                  buildSelectableToolbarButton(
                                    icon: Icons.text_fields,
                                    label: loc.lyric,
                                    isSelected: isLyricMode,
                                    selectedColor: Colors.teal,
                                    onPressed: () {
                                      selectToolFromShortcut(EditorTool.lyric);
                                    },
                                    tooltip: loc.tooltipLyric,
                                  ),

                                  buildSelectableToolbarButton(
                                    icon: Icons.label,
                                    label: loc.section,
                                    isSelected: isSectionMode,
                                    selectedColor: Colors.indigo,
                                    onPressed: () {
                                      selectToolFromShortcut(
                                        EditorTool.section,
                                      );
                                    },
                                    tooltip: loc.tooltipSection,
                                  ),
                                ],
                              ),

                              buildToolbarSection(
                                title: loc.file,
                                children: [
                                  buildToolbarButton(
                                    icon: Icons.note_add,
                                    label: loc.newSong,
                                    onPressed: newSong,
                                    tooltip: loc.tooltipNewSong,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.save,
                                    label: loc.save,
                                    onPressed: saveSong,
                                    tooltip: loc.tooltipSave,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.folder_open,
                                    label: loc.load,
                                    onPressed: loadSong,
                                    tooltip: loc.tooltipLoad,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.history,
                                    label: loc.recent,
                                    onPressed: showRecentFilesDialog,
                                    tooltip: loc.tooltipRecent,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.save_as,
                                    label: loc.saveCopy,
                                    onPressed: saveSongCopy,
                                    tooltip: loc.tooltipSaveCopy,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.file_open,
                                    label: loc.openFile,
                                    onPressed: importSongJsonFile,
                                    tooltip: loc.tooltipOpenFile,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.restore_page,
                                    label: loc.recover,
                                    onPressed: recoverAutoBackup,
                                    tooltip: loc.tooltipRecover,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.delete_sweep,
                                    label: loc.clear,
                                    onPressed: clearSong,
                                    tooltip: loc.tooltipClear,
                                  ),
                                ],
                              ),

                              buildToolbarSection(
                                title: loc.edit,
                                children: [
                                  buildToolbarButton(
                                    icon: Icons.undo,
                                    label: loc.undo,
                                    onPressed: undoLastAction,
                                    tooltip: loc.tooltipUndo,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.redo,
                                    label: loc.redo,
                                    onPressed: redoLastAction,
                                    tooltip: loc.tooltipRedo,
                                  ),
                                ],
                              ),

                              buildToolbarSection(
                                title: loc.export,
                                children: [
                                  buildToolbarButton(
                                    icon: Icons.image,
                                    label: loc.png,
                                    onPressed: exportSheetAsPng,
                                    tooltip: loc.tooltipExportPng,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.picture_as_pdf,
                                    label: loc.pdf,
                                    onPressed: exportSheetAsPdf,
                                    tooltip: loc.tooltipExportPdf,
                                  ),
                                ],
                              ),

                              buildToolbarSection(
                                title: loc.folders,
                                children: [
                                  buildToolbarButton(
                                    icon: Icons.library_music,
                                    label: loc.songs,
                                    onPressed: openSongFolder,
                                    tooltip: loc.tooltipSongsFolder,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.folder,
                                    label: loc.exports,
                                    onPressed: openExportFolder,
                                    tooltip: loc.tooltipExportsFolder,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.manage_search,
                                    label: loc.lastSave,
                                    onPressed: revealLastSavedSongFile,
                                    tooltip: loc.tooltipLastSave,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.find_in_page,
                                    label: loc.lastExport,
                                    onPressed: revealLastExportedFile,
                                    tooltip: loc.tooltipLastExport,
                                  ),
                                ],
                              ),

                              buildToolbarSection(
                                title: loc.help,
                                children: [
                                  buildToolbarButton(
                                    icon: Icons.help_outline,
                                    label: loc.help,
                                    onPressed: showHelpDialog,
                                    tooltip: loc.tooltipHelp,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.history,
                                    label: loc.changes,
                                    onPressed: showChangelogDialog,
                                    tooltip: loc.tooltipChanges,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.bug_report,
                                    label: loc.errorReport,
                                    onPressed: exportErrorReport,
                                    tooltip: loc.tooltipErrorReport,
                                  ),

                                  buildToolbarButton(
                                    icon: Icons.info_outline,
                                    label: loc.about,
                                    onPressed: showAboutAppDialog,
                                    tooltip: loc.tooltipAbout,
                                  ),
                                ],
                              ),

                              buildToolbarSection(
                                title: loc.status,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 520,
                                    ),
                                    child: Text(
                                      statusMessage,
                                      style: TextStyle(
                                        color: getStatusColor(),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hasUnsavedChanges
                                            ? loc.unsavedChanges
                                            : loc.saved,
                                        style: TextStyle(
                                          color: hasUnsavedChanges
                                              ? Colors.orange
                                              : Colors.green,
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
                        const int slotsPerMeasure =
                            SheetMetrics.slotsPerMeasure;

                        final totalMeasures = selectedTotalMeasures;
                        final currentSlotSpacing = getCurrentSlotSpacing();

                        final canvasWidth =
                            leftMargin +
                            totalMeasures *
                                slotsPerMeasure *
                                currentSlotSpacing +
                            160;

                        final canvasHeight = constraints.maxHeight < 720
                            ? 720.0
                            : constraints.maxHeight;

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

                                        stringLabelBuilder: loc.stringLabel,
                                        lyricsLabel: loc.lyricsLabel,
                                        modeWriteLabel: loc.modeWrite,
                                        modeSmartEraseLabel: loc.modeSmartErase,
                                        modeRestLabel: loc.modeRest,
                                        modeSimileRepeatLabel:
                                            loc.modeSimileRepeat,
                                        modeLyricLabel: loc.modeLyric,
                                        modeSectionLabel: loc.modeSectionLabel,
                                        modeSuriSlideLabel: loc.modeSuriSlide,
                                        metadataLine: loc.metadataLine(
                                          selectedTuning,
                                          getTempoBpm(),
                                        ),
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

  final String Function(int stringNumber) stringLabelBuilder;
  final String lyricsLabel;
  final String modeWriteLabel;
  final String modeSmartEraseLabel;
  final String modeRestLabel;
  final String modeSimileRepeatLabel;
  final String modeLyricLabel;
  final String modeSectionLabel;
  final String modeSuriSlideLabel;
  final String metadataLine;

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

    required this.stringLabelBuilder,
    required this.lyricsLabel,
    required this.modeWriteLabel,
    required this.modeSmartEraseLabel,
    required this.modeRestLabel,
    required this.modeSimileRepeatLabel,
    required this.modeLyricLabel,
    required this.modeSectionLabel,
    required this.modeSuriSlideLabel,
    required this.metadataLine,
  });

  static const double leftMargin = SheetMetrics.leftMargin;
  static const double rightMargin = SheetMetrics.rightMargin;
  static const double topMargin = SheetMetrics.topMargin;
  static const double stringSpacing = SheetMetrics.stringSpacing;

  static const int slotsPerBeat = SheetMetrics.slotsPerBeat;
  static const int beatsPerMeasure = SheetMetrics.beatsPerMeasure;
  static const int slotsPerMeasure = SheetMetrics.slotsPerMeasure;

  static const double titleY = 32;
  static const double metadataY = 76;
  static const double modeY = 106;

  static const double sectionLabelYFromTopMargin = 145;
  static const double measureNumberYFromTopMargin = 110;

  static const double gridTopExtension = 95;
  static const double gridBottomExtension = 150;

  static const double lyricRowYOffset = 110;

  static const double tabFontSize = 30;

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
        text: metadataLine,
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
      text = modeWriteLabel;
    } else if (selectedTool == EditorTool.erase) {
      text = modeSmartEraseLabel;
    } else if (selectedTool == EditorTool.rest) {
      text = modeRestLabel;
    } else if (selectedTool == EditorTool.repeat) {
      text = modeSimileRepeatLabel;
    } else if (selectedTool == EditorTool.lyric) {
      text = modeLyricLabel;
    } else if (selectedTool == EditorTool.section) {
      text = modeSectionLabel;
    } else {
      text = modeSuriSlideLabel;
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
          text: stringLabelBuilder(i + 1),
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
        ..quadraticBezierTo((startX + endX) / 2, arcY - arcHeight, endX, arcY);

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

    final fillPaint = Paint()
      ..color = Colors.green.withAlpha(28)
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final center = Offset(x, y - 12);

    canvas.drawCircle(center, 18, fillPaint);
    canvas.drawCircle(center, 18, highlightPaint);
  }

  void drawSelectedNoteHighlight(Canvas canvas) {
    if (selectedNoteAnchor == null) return;

    final selected = selectedNoteAnchor!;
    final x = leftMargin + selected.slot * slotSpacing;
    final y = topMargin + (selected.stringNumber - 1) * stringSpacing;

    final fillPaint = Paint()
      ..color = Colors.orange.withAlpha(28)
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCenter(center: Offset(x, y), width: 48, height: 58);

    final roundedRect = RRect.fromRectAndRadius(rect, const Radius.circular(8));

    canvas.drawRRect(roundedRect, fillPaint);
    canvas.drawRRect(roundedRect, highlightPaint);
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
      text: TextSpan(
        text: lyricsLabel,
        style: const TextStyle(
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
