// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shamisen Tab Composer Beta 0.2.0';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get japanese => 'Japanese';

  @override
  String get systemDefault => 'System Default';

  @override
  String get ready => 'Ready';

  @override
  String get songSettings => 'Song Settings';

  @override
  String get noteInput => 'Note Input';

  @override
  String get notationTools => 'Notation Tools';

  @override
  String get file => 'File';

  @override
  String get edit => 'Edit';

  @override
  String get export => 'Export';

  @override
  String get folders => 'Folders';

  @override
  String get help => 'Help';

  @override
  String get status => 'Status';

  @override
  String get title => 'Title';

  @override
  String get tuning => 'Tuning';

  @override
  String get bpm => 'BPM';

  @override
  String get measures => 'Measures';

  @override
  String get zoom => 'Zoom';

  @override
  String get tabNumber => 'Tab Number';

  @override
  String get rhythm => 'Rhythm';

  @override
  String get technique => 'Technique';

  @override
  String get repeat => 'Repeat';

  @override
  String get newSong => 'New';

  @override
  String get save => 'Save';

  @override
  String get load => 'Load';

  @override
  String get recent => 'Recent';

  @override
  String get saveCopy => 'Save Copy';

  @override
  String get openFile => 'Open File';

  @override
  String get recover => 'Recover';

  @override
  String get clear => 'Clear';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get png => 'PNG';

  @override
  String get pdf => 'PDF';

  @override
  String get songs => 'Songs';

  @override
  String get exports => 'Exports';

  @override
  String get lastSave => 'Last Save';

  @override
  String get lastExport => 'Last Export';

  @override
  String get changes => 'Changes';

  @override
  String get errorReport => 'Error Report';

  @override
  String get about => 'About';

  @override
  String get write => 'Write';

  @override
  String get erase => 'Erase';

  @override
  String get suri => 'Suri';

  @override
  String get rest => 'Rest';

  @override
  String get lyric => 'Lyric';

  @override
  String get section => 'Section';

  @override
  String get unsavedChanges => 'Unsaved changes';

  @override
  String get saved => 'Saved';

  @override
  String get notSavedToLibrary => 'Not saved to library';

  @override
  String get noLibraryFileSelected => 'No library file selected';

  @override
  String libraryFile(String fileName) {
    return 'Library file: $fileName';
  }

  @override
  String stringLabel(int stringNumber) {
    return 'String $stringNumber';
  }

  @override
  String get lyricsLabel => 'Lyrics';

  @override
  String get modeWrite => 'Mode: Write';

  @override
  String get modeSmartErase => 'Mode: Smart Erase';

  @override
  String get modeRest => 'Mode: Rest';

  @override
  String get modeSimileRepeat => 'Mode: Simile Repeat';

  @override
  String get modeLyric => 'Mode: Lyric';

  @override
  String get modeSectionLabel => 'Mode: Section Label';

  @override
  String get modeSuriSlide => 'Mode: Suri Slide';

  @override
  String metadataLine(String tuning, int tempoBpm) {
    return 'Tuning: $tuning    Tempo: $tempoBpm BPM';
  }

  @override
  String get returnButton => 'Return';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get overwrite => 'Overwrite';

  @override
  String get saveFirst => 'Save First';

  @override
  String get continueWithoutSaving => 'Continue Without Saving';

  @override
  String get recoverBackup => 'Recover Backup';

  @override
  String get openFileLocation => 'Open File Location';

  @override
  String get unsavedChangesTitle => 'Unsaved changes';

  @override
  String get overwriteSavedSongTitle => 'Overwrite saved song?';

  @override
  String get recoverAutosaveTitle => 'Recover autosave backup?';

  @override
  String get startNewSongTitle => 'Start a new song?';

  @override
  String get clearCurrentSongTitle => 'Clear current song?';

  @override
  String get loadSongTitle => 'Load Song';

  @override
  String get recentFilesTitle => 'Recent Files';

  @override
  String get noRecentFiles => 'No recent files.';

  @override
  String get deleteSavedSongTitle => 'Delete saved song?';

  @override
  String get saveCopyCompleteTitle => 'Save Copy complete';

  @override
  String exportCompleteTitle(String exportType) {
    return '$exportType export complete';
  }

  @override
  String savedToPath(String filePath) {
    return 'Saved to:\n$filePath';
  }

  @override
  String savedCopyToPath(String filePath) {
    return 'Saved copy to:\n$filePath';
  }

  @override
  String get noSavedSongsFound => 'No saved songs found.';

  @override
  String modifiedDate(String modifiedDate) {
    return 'Modified: $modifiedDate';
  }

  @override
  String unsavedChangesBody(String actionName) {
    return 'You have unsaved changes. What do you want to do before $actionName?';
  }

  @override
  String overwriteSavedSongBody(String songTitle) {
    return 'A saved song named \"$songTitle\" already exists.\n\nDo you want to replace it?';
  }

  @override
  String get recoverAutosaveBody =>
      'This will replace the current sheet with the latest autosave backup. Use this only if you want to restore recent unsaved work.';

  @override
  String get startNewSongBody =>
      'This will clear the current sheet and reset the title, tuning, tempo, measures, and zoom.';

  @override
  String get clearCurrentSongBody =>
      'This will remove all notes, rests, Suri slides, lyrics, repeats, and section labels. Song settings will stay the same.';

  @override
  String deleteCurrentSongBody(String songName) {
    return 'Delete \"$songName\"? This is the song currently open in the editor.\n\nThe sheet will stay open, but it will become unsaved.';
  }

  @override
  String deleteSavedSongBody(String songName) {
    return 'Delete \"$songName\"? This cannot be undone.';
  }

  @override
  String get removeFromRecentFiles => 'Remove from recent files';

  @override
  String get tooltipWrite => 'Write note (Ctrl + 1)';

  @override
  String get tooltipErase => 'Smart erase (Ctrl + 2)';

  @override
  String get tooltipSuri => 'Suri slide mode (Ctrl + 3)';

  @override
  String get tooltipRest => 'Rest mode (Ctrl + 4)';

  @override
  String get tooltipRepeat => 'Simile repeat mode (Ctrl + 5)';

  @override
  String get tooltipLyric => 'Lyric mode (Ctrl + 6)';

  @override
  String get tooltipSection => 'Section label mode (Ctrl + 7)';

  @override
  String get tooltipNewSong => 'Start a new song';

  @override
  String get tooltipSave => 'Save song to the local song library';

  @override
  String get tooltipLoad => 'Load song from the local song library';

  @override
  String get tooltipRecent => 'Open a recently used song file';

  @override
  String get tooltipSaveCopy =>
      'Save a JSON copy anywhere on your computer without changing the active library file';

  @override
  String get tooltipOpenFile =>
      'Open a song file from anywhere on your computer';

  @override
  String get tooltipRecover => 'Recover autosave backup';

  @override
  String get tooltipClear => 'Clear current song notation';

  @override
  String get tooltipUndo => 'Undo last action';

  @override
  String get tooltipRedo => 'Redo last action';

  @override
  String get tooltipExportPng => 'Export sheet as PNG image';

  @override
  String get tooltipExportPdf => 'Export sheet as PDF document';

  @override
  String get tooltipSongsFolder => 'Open song library folder';

  @override
  String get tooltipExportsFolder => 'Open export folder';

  @override
  String get tooltipLastSave => 'Show last saved song file';

  @override
  String get tooltipLastExport => 'Show last exported file';

  @override
  String get tooltipHelp => 'Help / Instructions';

  @override
  String get tooltipChanges => 'Version history';

  @override
  String get tooltipErrorReport => 'Export local error log';

  @override
  String get tooltipAbout => 'About app';

  @override
  String get tooltipZoomOut => 'Zoom out';

  @override
  String get tooltipZoomIn => 'Zoom in';

  @override
  String get statusLanguageSystem => 'Language set to system default.';

  @override
  String get statusLanguageJapanese => 'Language set to Japanese.';

  @override
  String get statusLanguageEnglish => 'Language set to English.';

  @override
  String get statusUpdatedTitle => 'Updated song title.';

  @override
  String statusSelectedTuning(String tuning) {
    return 'Selected tuning: $tuning.';
  }

  @override
  String get statusTempoPositiveNumber => 'Tempo should be a positive number.';

  @override
  String statusUpdatedTempo(int tempoBpm) {
    return 'Updated tempo to $tempoBpm BPM.';
  }

  @override
  String statusSetMeasures(int measureCount) {
    return 'Set song length to $measureCount measures.';
  }

  @override
  String statusSetMeasuresRemovedItems(int measureCount, int removedCount) {
    return 'Set song length to $measureCount measures. Removed $removedCount out-of-range item(s).';
  }

  @override
  String get statusResetZoom => 'Reset zoom to 100%.';

  @override
  String statusSetZoom(int zoomPercent) {
    return 'Set zoom to $zoomPercent%.';
  }

  @override
  String get statusMinimumZoom => 'Already at minimum zoom.';

  @override
  String get statusMaximumZoom => 'Already at maximum zoom.';

  @override
  String statusSelectedTabNumber(String tabNumber) {
    return 'Selected tab number $tabNumber.';
  }

  @override
  String statusSelectedRhythm(String rhythm, int slotCount) {
    return 'Selected $rhythm rhythm: $slotCount slots.';
  }

  @override
  String statusSelectedTechnique(String technique) {
    return 'Selected technique: $technique.';
  }

  @override
  String statusSelectedRepeat(String repeatName) {
    return 'Selected $repeatName repeat.';
  }

  @override
  String get oneMeasure => 'one-measure';

  @override
  String get twoMeasure => 'two-measure';

  @override
  String get statusNothingToUndo => 'Nothing to undo.';

  @override
  String get statusUndidLastAction => 'Undid last action.';

  @override
  String get statusNothingToRedo => 'Nothing to redo.';

  @override
  String get statusRedidLastAction => 'Redid last action.';

  @override
  String get statusClearedSelection => 'Cleared selection.';

  @override
  String get statusStartedNewSong => 'Started new song.';

  @override
  String get statusClearedSong => 'Cleared song.';

  @override
  String statusSavedSong(String songTitle) {
    return 'Saved \"$songTitle\" successfully.';
  }

  @override
  String statusSaveCancelledOverwrite(String songTitle) {
    return 'Save cancelled to avoid overwriting \"$songTitle\".';
  }

  @override
  String statusSaveFailed(String errorMessage) {
    return 'Save failed: $errorMessage';
  }

  @override
  String statusLoadedSong(String songTitle) {
    return 'Loaded \"$songTitle\" successfully.';
  }

  @override
  String statusLoadFailed(String errorMessage) {
    return 'Load failed: $errorMessage';
  }

  @override
  String get statusSaveCopyCancelled => 'Save Copy cancelled.';

  @override
  String get statusSaveCopySuccess =>
      'Saved song copy successfully. Your active library file was not changed.';

  @override
  String statusSaveCopyFailed(String errorMessage) {
    return 'Save Copy failed: $errorMessage';
  }

  @override
  String get statusOpenFileCancelled => 'Open File cancelled.';

  @override
  String get statusOpenFileMissing =>
      'Open File failed: selected file does not exist.';

  @override
  String get statusOpenFileSuccess =>
      'Opened song file successfully. Use Save to add it to your song library.';

  @override
  String statusOpenFileFailed(String errorMessage) {
    return 'Open File failed: $errorMessage';
  }

  @override
  String get zoomOutButton => 'Zoom -';

  @override
  String get zoomInButton => 'Zoom +';

  @override
  String get deleteSavedSongTooltip => 'Delete saved song';

  @override
  String get lyricDialogTitle => 'Lyric';

  @override
  String get lyricTextLabel => 'Lyric text';

  @override
  String get lyricTextHint => 'Example: sakura / さくら / 桜';

  @override
  String sectionDialogTitle(int measureNumber) {
    return 'Section label for measure $measureNumber';
  }

  @override
  String get sectionLabelText => 'Section label';

  @override
  String get sectionLabelHint => 'Example: Intro / Verse / Chorus';

  @override
  String get statusClickInsideMeasureArea =>
      'Click inside the song measure area.';

  @override
  String get statusPlaceNoteOrRestBeforeLyric =>
      'Place a note or rest first, then add lyrics under it.';

  @override
  String get statusNoLyricAdded => 'No lyric added.';

  @override
  String get statusDeletedLyric => 'Deleted lyric.';

  @override
  String get statusUpdatedLyric => 'Updated lyric.';

  @override
  String get statusAddedLyric => 'Added lyric under note/rest.';

  @override
  String get statusNoSectionLabelAdded => 'No section label added.';

  @override
  String get statusDeletedSectionLabel => 'Deleted section label.';

  @override
  String get statusUpdatedSectionLabel => 'Updated section label.';

  @override
  String get statusAddedSectionLabel => 'Added section label.';
}
