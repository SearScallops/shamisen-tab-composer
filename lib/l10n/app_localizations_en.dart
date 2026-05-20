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

  @override
  String get statusAutosaveFound =>
      'Autosave backup found. Use Recover Autosave Backup if you need it.';

  @override
  String statusAutosaveFailed(Object errorMessage) {
    return 'Autosave failed: $errorMessage';
  }

  @override
  String get statusNoAutosaveBackup => 'No autosave backup found.';

  @override
  String get statusRecoveredAutosave =>
      'Recovered autosave backup. Use Save to store it as a normal song.';

  @override
  String statusAutosaveRecoveryFailed(Object errorMessage) {
    return 'Autosave recovery failed: $errorMessage';
  }

  @override
  String get statusExportingPng => 'Exporting PNG...';

  @override
  String get statusExportingPdf => 'Exporting PDF...';

  @override
  String get statusPngExportSuccess => 'PNG export completed successfully.';

  @override
  String get statusPdfExportSuccess => 'PDF export completed successfully.';

  @override
  String statusPngExportFailed(Object errorMessage) {
    return 'PNG export failed: $errorMessage';
  }

  @override
  String statusPdfExportFailed(Object errorMessage) {
    return 'PDF export failed: $errorMessage';
  }

  @override
  String get statusToolWrite => 'Write mode.';

  @override
  String get statusToolErase =>
      'Erase mode: click notes, rests, lyrics, Suri slides, repeats, or section labels.';

  @override
  String get statusToolSuri =>
      'Suri mode: click the starting note, then ending note.';

  @override
  String get statusToolRest => 'Rest mode: click a line to place a rest.';

  @override
  String get statusToolRepeat =>
      'Repeat mode: click a measure to toggle a simile mark.';

  @override
  String get statusToolLyric =>
      'Lyric mode: click a note/rest timing slot to add or edit lyrics.';

  @override
  String get statusToolSection =>
      'Section mode: click a measure to add/edit a label.';

  @override
  String statusDeletedCurrentSongFile(Object songName) {
    return 'Deleted \"$songName\". The current sheet is still open, but it is no longer saved.';
  }

  @override
  String statusDeletedSavedSongFile(Object songName) {
    return 'Deleted saved song \"$songName\".';
  }

  @override
  String statusDeleteFailed(Object errorMessage) {
    return 'Delete failed: $errorMessage';
  }

  @override
  String get statusRecentFileMissing =>
      'Recent file no longer exists. Removed it from the list.';

  @override
  String get statusLoadFileMissing =>
      'Load failed: selected song file no longer exists.';

  @override
  String get statusLoadNewerFileFormat =>
      'Load failed: this song file uses a newer file format. Please update the app.';

  @override
  String statusSelectedNote(Object stringNumber, Object tabNumber) {
    return 'Selected note $tabNumber on String $stringNumber.';
  }

  @override
  String get statusUpdatedSelectedNote => 'Updated selected note.';

  @override
  String get statusSelectedNoteOverlapRepeat =>
      'Cannot update selected note: rhythm overlaps a simile repeat measure.';

  @override
  String get statusSelectedNoteOverlapNote =>
      'Cannot update selected note: rhythm overlaps another note.';

  @override
  String get statusSelectedNoteOverlapRest =>
      'Cannot update selected note: rhythm overlaps a rest.';

  @override
  String get statusCannotPlaceNoteRepeat =>
      'Cannot place note: this measure has a simile repeat.';

  @override
  String get statusCannotPlaceNoteRest =>
      'Cannot place note: rhythm overlaps a rest.';

  @override
  String get statusCannotPlaceNoteNote =>
      'Cannot place note: rhythm overlaps another note.';

  @override
  String statusPlacedSelectedNote(Object rhythm) {
    return 'Placed and selected $rhythm note.';
  }

  @override
  String get statusCannotPlaceRestRepeat =>
      'Cannot place rest: this measure has a simile repeat.';

  @override
  String get statusRemovedRestAndLyric => 'Removed rest and attached lyric.';

  @override
  String get statusCannotPlaceRestNote => 'Cannot place rest: overlaps a note.';

  @override
  String get statusCannotPlaceRestRest =>
      'Cannot place rest: overlaps another rest.';

  @override
  String statusPlacedRest(Object rhythm) {
    return 'Placed $rhythm rest.';
  }

  @override
  String get statusSuriClickExistingNote =>
      'Suri mode: click an existing note.';

  @override
  String get statusSuriStartSelected =>
      'Suri start selected. Click the ending note.';

  @override
  String get statusSuriSameString =>
      'Suri must connect notes on the same string.';

  @override
  String get statusSuriNeedsTwoNotes => 'Suri needs two different notes.';

  @override
  String get statusRemovedSuriSlide => 'Removed Suri slide.';

  @override
  String get statusAddedSuriSlide => 'Added Suri slide.';

  @override
  String statusRemovedRepeat(Object repeatLength) {
    return 'Removed $repeatLength-measure simile repeat.';
  }

  @override
  String get statusOneMeasureRepeatCannotBeFirst =>
      'A one-measure simile repeat cannot be placed in measure 1.';

  @override
  String get statusTwoMeasureRepeatNeedsPreviousMeasures =>
      'A two-measure simile repeat needs two previous measures to repeat.';

  @override
  String statusNotEnoughSpaceForRepeat(Object repeatLength) {
    return 'Not enough space for a $repeatLength-measure simile repeat here.';
  }

  @override
  String get statusCannotPlaceRepeatOverNotesOrRests =>
      'Cannot place simile repeat: selected measure range already has notes or rests.';

  @override
  String get statusCannotPlaceRepeatOverRepeat =>
      'Cannot place simile repeat: it overlaps another repeat mark.';

  @override
  String statusAddedOneMeasureRepeat(Object measureNumber) {
    return 'Added one-measure simile repeat to measure $measureNumber.';
  }

  @override
  String statusAddedTwoMeasureRepeat(Object endMeasure, Object startMeasure) {
    return 'Added two-measure simile repeat from measure $startMeasure to $endMeasure.';
  }

  @override
  String get statusNoSelectedNoteToDelete => 'No selected note to delete.';

  @override
  String get statusSelectedNoteMissing => 'Selected note no longer exists.';

  @override
  String get statusDeletedSelectedNote => 'Deleted selected note.';

  @override
  String get statusDeletedNoteRelatedItems =>
      'Deleted note, related Suri slides, and attached lyric.';

  @override
  String get statusDeletedRestAndLyric => 'Deleted rest and attached lyric.';

  @override
  String get statusNoNoteOrRestToErase => 'No note or rest to erase here.';

  @override
  String statusDeletedRepeatFromMeasure(Object measureNumber) {
    return 'Deleted simile repeat from measure $measureNumber.';
  }

  @override
  String get statusNothingToErase => 'Nothing to erase here.';

  @override
  String get aboutDialogTitle => 'About Shamisen Tab Composer';

  @override
  String get aboutDialogBody =>
      'Shamisen Tab Composer Beta 0.2.0\n\nA desktop shamisen tablature editor for creating, saving, loading, and exporting shamisen tab sheets.\n\nCurrent beta features:\n- Note input\n- Rests\n- Suri slide markings\n- Lyrics under notes/rests\n- Section labels\n- Simile repeat marks\n- Save/load song library\n- Save Copy and Open File support\n- PNG/PDF export\n- Undo/Redo\n- Keyboard shortcuts\n- Autosave backup and recovery\n\nBeta notice:\nThis version is ready for public testing. File formats, layout, and export behavior may still change before the stable 1.0 release.';

  @override
  String get helpDialogTitle => 'How to Use Shamisen Tab Composer';

  @override
  String get helpDialogBody =>
      'Basic Workflow\n1. Choose a tab number, rhythm, and technique.\n2. Click directly on a string line to place the tab number.\n3. Click an existing note in Write mode to select and edit it.\n4. Use Save to store the song in your local song library.\n5. Use Load to open a saved song from your local song library.\n6. Use Save Copy to save a JSON copy anywhere on your computer.\n7. Use Open File to open a song file from anywhere on your computer.\n\nTools\n8. Use PNG or PDF export to share or print the current sheet.\n\nAutosave Recovery\nThe app keeps a local autosave backup while you work.\nUse Recover Autosave Backup if the app closes unexpectedly or you need to restore recent work.\n\nWrite: Place notes or select existing notes.\nErase: Smart erase for notes, rests, lyrics, Suri slides, repeats, and section labels.\nSuri: Click two notes on the same string to add or remove a slide mark.\nRest: Place a rhythmic rest on a string line.\nRepeat: Click a measure to add or remove a simile repeat mark.\nLyric: Click a note/rest timing slot to add lyrics under it.\nSection: Click a measure to add labels like Intro, Verse, or Chorus.\n\nSong Settings\nTitle: Used for the sheet title and save file name.\nTuning: Choose Honchoshi, Niagari, or Sansagari.\nBPM: Set the tempo.\nMeasures: Control the length of the song.\nZoom: Adjust horizontal spacing.\nRepeat: Choose one-measure or two-measure simile repeat.\n\nImportant Notes\nLyrics can only be added under an existing note or rest.\nSuri slides must connect two notes on the same string.\nRepeat marks cannot be placed over measures that already contain notes or rests.\nNew Song resets everything.\nClear Song clears the notation but does not reset all song settings.';

  @override
  String get changelogDialogTitle => 'Version History';

  @override
  String get changelogDialogBody =>
      'Shamisen Tab Composer Beta 0.2.0\n\nFirst public beta release candidate for testing the core tablature editor.\n\nIncluded features:\n- Shamisen tab note input\n- Three-string sheet layout\n- Rhythm support: Whole, Half, Quarter, Eighth, Sixteenth\n- Tab number selection\n- Shamisen tuning metadata\n- BPM metadata\n- Measure count control\n- Horizontal zoom control\n- Left-hand technique markings\n- Right-hand technique markings\n- Oshibachi and Suberi above-note markings\n- Suri slide markings\n- Rest input\n- Lyric input under notes and rests\n- Section labels\n- One-measure simile repeat marks\n- Two-measure simile repeat marks\n- Smart erase mode\n- Selected-note editing\n- Undo and redo\n- Save and load local song files\n- Delete saved songs from the Load window\n- Save Copy song file support\n- Open File song file support\n- PNG export\n- PDF export\n- Open song library folder\n- Open export folder\n- Reveal last saved song file\n- Reveal last exported file\n- Keyboard shortcuts\n- Help dialog\n- About dialog\n- Autosave backup\n- Autosave recovery button\n- Unsaved changes status\n\nKnown Beta Limitations:\n- Windows desktop is the main testing platform right now.\n- Export layout may need improvement for long songs.\n- PDF export currently captures the visual sheet as displayed.\n- Mobile layout is not ready.\n- Save file format may change before stable release.\n- More shamisen notation symbols still need to be added.\n\nNext Planned Version: Beta 0.3\n\nPlanned improvements:\n- Cleaner toolbar organization\n- Better exported sheet layout\n- More notation symbols\n- Sample song files\n- Better beginner instructions\n- More testing feedback support';

  @override
  String get sampleSong => 'Sample Song';

  @override
  String get tooltipSampleSong => 'Load a built-in sample song for testing';

  @override
  String get loadSampleSongTitle => 'Load Sample Song';

  @override
  String get loadSampleSongBody =>
      'This will replace the current sheet with a built-in sample song. Unsaved changes should be saved first if you want to keep them.';

  @override
  String get loadSampleSongButton => 'Load Sample';

  @override
  String get sampleSongTitle => 'Sample Shamisen Piece';

  @override
  String get statusLoadedSampleSong =>
      'Loaded sample song. Use Save to keep a copy in your song library.';

  @override
  String get keyboardShortcuts => 'Shortcuts';

  @override
  String get tooltipKeyboardShortcuts => 'Show keyboard shortcuts';

  @override
  String get keyboardShortcutsDialogTitle => 'Keyboard Shortcuts';

  @override
  String get keyboardShortcutsDialogBody =>
      'File and Export\nCtrl+S: Save\nCtrl+N: New Song\nCtrl+O: Load Song\nCtrl+P: Export PDF\nCtrl+Shift+P: Export PNG\n\nEditing\nCtrl+Z: Undo\nCtrl+Y: Redo\nDelete: Delete selected note\nEsc: Clear current selection\n\nTools\nCtrl+1: Write mode\nCtrl+2: Erase mode\nCtrl+3: Suri mode\nCtrl+4: Rest mode\nCtrl+5: Repeat mode\nCtrl+6: Lyric mode\nCtrl+7: Section mode';

  @override
  String get resetView => 'Reset View';

  @override
  String get tooltipResetView =>
      'Reset zoom to 100% and return to the start of the sheet';

  @override
  String get statusResetView =>
      'View reset to 100% zoom and returned to the start of the sheet.';

  @override
  String get clearRecentFiles => 'Clear Recent';

  @override
  String get clearRecentFilesTitle => 'Clear Recent Files';

  @override
  String get clearRecentFilesBody =>
      'This will remove all entries from the Recent Files list. It will not delete any song files.';

  @override
  String get statusClearedRecentFiles => 'Cleared Recent Files list.';

  @override
  String get statusNoRecentFilesToClear =>
      'There are no recent files to clear.';

  @override
  String get jumpToMeasure => 'Jump';

  @override
  String get tooltipJumpToMeasure => 'Jump to a specific measure';

  @override
  String get jumpToMeasureTitle => 'Jump to Measure';

  @override
  String get jumpToMeasureLabel => 'Measure number';

  @override
  String get jumpToMeasureHint => 'Enter a measure number';

  @override
  String get jumpToMeasureButton => 'Jump';

  @override
  String statusJumpedToMeasure(Object measureNumber) {
    return 'Jumped to measure $measureNumber.';
  }

  @override
  String statusInvalidMeasureNumber(Object totalMeasures) {
    return 'Enter a measure number from 1 to $totalMeasures.';
  }

  @override
  String get renameSong => 'Rename';

  @override
  String get tooltipRenameSong =>
      'Rename the current song and update its saved file';

  @override
  String get renameSongTitle => 'Rename Song';

  @override
  String get renameSongLabel => 'New song title';

  @override
  String get renameSongHint => 'Enter a new title';

  @override
  String get renameSongButton => 'Rename';

  @override
  String get statusRenameCancelled => 'Rename cancelled.';

  @override
  String get statusRenameEmptyTitle => 'Song title cannot be empty.';

  @override
  String statusRenamedSong(Object songTitle) {
    return 'Renamed song to \"$songTitle\".';
  }

  @override
  String statusRenameFailed(Object errorMessage) {
    return 'Rename failed: $errorMessage';
  }

  @override
  String get duplicateSong => 'Duplicate';

  @override
  String get tooltipDuplicateSong =>
      'Create a new saved copy of the current song';

  @override
  String get duplicateSongTitle => 'Duplicate Song';

  @override
  String get duplicateSongLabel => 'Duplicate song title';

  @override
  String get duplicateSongHint => 'Enter a title for the copy';

  @override
  String get duplicateSongButton => 'Duplicate';

  @override
  String get duplicateTitleSuffix => 'Copy';

  @override
  String get statusDuplicateCancelled => 'Duplicate cancelled.';

  @override
  String get statusDuplicateEmptyTitle => 'Duplicate title cannot be empty.';

  @override
  String statusDuplicatedSong(Object songTitle) {
    return 'Created duplicate song \"$songTitle\".';
  }

  @override
  String statusDuplicateFailed(Object errorMessage) {
    return 'Duplicate failed: $errorMessage';
  }

  @override
  String get revertToSaved => 'Revert';

  @override
  String get tooltipRevertToSaved =>
      'Reload the last saved version of the current song';

  @override
  String get revertToSavedTitle => 'Revert to Saved';

  @override
  String get revertToSavedBody =>
      'This will discard unsaved changes and reload the last saved version of the current song.';

  @override
  String get revertToSavedButton => 'Revert';

  @override
  String get statusNoSavedVersionToRevert =>
      'No saved library version is selected to revert to.';

  @override
  String get statusSavedVersionMissing =>
      'The saved song file no longer exists.';

  @override
  String get statusRevertedToSaved => 'Reverted to the last saved version.';

  @override
  String get statusRevertCancelled => 'Revert cancelled.';

  @override
  String statusRevertFailed(Object errorMessage) {
    return 'Revert failed: $errorMessage';
  }

  @override
  String get backups => 'Backups';

  @override
  String get tooltipBackupsFolder => 'Open saved song backups folder';

  @override
  String get restoreBackup => 'Restore Backup';

  @override
  String get tooltipRestoreBackup => 'Restore a saved song backup';

  @override
  String get restoreBackupTitle => 'Restore Backup';

  @override
  String get restoreBackupConfirmTitle => 'Restore this backup?';

  @override
  String get restoreBackupConfirmBody =>
      'This will load the selected backup into the editor. It will not overwrite your current saved song until you press Save.';

  @override
  String get restoreBackupButton => 'Restore';

  @override
  String get noSavedSongBackupsFound => 'No saved song backups found.';

  @override
  String get statusBackupFileMissing =>
      'The selected backup file no longer exists.';

  @override
  String get statusRestoreBackupCancelled => 'Restore backup cancelled.';

  @override
  String get statusRestoredBackup =>
      'Restored backup. Review it, then use Save if you want to keep it.';

  @override
  String statusRestoreBackupFailed(Object errorMessage) {
    return 'Restore backup failed: $errorMessage';
  }
}
