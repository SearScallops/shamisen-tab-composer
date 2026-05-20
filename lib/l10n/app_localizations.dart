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

  /// No description provided for @statusAutosaveFound.
  ///
  /// In en, this message translates to:
  /// **'Autosave backup found. Use Recover Autosave Backup if you need it.'**
  String get statusAutosaveFound;

  /// No description provided for @statusAutosaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Autosave failed: {errorMessage}'**
  String statusAutosaveFailed(Object errorMessage);

  /// No description provided for @statusNoAutosaveBackup.
  ///
  /// In en, this message translates to:
  /// **'No autosave backup found.'**
  String get statusNoAutosaveBackup;

  /// No description provided for @statusRecoveredAutosave.
  ///
  /// In en, this message translates to:
  /// **'Recovered autosave backup. Use Save to store it as a normal song.'**
  String get statusRecoveredAutosave;

  /// No description provided for @statusAutosaveRecoveryFailed.
  ///
  /// In en, this message translates to:
  /// **'Autosave recovery failed: {errorMessage}'**
  String statusAutosaveRecoveryFailed(Object errorMessage);

  /// No description provided for @statusExportingPng.
  ///
  /// In en, this message translates to:
  /// **'Exporting PNG...'**
  String get statusExportingPng;

  /// No description provided for @statusExportingPdf.
  ///
  /// In en, this message translates to:
  /// **'Exporting PDF...'**
  String get statusExportingPdf;

  /// No description provided for @statusPngExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'PNG export completed successfully.'**
  String get statusPngExportSuccess;

  /// No description provided for @statusPdfExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'PDF export completed successfully.'**
  String get statusPdfExportSuccess;

  /// No description provided for @statusPngExportFailed.
  ///
  /// In en, this message translates to:
  /// **'PNG export failed: {errorMessage}'**
  String statusPngExportFailed(Object errorMessage);

  /// No description provided for @statusPdfExportFailed.
  ///
  /// In en, this message translates to:
  /// **'PDF export failed: {errorMessage}'**
  String statusPdfExportFailed(Object errorMessage);

  /// No description provided for @statusToolWrite.
  ///
  /// In en, this message translates to:
  /// **'Write mode.'**
  String get statusToolWrite;

  /// No description provided for @statusToolErase.
  ///
  /// In en, this message translates to:
  /// **'Erase mode: click notes, rests, lyrics, Suri slides, repeats, or section labels.'**
  String get statusToolErase;

  /// No description provided for @statusToolSuri.
  ///
  /// In en, this message translates to:
  /// **'Suri mode: click the starting note, then ending note.'**
  String get statusToolSuri;

  /// No description provided for @statusToolRest.
  ///
  /// In en, this message translates to:
  /// **'Rest mode: click a line to place a rest.'**
  String get statusToolRest;

  /// No description provided for @statusToolRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat mode: click a measure to toggle a simile mark.'**
  String get statusToolRepeat;

  /// No description provided for @statusToolLyric.
  ///
  /// In en, this message translates to:
  /// **'Lyric mode: click a note/rest timing slot to add or edit lyrics.'**
  String get statusToolLyric;

  /// No description provided for @statusToolSection.
  ///
  /// In en, this message translates to:
  /// **'Section mode: click a measure to add/edit a label.'**
  String get statusToolSection;

  /// No description provided for @statusDeletedCurrentSongFile.
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{songName}\". The current sheet is still open, but it is no longer saved.'**
  String statusDeletedCurrentSongFile(Object songName);

  /// No description provided for @statusDeletedSavedSongFile.
  ///
  /// In en, this message translates to:
  /// **'Deleted saved song \"{songName}\".'**
  String statusDeletedSavedSongFile(Object songName);

  /// No description provided for @statusDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {errorMessage}'**
  String statusDeleteFailed(Object errorMessage);

  /// No description provided for @statusRecentFileMissing.
  ///
  /// In en, this message translates to:
  /// **'Recent file no longer exists. Removed it from the list.'**
  String get statusRecentFileMissing;

  /// No description provided for @statusLoadFileMissing.
  ///
  /// In en, this message translates to:
  /// **'Load failed: selected song file no longer exists.'**
  String get statusLoadFileMissing;

  /// No description provided for @statusLoadNewerFileFormat.
  ///
  /// In en, this message translates to:
  /// **'Load failed: this song file uses a newer file format. Please update the app.'**
  String get statusLoadNewerFileFormat;

  /// No description provided for @statusSelectedNote.
  ///
  /// In en, this message translates to:
  /// **'Selected note {tabNumber} on String {stringNumber}.'**
  String statusSelectedNote(Object stringNumber, Object tabNumber);

  /// No description provided for @statusUpdatedSelectedNote.
  ///
  /// In en, this message translates to:
  /// **'Updated selected note.'**
  String get statusUpdatedSelectedNote;

  /// No description provided for @statusSelectedNoteOverlapRepeat.
  ///
  /// In en, this message translates to:
  /// **'Cannot update selected note: rhythm overlaps a simile repeat measure.'**
  String get statusSelectedNoteOverlapRepeat;

  /// No description provided for @statusSelectedNoteOverlapNote.
  ///
  /// In en, this message translates to:
  /// **'Cannot update selected note: rhythm overlaps another note.'**
  String get statusSelectedNoteOverlapNote;

  /// No description provided for @statusSelectedNoteOverlapRest.
  ///
  /// In en, this message translates to:
  /// **'Cannot update selected note: rhythm overlaps a rest.'**
  String get statusSelectedNoteOverlapRest;

  /// No description provided for @statusCannotPlaceNoteRepeat.
  ///
  /// In en, this message translates to:
  /// **'Cannot place note: this measure has a simile repeat.'**
  String get statusCannotPlaceNoteRepeat;

  /// No description provided for @statusCannotPlaceNoteRest.
  ///
  /// In en, this message translates to:
  /// **'Cannot place note: rhythm overlaps a rest.'**
  String get statusCannotPlaceNoteRest;

  /// No description provided for @statusCannotPlaceNoteNote.
  ///
  /// In en, this message translates to:
  /// **'Cannot place note: rhythm overlaps another note.'**
  String get statusCannotPlaceNoteNote;

  /// No description provided for @statusPlacedSelectedNote.
  ///
  /// In en, this message translates to:
  /// **'Placed and selected {rhythm} note.'**
  String statusPlacedSelectedNote(Object rhythm);

  /// No description provided for @statusCannotPlaceRestRepeat.
  ///
  /// In en, this message translates to:
  /// **'Cannot place rest: this measure has a simile repeat.'**
  String get statusCannotPlaceRestRepeat;

  /// No description provided for @statusRemovedRestAndLyric.
  ///
  /// In en, this message translates to:
  /// **'Removed rest and attached lyric.'**
  String get statusRemovedRestAndLyric;

  /// No description provided for @statusCannotPlaceRestNote.
  ///
  /// In en, this message translates to:
  /// **'Cannot place rest: overlaps a note.'**
  String get statusCannotPlaceRestNote;

  /// No description provided for @statusCannotPlaceRestRest.
  ///
  /// In en, this message translates to:
  /// **'Cannot place rest: overlaps another rest.'**
  String get statusCannotPlaceRestRest;

  /// No description provided for @statusPlacedRest.
  ///
  /// In en, this message translates to:
  /// **'Placed {rhythm} rest.'**
  String statusPlacedRest(Object rhythm);

  /// No description provided for @statusSuriClickExistingNote.
  ///
  /// In en, this message translates to:
  /// **'Suri mode: click an existing note.'**
  String get statusSuriClickExistingNote;

  /// No description provided for @statusSuriStartSelected.
  ///
  /// In en, this message translates to:
  /// **'Suri start selected. Click the ending note.'**
  String get statusSuriStartSelected;

  /// No description provided for @statusSuriSameString.
  ///
  /// In en, this message translates to:
  /// **'Suri must connect notes on the same string.'**
  String get statusSuriSameString;

  /// No description provided for @statusSuriNeedsTwoNotes.
  ///
  /// In en, this message translates to:
  /// **'Suri needs two different notes.'**
  String get statusSuriNeedsTwoNotes;

  /// No description provided for @statusRemovedSuriSlide.
  ///
  /// In en, this message translates to:
  /// **'Removed Suri slide.'**
  String get statusRemovedSuriSlide;

  /// No description provided for @statusAddedSuriSlide.
  ///
  /// In en, this message translates to:
  /// **'Added Suri slide.'**
  String get statusAddedSuriSlide;

  /// No description provided for @statusRemovedRepeat.
  ///
  /// In en, this message translates to:
  /// **'Removed {repeatLength}-measure simile repeat.'**
  String statusRemovedRepeat(Object repeatLength);

  /// No description provided for @statusOneMeasureRepeatCannotBeFirst.
  ///
  /// In en, this message translates to:
  /// **'A one-measure simile repeat cannot be placed in measure 1.'**
  String get statusOneMeasureRepeatCannotBeFirst;

  /// No description provided for @statusTwoMeasureRepeatNeedsPreviousMeasures.
  ///
  /// In en, this message translates to:
  /// **'A two-measure simile repeat needs two previous measures to repeat.'**
  String get statusTwoMeasureRepeatNeedsPreviousMeasures;

  /// No description provided for @statusNotEnoughSpaceForRepeat.
  ///
  /// In en, this message translates to:
  /// **'Not enough space for a {repeatLength}-measure simile repeat here.'**
  String statusNotEnoughSpaceForRepeat(Object repeatLength);

  /// No description provided for @statusCannotPlaceRepeatOverNotesOrRests.
  ///
  /// In en, this message translates to:
  /// **'Cannot place simile repeat: selected measure range already has notes or rests.'**
  String get statusCannotPlaceRepeatOverNotesOrRests;

  /// No description provided for @statusCannotPlaceRepeatOverRepeat.
  ///
  /// In en, this message translates to:
  /// **'Cannot place simile repeat: it overlaps another repeat mark.'**
  String get statusCannotPlaceRepeatOverRepeat;

  /// No description provided for @statusAddedOneMeasureRepeat.
  ///
  /// In en, this message translates to:
  /// **'Added one-measure simile repeat to measure {measureNumber}.'**
  String statusAddedOneMeasureRepeat(Object measureNumber);

  /// No description provided for @statusAddedTwoMeasureRepeat.
  ///
  /// In en, this message translates to:
  /// **'Added two-measure simile repeat from measure {startMeasure} to {endMeasure}.'**
  String statusAddedTwoMeasureRepeat(Object endMeasure, Object startMeasure);

  /// No description provided for @statusNoSelectedNoteToDelete.
  ///
  /// In en, this message translates to:
  /// **'No selected note to delete.'**
  String get statusNoSelectedNoteToDelete;

  /// No description provided for @statusSelectedNoteMissing.
  ///
  /// In en, this message translates to:
  /// **'Selected note no longer exists.'**
  String get statusSelectedNoteMissing;

  /// No description provided for @statusDeletedSelectedNote.
  ///
  /// In en, this message translates to:
  /// **'Deleted selected note.'**
  String get statusDeletedSelectedNote;

  /// No description provided for @statusDeletedNoteRelatedItems.
  ///
  /// In en, this message translates to:
  /// **'Deleted note, related Suri slides, and attached lyric.'**
  String get statusDeletedNoteRelatedItems;

  /// No description provided for @statusDeletedRestAndLyric.
  ///
  /// In en, this message translates to:
  /// **'Deleted rest and attached lyric.'**
  String get statusDeletedRestAndLyric;

  /// No description provided for @statusNoNoteOrRestToErase.
  ///
  /// In en, this message translates to:
  /// **'No note or rest to erase here.'**
  String get statusNoNoteOrRestToErase;

  /// No description provided for @statusDeletedRepeatFromMeasure.
  ///
  /// In en, this message translates to:
  /// **'Deleted simile repeat from measure {measureNumber}.'**
  String statusDeletedRepeatFromMeasure(Object measureNumber);

  /// No description provided for @statusNothingToErase.
  ///
  /// In en, this message translates to:
  /// **'Nothing to erase here.'**
  String get statusNothingToErase;

  /// No description provided for @aboutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'About Shamisen Tab Composer'**
  String get aboutDialogTitle;

  /// No description provided for @aboutDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Shamisen Tab Composer Beta 0.2.0\n\nA desktop shamisen tablature editor for creating, saving, loading, and exporting shamisen tab sheets.\n\nCurrent beta features:\n- Note input\n- Rests\n- Suri slide markings\n- Lyrics under notes/rests\n- Section labels\n- Simile repeat marks\n- Save/load song library\n- Save Copy and Open File support\n- PNG/PDF export\n- Undo/Redo\n- Keyboard shortcuts\n- Autosave backup and recovery\n\nBeta notice:\nThis version is ready for public testing. File formats, layout, and export behavior may still change before the stable 1.0 release.'**
  String get aboutDialogBody;

  /// No description provided for @helpDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Use Shamisen Tab Composer'**
  String get helpDialogTitle;

  /// No description provided for @helpDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Basic Workflow\n1. Choose a tab number, rhythm, and technique.\n2. Click directly on a string line to place the tab number.\n3. Click an existing note in Write mode to select and edit it.\n4. Use Save to store the song in your local song library.\n5. Use Load to open a saved song from your local song library.\n6. Use Save Copy to save a JSON copy anywhere on your computer.\n7. Use Open File to open a song file from anywhere on your computer.\n\nTools\n8. Use PNG or PDF export to share or print the current sheet.\n\nAutosave Recovery\nThe app keeps a local autosave backup while you work.\nUse Recover Autosave Backup if the app closes unexpectedly or you need to restore recent work.\n\nWrite: Place notes or select existing notes.\nErase: Smart erase for notes, rests, lyrics, Suri slides, repeats, and section labels.\nSuri: Click two notes on the same string to add or remove a slide mark.\nRest: Place a rhythmic rest on a string line.\nRepeat: Click a measure to add or remove a simile repeat mark.\nLyric: Click a note/rest timing slot to add lyrics under it.\nSection: Click a measure to add labels like Intro, Verse, or Chorus.\n\nSong Settings\nTitle: Used for the sheet title and save file name.\nTuning: Choose Honchoshi, Niagari, or Sansagari.\nBPM: Set the tempo.\nMeasures: Control the length of the song.\nZoom: Adjust horizontal spacing.\nRepeat: Choose one-measure or two-measure simile repeat.\n\nImportant Notes\nLyrics can only be added under an existing note or rest.\nSuri slides must connect two notes on the same string.\nRepeat marks cannot be placed over measures that already contain notes or rests.\nNew Song resets everything.\nClear Song clears the notation but does not reset all song settings.'**
  String get helpDialogBody;

  /// No description provided for @changelogDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Version History'**
  String get changelogDialogTitle;

  /// No description provided for @changelogDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Shamisen Tab Composer Beta 0.2.0\n\nFirst public beta release candidate for testing the core tablature editor.\n\nIncluded features:\n- Shamisen tab note input\n- Three-string sheet layout\n- Rhythm support: Whole, Half, Quarter, Eighth, Sixteenth\n- Tab number selection\n- Shamisen tuning metadata\n- BPM metadata\n- Measure count control\n- Horizontal zoom control\n- Left-hand technique markings\n- Right-hand technique markings\n- Oshibachi and Suberi above-note markings\n- Suri slide markings\n- Rest input\n- Lyric input under notes and rests\n- Section labels\n- One-measure simile repeat marks\n- Two-measure simile repeat marks\n- Smart erase mode\n- Selected-note editing\n- Undo and redo\n- Save and load local song files\n- Delete saved songs from the Load window\n- Save Copy song file support\n- Open File song file support\n- PNG export\n- PDF export\n- Open song library folder\n- Open export folder\n- Reveal last saved song file\n- Reveal last exported file\n- Keyboard shortcuts\n- Help dialog\n- About dialog\n- Autosave backup\n- Autosave recovery button\n- Unsaved changes status\n\nKnown Beta Limitations:\n- Windows desktop is the main testing platform right now.\n- Export layout may need improvement for long songs.\n- PDF export currently captures the visual sheet as displayed.\n- Mobile layout is not ready.\n- Save file format may change before stable release.\n- More shamisen notation symbols still need to be added.\n\nNext Planned Version: Beta 0.3\n\nPlanned improvements:\n- Cleaner toolbar organization\n- Better exported sheet layout\n- More notation symbols\n- Sample song files\n- Better beginner instructions\n- More testing feedback support'**
  String get changelogDialogBody;

  /// No description provided for @sampleSong.
  ///
  /// In en, this message translates to:
  /// **'Sample Song'**
  String get sampleSong;

  /// No description provided for @tooltipSampleSong.
  ///
  /// In en, this message translates to:
  /// **'Load a built-in sample song for testing'**
  String get tooltipSampleSong;

  /// No description provided for @loadSampleSongTitle.
  ///
  /// In en, this message translates to:
  /// **'Load Sample Song'**
  String get loadSampleSongTitle;

  /// No description provided for @loadSampleSongBody.
  ///
  /// In en, this message translates to:
  /// **'This will replace the current sheet with a built-in sample song. Unsaved changes should be saved first if you want to keep them.'**
  String get loadSampleSongBody;

  /// No description provided for @loadSampleSongButton.
  ///
  /// In en, this message translates to:
  /// **'Load Sample'**
  String get loadSampleSongButton;

  /// No description provided for @sampleSongTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample Shamisen Piece'**
  String get sampleSongTitle;

  /// No description provided for @statusLoadedSampleSong.
  ///
  /// In en, this message translates to:
  /// **'Loaded sample song. Use Save to keep a copy in your song library.'**
  String get statusLoadedSampleSong;

  /// No description provided for @keyboardShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get keyboardShortcuts;

  /// No description provided for @tooltipKeyboardShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Show keyboard shortcuts'**
  String get tooltipKeyboardShortcuts;

  /// No description provided for @keyboardShortcutsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard Shortcuts'**
  String get keyboardShortcutsDialogTitle;

  /// No description provided for @keyboardShortcutsDialogBody.
  ///
  /// In en, this message translates to:
  /// **'File and Export\nCtrl+S: Save\nCtrl+N: New Song\nCtrl+O: Load Song\nCtrl+P: Export PDF\nCtrl+Shift+P: Export PNG\n\nEditing\nCtrl+Z: Undo\nCtrl+Y: Redo\nDelete: Delete selected note\nEsc: Clear current selection\n\nTools\nCtrl+1: Write mode\nCtrl+2: Erase mode\nCtrl+3: Suri mode\nCtrl+4: Rest mode\nCtrl+5: Repeat mode\nCtrl+6: Lyric mode\nCtrl+7: Section mode'**
  String get keyboardShortcutsDialogBody;

  /// No description provided for @resetView.
  ///
  /// In en, this message translates to:
  /// **'Reset View'**
  String get resetView;

  /// No description provided for @tooltipResetView.
  ///
  /// In en, this message translates to:
  /// **'Reset zoom to 100% and return to the start of the sheet'**
  String get tooltipResetView;

  /// No description provided for @statusResetView.
  ///
  /// In en, this message translates to:
  /// **'View reset to 100% zoom and returned to the start of the sheet.'**
  String get statusResetView;

  /// No description provided for @clearRecentFiles.
  ///
  /// In en, this message translates to:
  /// **'Clear Recent'**
  String get clearRecentFiles;

  /// No description provided for @clearRecentFilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Recent Files'**
  String get clearRecentFilesTitle;

  /// No description provided for @clearRecentFilesBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove all entries from the Recent Files list. It will not delete any song files.'**
  String get clearRecentFilesBody;

  /// No description provided for @statusClearedRecentFiles.
  ///
  /// In en, this message translates to:
  /// **'Cleared Recent Files list.'**
  String get statusClearedRecentFiles;

  /// No description provided for @statusNoRecentFilesToClear.
  ///
  /// In en, this message translates to:
  /// **'There are no recent files to clear.'**
  String get statusNoRecentFilesToClear;

  /// No description provided for @jumpToMeasure.
  ///
  /// In en, this message translates to:
  /// **'Jump'**
  String get jumpToMeasure;

  /// No description provided for @tooltipJumpToMeasure.
  ///
  /// In en, this message translates to:
  /// **'Jump to a specific measure'**
  String get tooltipJumpToMeasure;

  /// No description provided for @jumpToMeasureTitle.
  ///
  /// In en, this message translates to:
  /// **'Jump to Measure'**
  String get jumpToMeasureTitle;

  /// No description provided for @jumpToMeasureLabel.
  ///
  /// In en, this message translates to:
  /// **'Measure number'**
  String get jumpToMeasureLabel;

  /// No description provided for @jumpToMeasureHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a measure number'**
  String get jumpToMeasureHint;

  /// No description provided for @jumpToMeasureButton.
  ///
  /// In en, this message translates to:
  /// **'Jump'**
  String get jumpToMeasureButton;

  /// No description provided for @statusJumpedToMeasure.
  ///
  /// In en, this message translates to:
  /// **'Jumped to measure {measureNumber}.'**
  String statusJumpedToMeasure(Object measureNumber);

  /// No description provided for @statusInvalidMeasureNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a measure number from 1 to {totalMeasures}.'**
  String statusInvalidMeasureNumber(Object totalMeasures);

  /// No description provided for @renameSong.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameSong;

  /// No description provided for @tooltipRenameSong.
  ///
  /// In en, this message translates to:
  /// **'Rename the current song and update its saved file'**
  String get tooltipRenameSong;

  /// No description provided for @renameSongTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Song'**
  String get renameSongTitle;

  /// No description provided for @renameSongLabel.
  ///
  /// In en, this message translates to:
  /// **'New song title'**
  String get renameSongLabel;

  /// No description provided for @renameSongHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a new title'**
  String get renameSongHint;

  /// No description provided for @renameSongButton.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameSongButton;

  /// No description provided for @statusRenameCancelled.
  ///
  /// In en, this message translates to:
  /// **'Rename cancelled.'**
  String get statusRenameCancelled;

  /// No description provided for @statusRenameEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Song title cannot be empty.'**
  String get statusRenameEmptyTitle;

  /// No description provided for @statusRenamedSong.
  ///
  /// In en, this message translates to:
  /// **'Renamed song to \"{songTitle}\".'**
  String statusRenamedSong(Object songTitle);

  /// No description provided for @statusRenameFailed.
  ///
  /// In en, this message translates to:
  /// **'Rename failed: {errorMessage}'**
  String statusRenameFailed(Object errorMessage);

  /// No description provided for @duplicateSong.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicateSong;

  /// No description provided for @tooltipDuplicateSong.
  ///
  /// In en, this message translates to:
  /// **'Create a new saved copy of the current song'**
  String get tooltipDuplicateSong;

  /// No description provided for @duplicateSongTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Song'**
  String get duplicateSongTitle;

  /// No description provided for @duplicateSongLabel.
  ///
  /// In en, this message translates to:
  /// **'Duplicate song title'**
  String get duplicateSongLabel;

  /// No description provided for @duplicateSongHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a title for the copy'**
  String get duplicateSongHint;

  /// No description provided for @duplicateSongButton.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicateSongButton;

  /// No description provided for @duplicateTitleSuffix.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get duplicateTitleSuffix;

  /// No description provided for @statusDuplicateCancelled.
  ///
  /// In en, this message translates to:
  /// **'Duplicate cancelled.'**
  String get statusDuplicateCancelled;

  /// No description provided for @statusDuplicateEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate title cannot be empty.'**
  String get statusDuplicateEmptyTitle;

  /// No description provided for @statusDuplicatedSong.
  ///
  /// In en, this message translates to:
  /// **'Created duplicate song \"{songTitle}\".'**
  String statusDuplicatedSong(Object songTitle);

  /// No description provided for @statusDuplicateFailed.
  ///
  /// In en, this message translates to:
  /// **'Duplicate failed: {errorMessage}'**
  String statusDuplicateFailed(Object errorMessage);

  /// No description provided for @revertToSaved.
  ///
  /// In en, this message translates to:
  /// **'Revert'**
  String get revertToSaved;

  /// No description provided for @tooltipRevertToSaved.
  ///
  /// In en, this message translates to:
  /// **'Reload the last saved version of the current song'**
  String get tooltipRevertToSaved;

  /// No description provided for @revertToSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Revert to Saved'**
  String get revertToSavedTitle;

  /// No description provided for @revertToSavedBody.
  ///
  /// In en, this message translates to:
  /// **'This will discard unsaved changes and reload the last saved version of the current song.'**
  String get revertToSavedBody;

  /// No description provided for @revertToSavedButton.
  ///
  /// In en, this message translates to:
  /// **'Revert'**
  String get revertToSavedButton;

  /// No description provided for @statusNoSavedVersionToRevert.
  ///
  /// In en, this message translates to:
  /// **'No saved library version is selected to revert to.'**
  String get statusNoSavedVersionToRevert;

  /// No description provided for @statusSavedVersionMissing.
  ///
  /// In en, this message translates to:
  /// **'The saved song file no longer exists.'**
  String get statusSavedVersionMissing;

  /// No description provided for @statusRevertedToSaved.
  ///
  /// In en, this message translates to:
  /// **'Reverted to the last saved version.'**
  String get statusRevertedToSaved;

  /// No description provided for @statusRevertCancelled.
  ///
  /// In en, this message translates to:
  /// **'Revert cancelled.'**
  String get statusRevertCancelled;

  /// No description provided for @statusRevertFailed.
  ///
  /// In en, this message translates to:
  /// **'Revert failed: {errorMessage}'**
  String statusRevertFailed(Object errorMessage);

  /// No description provided for @backups.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get backups;

  /// No description provided for @tooltipBackupsFolder.
  ///
  /// In en, this message translates to:
  /// **'Open saved song backups folder'**
  String get tooltipBackupsFolder;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// No description provided for @tooltipRestoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore a saved song backup'**
  String get tooltipRestoreBackup;

  /// No description provided for @restoreBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackupTitle;

  /// No description provided for @restoreBackupConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get restoreBackupConfirmTitle;

  /// No description provided for @restoreBackupConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will load the selected backup into the editor. It will not overwrite your current saved song until you press Save.'**
  String get restoreBackupConfirmBody;

  /// No description provided for @restoreBackupButton.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreBackupButton;

  /// No description provided for @noSavedSongBackupsFound.
  ///
  /// In en, this message translates to:
  /// **'No saved song backups found.'**
  String get noSavedSongBackupsFound;

  /// No description provided for @statusBackupFileMissing.
  ///
  /// In en, this message translates to:
  /// **'The selected backup file no longer exists.'**
  String get statusBackupFileMissing;

  /// No description provided for @statusRestoreBackupCancelled.
  ///
  /// In en, this message translates to:
  /// **'Restore backup cancelled.'**
  String get statusRestoreBackupCancelled;

  /// No description provided for @statusRestoredBackup.
  ///
  /// In en, this message translates to:
  /// **'Restored backup. Review it, then use Save if you want to keep it.'**
  String get statusRestoredBackup;

  /// No description provided for @statusRestoreBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore backup failed: {errorMessage}'**
  String statusRestoreBackupFailed(Object errorMessage);
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
