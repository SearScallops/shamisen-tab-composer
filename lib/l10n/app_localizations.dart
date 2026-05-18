import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Shamisen Tab Composer Beta 0.2.0'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @songSettings.
  ///
  /// In en, this message translates to:
  /// **'Song Settings'**
  String get songSettings;

  /// No description provided for @noteInput.
  ///
  /// In en, this message translates to:
  /// **'Note Input'**
  String get noteInput;

  /// No description provided for @notationTools.
  ///
  /// In en, this message translates to:
  /// **'Notation Tools'**
  String get notationTools;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @folders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folders;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @tuning.
  ///
  /// In en, this message translates to:
  /// **'Tuning'**
  String get tuning;

  /// No description provided for @bpm.
  ///
  /// In en, this message translates to:
  /// **'BPM'**
  String get bpm;

  /// No description provided for @measures.
  ///
  /// In en, this message translates to:
  /// **'Measures'**
  String get measures;

  /// No description provided for @zoom.
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoom;

  /// No description provided for @tabNumber.
  ///
  /// In en, this message translates to:
  /// **'Tab Number'**
  String get tabNumber;

  /// No description provided for @rhythm.
  ///
  /// In en, this message translates to:
  /// **'Rhythm'**
  String get rhythm;

  /// No description provided for @technique.
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get technique;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @newSong.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newSong;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @load.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get load;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @saveCopy.
  ///
  /// In en, this message translates to:
  /// **'Save Copy'**
  String get saveCopy;

  /// No description provided for @openFile.
  ///
  /// In en, this message translates to:
  /// **'Open File'**
  String get openFile;

  /// No description provided for @recover.
  ///
  /// In en, this message translates to:
  /// **'Recover'**
  String get recover;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @png.
  ///
  /// In en, this message translates to:
  /// **'PNG'**
  String get png;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @exports.
  ///
  /// In en, this message translates to:
  /// **'Exports'**
  String get exports;

  /// No description provided for @lastSave.
  ///
  /// In en, this message translates to:
  /// **'Last Save'**
  String get lastSave;

  /// No description provided for @lastExport.
  ///
  /// In en, this message translates to:
  /// **'Last Export'**
  String get lastExport;

  /// No description provided for @changes.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get changes;

  /// No description provided for @errorReport.
  ///
  /// In en, this message translates to:
  /// **'Error Report'**
  String get errorReport;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @erase.
  ///
  /// In en, this message translates to:
  /// **'Erase'**
  String get erase;

  /// No description provided for @suri.
  ///
  /// In en, this message translates to:
  /// **'Suri'**
  String get suri;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get rest;

  /// No description provided for @lyric.
  ///
  /// In en, this message translates to:
  /// **'Lyric'**
  String get lyric;

  /// No description provided for @section.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get section;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChanges;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @notSavedToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Not saved to library'**
  String get notSavedToLibrary;

  /// No description provided for @noLibraryFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No library file selected'**
  String get noLibraryFileSelected;

  /// No description provided for @libraryFile.
  ///
  /// In en, this message translates to:
  /// **'Library file: {fileName}'**
  String libraryFile(String fileName);

  /// No description provided for @stringLabel.
  ///
  /// In en, this message translates to:
  /// **'String {stringNumber}'**
  String stringLabel(int stringNumber);

  /// No description provided for @lyricsLabel.
  ///
  /// In en, this message translates to:
  /// **'Lyrics'**
  String get lyricsLabel;

  /// No description provided for @modeWrite.
  ///
  /// In en, this message translates to:
  /// **'Mode: Write'**
  String get modeWrite;

  /// No description provided for @modeSmartErase.
  ///
  /// In en, this message translates to:
  /// **'Mode: Smart Erase'**
  String get modeSmartErase;

  /// No description provided for @modeRest.
  ///
  /// In en, this message translates to:
  /// **'Mode: Rest'**
  String get modeRest;

  /// No description provided for @modeSimileRepeat.
  ///
  /// In en, this message translates to:
  /// **'Mode: Simile Repeat'**
  String get modeSimileRepeat;

  /// No description provided for @modeLyric.
  ///
  /// In en, this message translates to:
  /// **'Mode: Lyric'**
  String get modeLyric;

  /// No description provided for @modeSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Mode: Section Label'**
  String get modeSectionLabel;

  /// No description provided for @modeSuriSlide.
  ///
  /// In en, this message translates to:
  /// **'Mode: Suri Slide'**
  String get modeSuriSlide;

  /// No description provided for @metadataLine.
  ///
  /// In en, this message translates to:
  /// **'Tuning: {tuning}    Tempo: {tempoBpm} BPM'**
  String metadataLine(String tuning, int tempoBpm);

  /// No description provided for @returnButton.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnButton;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @overwrite.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite;

  /// No description provided for @saveFirst.
  ///
  /// In en, this message translates to:
  /// **'Save First'**
  String get saveFirst;

  /// No description provided for @continueWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'Continue Without Saving'**
  String get continueWithoutSaving;

  /// No description provided for @recoverBackup.
  ///
  /// In en, this message translates to:
  /// **'Recover Backup'**
  String get recoverBackup;

  /// No description provided for @openFileLocation.
  ///
  /// In en, this message translates to:
  /// **'Open File Location'**
  String get openFileLocation;

  /// No description provided for @unsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChangesTitle;

  /// No description provided for @overwriteSavedSongTitle.
  ///
  /// In en, this message translates to:
  /// **'Overwrite saved song?'**
  String get overwriteSavedSongTitle;

  /// No description provided for @recoverAutosaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover autosave backup?'**
  String get recoverAutosaveTitle;

  /// No description provided for @startNewSongTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new song?'**
  String get startNewSongTitle;

  /// No description provided for @clearCurrentSongTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear current song?'**
  String get clearCurrentSongTitle;

  /// No description provided for @loadSongTitle.
  ///
  /// In en, this message translates to:
  /// **'Load Song'**
  String get loadSongTitle;

  /// No description provided for @recentFilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Files'**
  String get recentFilesTitle;

  /// No description provided for @noRecentFiles.
  ///
  /// In en, this message translates to:
  /// **'No recent files.'**
  String get noRecentFiles;

  /// No description provided for @deleteSavedSongTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete saved song?'**
  String get deleteSavedSongTitle;

  /// No description provided for @saveCopyCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Copy complete'**
  String get saveCopyCompleteTitle;

  /// No description provided for @exportCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'{exportType} export complete'**
  String exportCompleteTitle(String exportType);

  /// No description provided for @savedToPath.
  ///
  /// In en, this message translates to:
  /// **'Saved to:\n{filePath}'**
  String savedToPath(String filePath);

  /// No description provided for @savedCopyToPath.
  ///
  /// In en, this message translates to:
  /// **'Saved copy to:\n{filePath}'**
  String savedCopyToPath(String filePath);

  /// No description provided for @noSavedSongsFound.
  ///
  /// In en, this message translates to:
  /// **'No saved songs found.'**
  String get noSavedSongsFound;

  /// No description provided for @modifiedDate.
  ///
  /// In en, this message translates to:
  /// **'Modified: {modifiedDate}'**
  String modifiedDate(String modifiedDate);

  /// No description provided for @unsavedChangesBody.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. What do you want to do before {actionName}?'**
  String unsavedChangesBody(String actionName);

  /// No description provided for @overwriteSavedSongBody.
  ///
  /// In en, this message translates to:
  /// **'A saved song named \"{songTitle}\" already exists.\n\nDo you want to replace it?'**
  String overwriteSavedSongBody(String songTitle);

  /// No description provided for @recoverAutosaveBody.
  ///
  /// In en, this message translates to:
  /// **'This will replace the current sheet with the latest autosave backup. Use this only if you want to restore recent unsaved work.'**
  String get recoverAutosaveBody;

  /// No description provided for @startNewSongBody.
  ///
  /// In en, this message translates to:
  /// **'This will clear the current sheet and reset the title, tuning, tempo, measures, and zoom.'**
  String get startNewSongBody;

  /// No description provided for @clearCurrentSongBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove all notes, rests, Suri slides, lyrics, repeats, and section labels. Song settings will stay the same.'**
  String get clearCurrentSongBody;

  /// No description provided for @deleteCurrentSongBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{songName}\"? This is the song currently open in the editor.\n\nThe sheet will stay open, but it will become unsaved.'**
  String deleteCurrentSongBody(String songName);

  /// No description provided for @deleteSavedSongBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{songName}\"? This cannot be undone.'**
  String deleteSavedSongBody(String songName);

  /// No description provided for @removeFromRecentFiles.
  ///
  /// In en, this message translates to:
  /// **'Remove from recent files'**
  String get removeFromRecentFiles;

  /// No description provided for @tooltipWrite.
  ///
  /// In en, this message translates to:
  /// **'Write note (Ctrl + 1)'**
  String get tooltipWrite;

  /// No description provided for @tooltipErase.
  ///
  /// In en, this message translates to:
  /// **'Smart erase (Ctrl + 2)'**
  String get tooltipErase;

  /// No description provided for @tooltipSuri.
  ///
  /// In en, this message translates to:
  /// **'Suri slide mode (Ctrl + 3)'**
  String get tooltipSuri;

  /// No description provided for @tooltipRest.
  ///
  /// In en, this message translates to:
  /// **'Rest mode (Ctrl + 4)'**
  String get tooltipRest;

  /// No description provided for @tooltipRepeat.
  ///
  /// In en, this message translates to:
  /// **'Simile repeat mode (Ctrl + 5)'**
  String get tooltipRepeat;

  /// No description provided for @tooltipLyric.
  ///
  /// In en, this message translates to:
  /// **'Lyric mode (Ctrl + 6)'**
  String get tooltipLyric;

  /// No description provided for @tooltipSection.
  ///
  /// In en, this message translates to:
  /// **'Section label mode (Ctrl + 7)'**
  String get tooltipSection;

  /// No description provided for @tooltipNewSong.
  ///
  /// In en, this message translates to:
  /// **'Start a new song'**
  String get tooltipNewSong;

  /// No description provided for @tooltipSave.
  ///
  /// In en, this message translates to:
  /// **'Save song to the local song library'**
  String get tooltipSave;

  /// No description provided for @tooltipLoad.
  ///
  /// In en, this message translates to:
  /// **'Load song from the local song library'**
  String get tooltipLoad;

  /// No description provided for @tooltipRecent.
  ///
  /// In en, this message translates to:
  /// **'Open a recently used song file'**
  String get tooltipRecent;

  /// No description provided for @tooltipSaveCopy.
  ///
  /// In en, this message translates to:
  /// **'Save a JSON copy anywhere on your computer without changing the active library file'**
  String get tooltipSaveCopy;

  /// No description provided for @tooltipOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Open a song file from anywhere on your computer'**
  String get tooltipOpenFile;

  /// No description provided for @tooltipRecover.
  ///
  /// In en, this message translates to:
  /// **'Recover autosave backup'**
  String get tooltipRecover;

  /// No description provided for @tooltipClear.
  ///
  /// In en, this message translates to:
  /// **'Clear current song notation'**
  String get tooltipClear;

  /// No description provided for @tooltipUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo last action'**
  String get tooltipUndo;

  /// No description provided for @tooltipRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo last action'**
  String get tooltipRedo;

  /// No description provided for @tooltipExportPng.
  ///
  /// In en, this message translates to:
  /// **'Export sheet as PNG image'**
  String get tooltipExportPng;

  /// No description provided for @tooltipExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export sheet as PDF document'**
  String get tooltipExportPdf;

  /// No description provided for @tooltipSongsFolder.
  ///
  /// In en, this message translates to:
  /// **'Open song library folder'**
  String get tooltipSongsFolder;

  /// No description provided for @tooltipExportsFolder.
  ///
  /// In en, this message translates to:
  /// **'Open export folder'**
  String get tooltipExportsFolder;

  /// No description provided for @tooltipLastSave.
  ///
  /// In en, this message translates to:
  /// **'Show last saved song file'**
  String get tooltipLastSave;

  /// No description provided for @tooltipLastExport.
  ///
  /// In en, this message translates to:
  /// **'Show last exported file'**
  String get tooltipLastExport;

  /// No description provided for @tooltipHelp.
  ///
  /// In en, this message translates to:
  /// **'Help / Instructions'**
  String get tooltipHelp;

  /// No description provided for @tooltipChanges.
  ///
  /// In en, this message translates to:
  /// **'Version history'**
  String get tooltipChanges;

  /// No description provided for @tooltipErrorReport.
  ///
  /// In en, this message translates to:
  /// **'Export local error log'**
  String get tooltipErrorReport;

  /// No description provided for @tooltipAbout.
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get tooltipAbout;

  /// No description provided for @tooltipZoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get tooltipZoomOut;

  /// No description provided for @tooltipZoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get tooltipZoomIn;

  /// No description provided for @statusLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'Language set to system default.'**
  String get statusLanguageSystem;

  /// No description provided for @statusLanguageJapanese.
  ///
  /// In en, this message translates to:
  /// **'Language set to Japanese.'**
  String get statusLanguageJapanese;

  /// No description provided for @statusLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'Language set to English.'**
  String get statusLanguageEnglish;

  /// No description provided for @statusUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Updated song title.'**
  String get statusUpdatedTitle;

  /// No description provided for @statusSelectedTuning.
  ///
  /// In en, this message translates to:
  /// **'Selected tuning: {tuning}.'**
  String statusSelectedTuning(String tuning);

  /// No description provided for @statusTempoPositiveNumber.
  ///
  /// In en, this message translates to:
  /// **'Tempo should be a positive number.'**
  String get statusTempoPositiveNumber;

  /// No description provided for @statusUpdatedTempo.
  ///
  /// In en, this message translates to:
  /// **'Updated tempo to {tempoBpm} BPM.'**
  String statusUpdatedTempo(int tempoBpm);

  /// No description provided for @statusSetMeasures.
  ///
  /// In en, this message translates to:
  /// **'Set song length to {measureCount} measures.'**
  String statusSetMeasures(int measureCount);

  /// No description provided for @statusSetMeasuresRemovedItems.
  ///
  /// In en, this message translates to:
  /// **'Set song length to {measureCount} measures. Removed {removedCount} out-of-range item(s).'**
  String statusSetMeasuresRemovedItems(int measureCount, int removedCount);

  /// No description provided for @statusResetZoom.
  ///
  /// In en, this message translates to:
  /// **'Reset zoom to 100%.'**
  String get statusResetZoom;

  /// No description provided for @statusSetZoom.
  ///
  /// In en, this message translates to:
  /// **'Set zoom to {zoomPercent}%.'**
  String statusSetZoom(int zoomPercent);

  /// No description provided for @statusMinimumZoom.
  ///
  /// In en, this message translates to:
  /// **'Already at minimum zoom.'**
  String get statusMinimumZoom;

  /// No description provided for @statusMaximumZoom.
  ///
  /// In en, this message translates to:
  /// **'Already at maximum zoom.'**
  String get statusMaximumZoom;

  /// No description provided for @statusSelectedTabNumber.
  ///
  /// In en, this message translates to:
  /// **'Selected tab number {tabNumber}.'**
  String statusSelectedTabNumber(String tabNumber);

  /// No description provided for @statusSelectedRhythm.
  ///
  /// In en, this message translates to:
  /// **'Selected {rhythm} rhythm: {slotCount} slots.'**
  String statusSelectedRhythm(String rhythm, int slotCount);

  /// No description provided for @statusSelectedTechnique.
  ///
  /// In en, this message translates to:
  /// **'Selected technique: {technique}.'**
  String statusSelectedTechnique(String technique);

  /// No description provided for @statusSelectedRepeat.
  ///
  /// In en, this message translates to:
  /// **'Selected {repeatName} repeat.'**
  String statusSelectedRepeat(String repeatName);

  /// No description provided for @oneMeasure.
  ///
  /// In en, this message translates to:
  /// **'one-measure'**
  String get oneMeasure;

  /// No description provided for @twoMeasure.
  ///
  /// In en, this message translates to:
  /// **'two-measure'**
  String get twoMeasure;

  /// No description provided for @statusNothingToUndo.
  ///
  /// In en, this message translates to:
  /// **'Nothing to undo.'**
  String get statusNothingToUndo;

  /// No description provided for @statusUndidLastAction.
  ///
  /// In en, this message translates to:
  /// **'Undid last action.'**
  String get statusUndidLastAction;

  /// No description provided for @statusNothingToRedo.
  ///
  /// In en, this message translates to:
  /// **'Nothing to redo.'**
  String get statusNothingToRedo;

  /// No description provided for @statusRedidLastAction.
  ///
  /// In en, this message translates to:
  /// **'Redid last action.'**
  String get statusRedidLastAction;

  /// No description provided for @statusClearedSelection.
  ///
  /// In en, this message translates to:
  /// **'Cleared selection.'**
  String get statusClearedSelection;

  /// No description provided for @statusStartedNewSong.
  ///
  /// In en, this message translates to:
  /// **'Started new song.'**
  String get statusStartedNewSong;

  /// No description provided for @statusClearedSong.
  ///
  /// In en, this message translates to:
  /// **'Cleared song.'**
  String get statusClearedSong;

  /// No description provided for @statusSavedSong.
  ///
  /// In en, this message translates to:
  /// **'Saved \"{songTitle}\" successfully.'**
  String statusSavedSong(String songTitle);

  /// No description provided for @statusSaveCancelledOverwrite.
  ///
  /// In en, this message translates to:
  /// **'Save cancelled to avoid overwriting \"{songTitle}\".'**
  String statusSaveCancelledOverwrite(String songTitle);

  /// No description provided for @statusSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {errorMessage}'**
  String statusSaveFailed(String errorMessage);

  /// No description provided for @statusLoadedSong.
  ///
  /// In en, this message translates to:
  /// **'Loaded \"{songTitle}\" successfully.'**
  String statusLoadedSong(String songTitle);

  /// No description provided for @statusLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Load failed: {errorMessage}'**
  String statusLoadFailed(String errorMessage);

  /// No description provided for @statusSaveCopyCancelled.
  ///
  /// In en, this message translates to:
  /// **'Save Copy cancelled.'**
  String get statusSaveCopyCancelled;

  /// No description provided for @statusSaveCopySuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved song copy successfully. Your active library file was not changed.'**
  String get statusSaveCopySuccess;

  /// No description provided for @statusSaveCopyFailed.
  ///
  /// In en, this message translates to:
  /// **'Save Copy failed: {errorMessage}'**
  String statusSaveCopyFailed(String errorMessage);

  /// No description provided for @statusOpenFileCancelled.
  ///
  /// In en, this message translates to:
  /// **'Open File cancelled.'**
  String get statusOpenFileCancelled;

  /// No description provided for @statusOpenFileMissing.
  ///
  /// In en, this message translates to:
  /// **'Open File failed: selected file does not exist.'**
  String get statusOpenFileMissing;

  /// No description provided for @statusOpenFileSuccess.
  ///
  /// In en, this message translates to:
  /// **'Opened song file successfully. Use Save to add it to your song library.'**
  String get statusOpenFileSuccess;

  /// No description provided for @statusOpenFileFailed.
  ///
  /// In en, this message translates to:
  /// **'Open File failed: {errorMessage}'**
  String statusOpenFileFailed(String errorMessage);

  /// No description provided for @zoomOutButton.
  ///
  /// In en, this message translates to:
  /// **'Zoom -'**
  String get zoomOutButton;

  /// No description provided for @zoomInButton.
  ///
  /// In en, this message translates to:
  /// **'Zoom +'**
  String get zoomInButton;

  /// No description provided for @deleteSavedSongTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete saved song'**
  String get deleteSavedSongTooltip;

  /// No description provided for @lyricDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Lyric'**
  String get lyricDialogTitle;

  /// No description provided for @lyricTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Lyric text'**
  String get lyricTextLabel;

  /// No description provided for @lyricTextHint.
  ///
  /// In en, this message translates to:
  /// **'Example: sakura / さくら / 桜'**
  String get lyricTextHint;

  /// No description provided for @sectionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Section label for measure {measureNumber}'**
  String sectionDialogTitle(int measureNumber);

  /// No description provided for @sectionLabelText.
  ///
  /// In en, this message translates to:
  /// **'Section label'**
  String get sectionLabelText;

  /// No description provided for @sectionLabelHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Intro / Verse / Chorus'**
  String get sectionLabelHint;

  /// No description provided for @statusClickInsideMeasureArea.
  ///
  /// In en, this message translates to:
  /// **'Click inside the song measure area.'**
  String get statusClickInsideMeasureArea;

  /// No description provided for @statusPlaceNoteOrRestBeforeLyric.
  ///
  /// In en, this message translates to:
  /// **'Place a note or rest first, then add lyrics under it.'**
  String get statusPlaceNoteOrRestBeforeLyric;

  /// No description provided for @statusNoLyricAdded.
  ///
  /// In en, this message translates to:
  /// **'No lyric added.'**
  String get statusNoLyricAdded;

  /// No description provided for @statusDeletedLyric.
  ///
  /// In en, this message translates to:
  /// **'Deleted lyric.'**
  String get statusDeletedLyric;

  /// No description provided for @statusUpdatedLyric.
  ///
  /// In en, this message translates to:
  /// **'Updated lyric.'**
  String get statusUpdatedLyric;

  /// No description provided for @statusAddedLyric.
  ///
  /// In en, this message translates to:
  /// **'Added lyric under note/rest.'**
  String get statusAddedLyric;

  /// No description provided for @statusNoSectionLabelAdded.
  ///
  /// In en, this message translates to:
  /// **'No section label added.'**
  String get statusNoSectionLabelAdded;

  /// No description provided for @statusDeletedSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Deleted section label.'**
  String get statusDeletedSectionLabel;

  /// No description provided for @statusUpdatedSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated section label.'**
  String get statusUpdatedSectionLabel;

  /// No description provided for @statusAddedSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Added section label.'**
  String get statusAddedSectionLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
