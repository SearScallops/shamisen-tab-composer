// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '三味線タブ作成 Beta 0.2.0';

  @override
  String get language => '言語';

  @override
  String get english => '英語';

  @override
  String get japanese => '日本語';

  @override
  String get systemDefault => 'システム既定';

  @override
  String get ready => '準備完了';

  @override
  String get songSettings => '曲の設定';

  @override
  String get noteInput => '音符入力';

  @override
  String get notationTools => '記譜ツール';

  @override
  String get file => 'ファイル';

  @override
  String get edit => '編集';

  @override
  String get export => '書き出し';

  @override
  String get folders => 'フォルダー';

  @override
  String get help => 'ヘルプ';

  @override
  String get status => 'ステータス';

  @override
  String get title => 'タイトル';

  @override
  String get tuning => '調弦';

  @override
  String get bpm => 'BPM';

  @override
  String get measures => '小節数';

  @override
  String get zoom => 'ズーム';

  @override
  String get tabNumber => '勘所番号';

  @override
  String get rhythm => 'リズム';

  @override
  String get technique => '奏法';

  @override
  String get repeat => '反復';

  @override
  String get newSong => '新規';

  @override
  String get save => '保存';

  @override
  String get load => '読み込み';

  @override
  String get recent => '最近';

  @override
  String get saveCopy => 'コピー保存';

  @override
  String get openFile => 'ファイルを開く';

  @override
  String get recover => '復元';

  @override
  String get clear => '消去';

  @override
  String get undo => '元に戻す';

  @override
  String get redo => 'やり直す';

  @override
  String get png => 'PNG';

  @override
  String get pdf => 'PDF';

  @override
  String get songs => '曲';

  @override
  String get exports => '書き出し';

  @override
  String get lastSave => '最後の保存';

  @override
  String get lastExport => '最後の書き出し';

  @override
  String get changes => '変更履歴';

  @override
  String get errorReport => 'エラー報告';

  @override
  String get about => '情報';

  @override
  String get write => '入力';

  @override
  String get erase => '消去';

  @override
  String get suri => '摺り';

  @override
  String get rest => '休符';

  @override
  String get lyric => '歌詞';

  @override
  String get section => '区分';

  @override
  String get unsavedChanges => '未保存の変更';

  @override
  String get saved => '保存済み';

  @override
  String get notSavedToLibrary => 'ライブラリ未保存';

  @override
  String get noLibraryFileSelected => 'ライブラリファイル未選択';

  @override
  String libraryFile(String fileName) {
    return 'ライブラリファイル: $fileName';
  }

  @override
  String stringLabel(int stringNumber) {
    return '$stringNumberの糸';
  }

  @override
  String get lyricsLabel => '歌詞';

  @override
  String get modeWrite => 'モード: 入力';

  @override
  String get modeSmartErase => 'モード: スマート消去';

  @override
  String get modeRest => 'モード: 休符';

  @override
  String get modeSimileRepeat => 'モード: 反復記号';

  @override
  String get modeLyric => 'モード: 歌詞';

  @override
  String get modeSectionLabel => 'モード: 区分ラベル';

  @override
  String get modeSuriSlide => 'モード: 摺り';

  @override
  String metadataLine(String tuning, int tempoBpm) {
    return '調弦: $tuning    テンポ: $tempoBpm BPM';
  }

  @override
  String get returnButton => '戻る';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get overwrite => '上書き';

  @override
  String get saveFirst => '先に保存';

  @override
  String get continueWithoutSaving => '保存せずに続行';

  @override
  String get recoverBackup => 'バックアップを復元';

  @override
  String get openFileLocation => '保存場所を開く';

  @override
  String get unsavedChangesTitle => '未保存の変更';

  @override
  String get overwriteSavedSongTitle => '保存済みの曲を上書きしますか？';

  @override
  String get recoverAutosaveTitle => '自動保存バックアップを復元しますか？';

  @override
  String get startNewSongTitle => '新しい曲を作成しますか？';

  @override
  String get clearCurrentSongTitle => '現在の曲を消去しますか？';

  @override
  String get loadSongTitle => '曲を読み込み';

  @override
  String get recentFilesTitle => '最近使ったファイル';

  @override
  String get noRecentFiles => '最近使ったファイルはありません。';

  @override
  String get deleteSavedSongTitle => '保存済みの曲を削除しますか？';

  @override
  String get saveCopyCompleteTitle => 'コピー保存が完了しました';

  @override
  String exportCompleteTitle(String exportType) {
    return '$exportType の書き出しが完了しました';
  }

  @override
  String savedToPath(String filePath) {
    return '保存先:\n$filePath';
  }

  @override
  String savedCopyToPath(String filePath) {
    return 'コピー保存先:\n$filePath';
  }

  @override
  String get noSavedSongsFound => '保存済みの曲がありません。';

  @override
  String modifiedDate(String modifiedDate) {
    return '更新日時: $modifiedDate';
  }

  @override
  String unsavedChangesBody(String actionName) {
    return '未保存の変更があります。$actionName の前にどうしますか？';
  }

  @override
  String overwriteSavedSongBody(String songTitle) {
    return '「$songTitle」という保存済みの曲がすでに存在します。\n\n置き換えますか？';
  }

  @override
  String get recoverAutosaveBody =>
      '現在の譜面を最新の自動保存バックアップで置き換えます。最近の未保存作業を復元したい場合のみ使用してください。';

  @override
  String get startNewSongBody => '現在の譜面を消去し、タイトル、調弦、テンポ、小節数、ズームをリセットします。';

  @override
  String get clearCurrentSongBody =>
      'すべての音符、休符、摺り、歌詞、反復記号、区分ラベルを削除します。曲の設定はそのまま残ります。';

  @override
  String deleteCurrentSongBody(String songName) {
    return '「$songName」を削除しますか？これは現在エディターで開いている曲です。\n\n譜面は開いたままになりますが、未保存の状態になります。';
  }

  @override
  String deleteSavedSongBody(String songName) {
    return '「$songName」を削除しますか？この操作は元に戻せません。';
  }

  @override
  String get removeFromRecentFiles => '最近使ったファイルから削除';

  @override
  String get tooltipWrite => '音符を入力（Ctrl + 1）';

  @override
  String get tooltipErase => 'スマート消去（Ctrl + 2）';

  @override
  String get tooltipSuri => '摺りモード（Ctrl + 3）';

  @override
  String get tooltipRest => '休符モード（Ctrl + 4）';

  @override
  String get tooltipRepeat => '反復記号モード（Ctrl + 5）';

  @override
  String get tooltipLyric => '歌詞モード（Ctrl + 6）';

  @override
  String get tooltipSection => '区分ラベルモード（Ctrl + 7）';

  @override
  String get tooltipNewSong => '新しい曲を作成';

  @override
  String get tooltipSave => '曲をローカルライブラリに保存';

  @override
  String get tooltipLoad => 'ローカルライブラリから曲を読み込み';

  @override
  String get tooltipRecent => '最近使った曲ファイルを開く';

  @override
  String get tooltipSaveCopy => '現在のライブラリファイルを変更せずにJSONコピーを保存';

  @override
  String get tooltipOpenFile => 'コンピューター上の曲ファイルを開く';

  @override
  String get tooltipRecover => '自動保存バックアップを復元';

  @override
  String get tooltipClear => '現在の譜面の記譜内容を消去';

  @override
  String get tooltipUndo => '最後の操作を元に戻す';

  @override
  String get tooltipRedo => '元に戻した操作をやり直す';

  @override
  String get tooltipExportPng => '譜面をPNG画像として書き出す';

  @override
  String get tooltipExportPdf => '譜面をPDFとして書き出す';

  @override
  String get tooltipSongsFolder => '曲ライブラリフォルダーを開く';

  @override
  String get tooltipExportsFolder => '書き出しフォルダーを開く';

  @override
  String get tooltipLastSave => '最後に保存した曲ファイルを表示';

  @override
  String get tooltipLastExport => '最後に書き出したファイルを表示';

  @override
  String get tooltipHelp => 'ヘルプ / 使い方';

  @override
  String get tooltipChanges => '変更履歴';

  @override
  String get tooltipErrorReport => 'ローカルエラーログを書き出す';

  @override
  String get tooltipAbout => 'アプリ情報';

  @override
  String get tooltipZoomOut => 'ズームアウト';

  @override
  String get tooltipZoomIn => 'ズームイン';

  @override
  String get statusLanguageSystem => '言語をシステム既定に設定しました。';

  @override
  String get statusLanguageJapanese => '言語を日本語に設定しました。';

  @override
  String get statusLanguageEnglish => '言語を英語に設定しました。';

  @override
  String get statusUpdatedTitle => '曲名を更新しました。';

  @override
  String statusSelectedTuning(String tuning) {
    return '調弦を選択しました: $tuning。';
  }

  @override
  String get statusTempoPositiveNumber => 'テンポは正の数で入力してください。';

  @override
  String statusUpdatedTempo(int tempoBpm) {
    return 'テンポを $tempoBpm BPM に更新しました。';
  }

  @override
  String statusSetMeasures(int measureCount) {
    return '曲の長さを $measureCount 小節に設定しました。';
  }

  @override
  String statusSetMeasuresRemovedItems(int measureCount, int removedCount) {
    return '曲の長さを $measureCount 小節に設定しました。範囲外の項目を $removedCount 件削除しました。';
  }

  @override
  String get statusResetZoom => 'ズームを100%に戻しました。';

  @override
  String statusSetZoom(int zoomPercent) {
    return 'ズームを $zoomPercent% に設定しました。';
  }

  @override
  String get statusMinimumZoom => 'すでに最小ズームです。';

  @override
  String get statusMaximumZoom => 'すでに最大ズームです。';

  @override
  String statusSelectedTabNumber(String tabNumber) {
    return '勘所番号 $tabNumber を選択しました。';
  }

  @override
  String statusSelectedRhythm(String rhythm, int slotCount) {
    return '$rhythm リズムを選択しました: $slotCount スロット。';
  }

  @override
  String statusSelectedTechnique(String technique) {
    return '奏法を選択しました: $technique。';
  }

  @override
  String statusSelectedRepeat(String repeatName) {
    return '$repeatName の反復を選択しました。';
  }

  @override
  String get oneMeasure => '1小節';

  @override
  String get twoMeasure => '2小節';

  @override
  String get statusNothingToUndo => '元に戻す操作はありません。';

  @override
  String get statusUndidLastAction => '最後の操作を元に戻しました。';

  @override
  String get statusNothingToRedo => 'やり直す操作はありません。';

  @override
  String get statusRedidLastAction => '操作をやり直しました。';

  @override
  String get statusClearedSelection => '選択を解除しました。';

  @override
  String get statusStartedNewSong => '新しい曲を開始しました。';

  @override
  String get statusClearedSong => '曲を消去しました。';

  @override
  String statusSavedSong(String songTitle) {
    return '「$songTitle」を保存しました。';
  }

  @override
  String statusSaveCancelledOverwrite(String songTitle) {
    return '「$songTitle」の上書きを避けるため、保存をキャンセルしました。';
  }

  @override
  String statusSaveFailed(String errorMessage) {
    return '保存に失敗しました: $errorMessage';
  }

  @override
  String statusLoadedSong(String songTitle) {
    return '「$songTitle」を読み込みました。';
  }

  @override
  String statusLoadFailed(String errorMessage) {
    return '読み込みに失敗しました: $errorMessage';
  }

  @override
  String get statusSaveCopyCancelled => 'コピー保存をキャンセルしました。';

  @override
  String get statusSaveCopySuccess => '曲のコピーを保存しました。現在のライブラリファイルは変更されていません。';

  @override
  String statusSaveCopyFailed(String errorMessage) {
    return 'コピー保存に失敗しました: $errorMessage';
  }

  @override
  String get statusOpenFileCancelled => 'ファイルを開く操作をキャンセルしました。';

  @override
  String get statusOpenFileMissing => 'ファイルを開けませんでした: 選択したファイルが存在しません。';

  @override
  String get statusOpenFileSuccess => '曲ファイルを開きました。ライブラリに追加するには保存してください。';

  @override
  String statusOpenFileFailed(String errorMessage) {
    return 'ファイルを開けませんでした: $errorMessage';
  }

  @override
  String get zoomOutButton => 'ズーム -';

  @override
  String get zoomInButton => 'ズーム +';

  @override
  String get deleteSavedSongTooltip => '保存済みの曲を削除';

  @override
  String get lyricDialogTitle => '歌詞';

  @override
  String get lyricTextLabel => '歌詞テキスト';

  @override
  String get lyricTextHint => '例: sakura / さくら / 桜';

  @override
  String sectionDialogTitle(int measureNumber) {
    return '$measureNumber小節目の区分ラベル';
  }

  @override
  String get sectionLabelText => '区分ラベル';

  @override
  String get sectionLabelHint => '例: Intro / Verse / Chorus';

  @override
  String get statusClickInsideMeasureArea => '曲の小節範囲内をクリックしてください。';

  @override
  String get statusPlaceNoteOrRestBeforeLyric =>
      '先に音符または休符を置いてから、その下に歌詞を追加してください。';

  @override
  String get statusNoLyricAdded => '歌詞は追加されませんでした。';

  @override
  String get statusDeletedLyric => '歌詞を削除しました。';

  @override
  String get statusUpdatedLyric => '歌詞を更新しました。';

  @override
  String get statusAddedLyric => '音符/休符の下に歌詞を追加しました。';

  @override
  String get statusNoSectionLabelAdded => '区分ラベルは追加されませんでした。';

  @override
  String get statusDeletedSectionLabel => '区分ラベルを削除しました。';

  @override
  String get statusUpdatedSectionLabel => '区分ラベルを更新しました。';

  @override
  String get statusAddedSectionLabel => '区分ラベルを追加しました。';

  @override
  String get statusAutosaveFound =>
      '自動保存バックアップがあります。必要な場合は自動保存バックアップを復元してください。';

  @override
  String statusAutosaveFailed(Object errorMessage) {
    return '自動保存に失敗しました: $errorMessage';
  }

  @override
  String get statusNoAutosaveBackup => '自動保存バックアップが見つかりません。';

  @override
  String get statusRecoveredAutosave =>
      '自動保存バックアップを復元しました。通常の曲として保存するには保存してください。';

  @override
  String statusAutosaveRecoveryFailed(Object errorMessage) {
    return '自動保存バックアップの復元に失敗しました: $errorMessage';
  }

  @override
  String get statusExportingPng => 'PNGを書き出し中...';

  @override
  String get statusExportingPdf => 'PDFを書き出し中...';

  @override
  String get statusPngExportSuccess => 'PNGの書き出しが完了しました。';

  @override
  String get statusPdfExportSuccess => 'PDFの書き出しが完了しました。';

  @override
  String statusPngExportFailed(Object errorMessage) {
    return 'PNGの書き出しに失敗しました: $errorMessage';
  }

  @override
  String statusPdfExportFailed(Object errorMessage) {
    return 'PDFの書き出しに失敗しました: $errorMessage';
  }

  @override
  String get statusToolWrite => '入力モード。';

  @override
  String get statusToolErase => '消去モード: 音符、休符、歌詞、摺り、反復記号、区分ラベルをクリックして消去します。';

  @override
  String get statusToolSuri => '摺りモード: 開始音をクリックしてから終了音をクリックします。';

  @override
  String get statusToolRest => '休符モード: 糸の線をクリックして休符を置きます。';

  @override
  String get statusToolRepeat => '反復記号モード: 小節をクリックして反復記号を切り替えます。';

  @override
  String get statusToolLyric => '歌詞モード: 音符/休符のタイミングをクリックして歌詞を追加または編集します。';

  @override
  String get statusToolSection => '区分モード: 小節をクリックしてラベルを追加または編集します。';

  @override
  String statusDeletedCurrentSongFile(Object songName) {
    return '「$songName」を削除しました。現在の譜面は開いたままですが、未保存の状態になりました。';
  }

  @override
  String statusDeletedSavedSongFile(Object songName) {
    return '保存済みの曲「$songName」を削除しました。';
  }

  @override
  String statusDeleteFailed(Object errorMessage) {
    return '削除に失敗しました: $errorMessage';
  }

  @override
  String get statusRecentFileMissing => '最近使ったファイルが存在しません。リストから削除しました。';

  @override
  String get statusLoadFileMissing => '読み込みに失敗しました: 選択した曲ファイルが存在しません。';

  @override
  String get statusLoadNewerFileFormat =>
      '読み込みに失敗しました: この曲ファイルは新しいファイル形式を使用しています。アプリを更新してください。';

  @override
  String statusSelectedNote(Object stringNumber, Object tabNumber) {
    return '勘所 $tabNumber を $stringNumber の糸で選択しました。';
  }

  @override
  String get statusUpdatedSelectedNote => '選択中の音符を更新しました。';

  @override
  String get statusSelectedNoteOverlapRepeat =>
      '選択中の音符を更新できません: リズムが反復記号の小節と重なっています。';

  @override
  String get statusSelectedNoteOverlapNote =>
      '選択中の音符を更新できません: リズムが別の音符と重なっています。';

  @override
  String get statusSelectedNoteOverlapRest => '選択中の音符を更新できません: リズムが休符と重なっています。';

  @override
  String get statusCannotPlaceNoteRepeat => '音符を置けません: この小節には反復記号があります。';

  @override
  String get statusCannotPlaceNoteRest => '音符を置けません: リズムが休符と重なっています。';

  @override
  String get statusCannotPlaceNoteNote => '音符を置けません: リズムが別の音符と重なっています。';

  @override
  String statusPlacedSelectedNote(Object rhythm) {
    return '$rhythm の音符を置いて選択しました。';
  }

  @override
  String get statusCannotPlaceRestRepeat => '休符を置けません: この小節には反復記号があります。';

  @override
  String get statusRemovedRestAndLyric => '休符と付属する歌詞を削除しました。';

  @override
  String get statusCannotPlaceRestNote => '休符を置けません: 音符と重なっています。';

  @override
  String get statusCannotPlaceRestRest => '休符を置けません: 別の休符と重なっています。';

  @override
  String statusPlacedRest(Object rhythm) {
    return '$rhythm の休符を置きました。';
  }

  @override
  String get statusSuriClickExistingNote => '摺りモード: 既存の音符をクリックしてください。';

  @override
  String get statusSuriStartSelected => '摺りの開始音を選択しました。終了音をクリックしてください。';

  @override
  String get statusSuriSameString => '摺りは同じ糸の音符同士を接続する必要があります。';

  @override
  String get statusSuriNeedsTwoNotes => '摺りには異なる2つの音符が必要です。';

  @override
  String get statusRemovedSuriSlide => '摺りを削除しました。';

  @override
  String get statusAddedSuriSlide => '摺りを追加しました。';

  @override
  String statusRemovedRepeat(Object repeatLength) {
    return '$repeatLength小節の反復記号を削除しました。';
  }

  @override
  String get statusOneMeasureRepeatCannotBeFirst => '1小節の反復記号は1小節目には置けません。';

  @override
  String get statusTwoMeasureRepeatNeedsPreviousMeasures =>
      '2小節の反復記号には、前に2小節分の内容が必要です。';

  @override
  String statusNotEnoughSpaceForRepeat(Object repeatLength) {
    return 'ここには$repeatLength小節の反復記号を置く十分なスペースがありません。';
  }

  @override
  String get statusCannotPlaceRepeatOverNotesOrRests =>
      '反復記号を置けません: 選択した小節範囲にはすでに音符または休符があります。';

  @override
  String get statusCannotPlaceRepeatOverRepeat => '反復記号を置けません: 別の反復記号と重なっています。';

  @override
  String statusAddedOneMeasureRepeat(Object measureNumber) {
    return '$measureNumber小節目に1小節の反復記号を追加しました。';
  }

  @override
  String statusAddedTwoMeasureRepeat(Object endMeasure, Object startMeasure) {
    return '$startMeasure小節目から$endMeasure小節目まで2小節の反復記号を追加しました。';
  }

  @override
  String get statusNoSelectedNoteToDelete => '削除する選択中の音符がありません。';

  @override
  String get statusSelectedNoteMissing => '選択中の音符はもう存在しません。';

  @override
  String get statusDeletedSelectedNote => '選択中の音符を削除しました。';

  @override
  String get statusDeletedNoteRelatedItems => '音符、関連する摺り、付属する歌詞を削除しました。';

  @override
  String get statusDeletedRestAndLyric => '休符と付属する歌詞を削除しました。';

  @override
  String get statusNoNoteOrRestToErase => 'ここには消去できる音符または休符がありません。';

  @override
  String statusDeletedRepeatFromMeasure(Object measureNumber) {
    return '$measureNumber小節目の反復記号を削除しました。';
  }

  @override
  String get statusNothingToErase => 'ここには消去できるものがありません。';

  @override
  String get aboutDialogTitle => 'Shamisen Tab Composer について';

  @override
  String get aboutDialogBody =>
      'Shamisen Tab Composer Beta 0.2.0\n\n三味線のタブ譜を作成、保存、読み込み、書き出しできるデスクトップ用エディターです。\n\n現在のベータ機能:\n- 音符入力\n- 休符\n- 摺り記号\n- 音符/休符の下への歌詞入力\n- 区分ラベル\n- 反復記号\n- 曲ライブラリの保存/読み込み\n- コピー保存と外部ファイル読み込み\n- PNG/PDF書き出し\n- 元に戻す/やり直し\n- キーボードショートカット\n- 自動保存バックアップと復元\n\nベータ版について:\nこのバージョンは公開テスト向けです。安定版1.0までに、ファイル形式、レイアウト、書き出し動作が変更される可能性があります。';

  @override
  String get helpDialogTitle => 'Shamisen Tab Composer の使い方';

  @override
  String get helpDialogBody =>
      '基本の流れ\n1. 勘所番号、リズム、奏法を選びます。\n2. 糸の線を直接クリックして勘所番号を置きます。\n3. 入力モードで既存の音符をクリックすると、選択して編集できます。\n4. 保存を使うと、曲をローカルの曲ライブラリに保存できます。\n5. 読み込みを使うと、ローカルの曲ライブラリから曲を開けます。\n6. コピー保存を使うと、JSONコピーを任意の場所に保存できます。\n7. ファイルを開くを使うと、コンピューター上の任意の曲ファイルを開けます。\n\nツール\n8. PNGまたはPDF書き出しを使うと、現在の譜面を共有または印刷できます。\n\n自動保存の復元\n作業中、アプリはローカルに自動保存バックアップを作成します。\nアプリが予期せず閉じた場合や、最近の作業を復元したい場合は、自動保存バックアップの復元を使ってください。\n\n入力: 音符を置く、または既存の音符を選択します。\n消去: 音符、休符、歌詞、摺り、反復記号、区分ラベルを消去します。\n摺り: 同じ糸の2つの音符をクリックして摺り記号を追加または削除します。\n休符: 糸の線をクリックしてリズム休符を置きます。\n反復記号: 小節をクリックして反復記号を追加または削除します。\n歌詞: 音符/休符のタイミングをクリックして、その下に歌詞を追加します。\n区分: 小節をクリックして Intro、Verse、Chorus などのラベルを追加します。\n\n曲設定\nタイトル: 譜面タイトルと保存ファイル名に使われます。\n調弦: 本調子、二上り、三下りから選べます。\nBPM: テンポを設定します。\n小節数: 曲の長さを設定します。\nズーム: 横方向の間隔を調整します。\n反復: 1小節または2小節の反復記号を選べます。\n\n重要な注意\n歌詞は既存の音符または休符の下にのみ追加できます。\n摺りは同じ糸の2つの音符を接続する必要があります。\n反復記号は、すでに音符や休符がある小節には置けません。\n新規作成はすべてをリセットします。\nクリアは譜面上の記譜を消しますが、すべての曲設定をリセットするわけではありません。';

  @override
  String get changelogDialogTitle => 'バージョン履歴';

  @override
  String get changelogDialogBody =>
      'Shamisen Tab Composer Beta 0.2.0\n\nコアとなるタブ譜エディターをテストするための、最初の公開ベータ候補です。\n\n含まれる機能:\n- 三味線タブ音符入力\n- 三本糸の譜面レイアウト\n- リズム対応: 全音符、二分音符、四分音符、八分音符、十六分音符\n- 勘所番号の選択\n- 三味線調弦メタデータ\n- BPMメタデータ\n- 小節数コントロール\n- 横方向ズーム\n- 左手奏法記号\n- 右手奏法記号\n- 押し撥と滑りの上部記号\n- 摺り記号\n- 休符入力\n- 音符/休符の下への歌詞入力\n- 区分ラベル\n- 1小節の反復記号\n- 2小節の反復記号\n- スマート消去モード\n- 選択音符の編集\n- 元に戻す/やり直し\n- ローカル曲ファイルの保存と読み込み\n- 読み込み画面から保存済み曲を削除\n- コピー保存対応\n- 外部ファイル読み込み対応\n- PNG書き出し\n- PDF書き出し\n- 曲ライブラリフォルダーを開く\n- 書き出しフォルダーを開く\n- 最後に保存した曲ファイルを表示\n- 最後に書き出したファイルを表示\n- キーボードショートカット\n- ヘルプダイアログ\n- アプリ情報ダイアログ\n- 自動保存バックアップ\n- 自動保存復元ボタン\n- 未保存変更ステータス\n\n既知のベータ制限:\n- 現在の主なテスト対象はWindowsデスクトップです。\n- 長い曲では書き出しレイアウトの改善が必要になる可能性があります。\n- PDF書き出しは現在、表示中の譜面を画像としてページに配置します。\n- モバイル用レイアウトはまだ準備できていません。\n- 安定版までに保存ファイル形式が変更される可能性があります。\n- さらに多くの三味線記号を追加する予定です。\n\n次の予定バージョン: Beta 0.3\n\n予定している改善:\n- より整理されたツールバー\n- より良い書き出し譜面レイアウト\n- 追加の記譜記号\n- サンプル曲ファイル\n- 初心者向け説明の改善\n- テストフィードバック対応の改善';

  @override
  String get sampleSong => 'サンプル曲';

  @override
  String get tooltipSampleSong => 'テスト用の内蔵サンプル曲を読み込みます';

  @override
  String get loadSampleSongTitle => 'サンプル曲を読み込む';

  @override
  String get loadSampleSongBody =>
      '現在の譜面を内蔵サンプル曲に置き換えます。残したい未保存の変更がある場合は、先に保存してください。';

  @override
  String get loadSampleSongButton => 'サンプルを読み込む';

  @override
  String get sampleSongTitle => '三味線サンプル曲';

  @override
  String get statusLoadedSampleSong => 'サンプル曲を読み込みました。曲ライブラリに残すには保存してください。';

  @override
  String get keyboardShortcuts => 'ショートカット';

  @override
  String get tooltipKeyboardShortcuts => 'キーボードショートカットを表示';

  @override
  String get keyboardShortcutsDialogTitle => 'キーボードショートカット';

  @override
  String get keyboardShortcutsDialogBody =>
      'ファイルと書き出し\nCtrl+S: 保存\nCtrl+N: 新規作成\nCtrl+O: 読み込み\nCtrl+P: PDF書き出し\nCtrl+Shift+P: PNG書き出し\n\n編集\nCtrl+Z: 元に戻す\nCtrl+Y: やり直し\nDelete: 選択中の音符を削除\nEsc: 現在の選択を解除\n\nツール\nCtrl+1: 入力モード\nCtrl+2: 消去モード\nCtrl+3: 摺りモード\nCtrl+4: 休符モード\nCtrl+5: 反復記号モード\nCtrl+6: 歌詞モード\nCtrl+7: 区分モード';

  @override
  String get resetView => '表示をリセット';

  @override
  String get tooltipResetView => 'ズームを100%に戻し、譜面の先頭に戻ります';

  @override
  String get statusResetView => '表示を100%ズームに戻し、譜面の先頭に戻りました。';

  @override
  String get clearRecentFiles => '履歴をクリア';

  @override
  String get clearRecentFilesTitle => '最近使ったファイルをクリア';

  @override
  String get clearRecentFilesBody => '最近使ったファイルの一覧をすべて削除します。曲ファイル自体は削除されません。';

  @override
  String get statusClearedRecentFiles => '最近使ったファイルの一覧をクリアしました。';

  @override
  String get statusNoRecentFilesToClear => 'クリアする最近使ったファイルはありません。';

  @override
  String get jumpToMeasure => '移動';

  @override
  String get tooltipJumpToMeasure => '指定した小節へ移動';

  @override
  String get jumpToMeasureTitle => '小節へ移動';

  @override
  String get jumpToMeasureLabel => '小節番号';

  @override
  String get jumpToMeasureHint => '小節番号を入力';

  @override
  String get jumpToMeasureButton => '移動';

  @override
  String statusJumpedToMeasure(Object measureNumber) {
    return '$measureNumber小節目へ移動しました。';
  }

  @override
  String statusInvalidMeasureNumber(Object totalMeasures) {
    return '1から$totalMeasuresまでの小節番号を入力してください。';
  }

  @override
  String get renameSong => '名前変更';

  @override
  String get tooltipRenameSong => '現在の曲名と保存ファイル名を変更します';

  @override
  String get renameSongTitle => '曲名を変更';

  @override
  String get renameSongLabel => '新しい曲名';

  @override
  String get renameSongHint => '新しい曲名を入力';

  @override
  String get renameSongButton => '名前変更';

  @override
  String get statusRenameCancelled => '名前変更をキャンセルしました。';

  @override
  String get statusRenameEmptyTitle => '曲名を空にすることはできません。';

  @override
  String statusRenamedSong(Object songTitle) {
    return '曲名を「$songTitle」に変更しました。';
  }

  @override
  String statusRenameFailed(Object errorMessage) {
    return '名前変更に失敗しました: $errorMessage';
  }

  @override
  String get duplicateSong => '複製';

  @override
  String get tooltipDuplicateSong => '現在の曲の新しい保存コピーを作成します';

  @override
  String get duplicateSongTitle => '曲を複製';

  @override
  String get duplicateSongLabel => '複製する曲名';

  @override
  String get duplicateSongHint => 'コピー用の曲名を入力';

  @override
  String get duplicateSongButton => '複製';

  @override
  String get duplicateTitleSuffix => 'コピー';

  @override
  String get statusDuplicateCancelled => '複製をキャンセルしました。';

  @override
  String get statusDuplicateEmptyTitle => '複製する曲名を空にすることはできません。';

  @override
  String statusDuplicatedSong(Object songTitle) {
    return '複製曲「$songTitle」を作成しました。';
  }

  @override
  String statusDuplicateFailed(Object errorMessage) {
    return '複製に失敗しました: $errorMessage';
  }

  @override
  String get revertToSaved => '保存版に戻す';

  @override
  String get tooltipRevertToSaved => '現在の曲を最後に保存した状態に戻します';

  @override
  String get revertToSavedTitle => '保存版に戻す';

  @override
  String get revertToSavedBody => '未保存の変更を破棄し、現在の曲を最後に保存した状態で再読み込みします。';

  @override
  String get revertToSavedButton => '戻す';

  @override
  String get statusNoSavedVersionToRevert => '戻す対象の保存済みライブラリ曲が選択されていません。';

  @override
  String get statusSavedVersionMissing => '保存済みの曲ファイルが存在しません。';

  @override
  String get statusRevertedToSaved => '最後に保存した状態に戻しました。';

  @override
  String get statusRevertCancelled => '保存版に戻す操作をキャンセルしました。';

  @override
  String statusRevertFailed(Object errorMessage) {
    return '保存版への復元に失敗しました: $errorMessage';
  }

  @override
  String get backups => 'バックアップ';

  @override
  String get tooltipBackupsFolder => '保存曲のバックアップフォルダーを開きます';

  @override
  String get restoreBackup => 'バックアップ復元';

  @override
  String get tooltipRestoreBackup => '保存曲のバックアップを復元します';

  @override
  String get restoreBackupTitle => 'バックアップを復元';

  @override
  String get restoreBackupConfirmTitle => 'このバックアップを復元しますか？';

  @override
  String get restoreBackupConfirmBody =>
      '選択したバックアップをエディターに読み込みます。保存を押すまで現在の保存曲は上書きされません。';

  @override
  String get restoreBackupButton => '復元';

  @override
  String get noSavedSongBackupsFound => '保存曲のバックアップが見つかりません。';

  @override
  String get statusBackupFileMissing => '選択したバックアップファイルが存在しません。';

  @override
  String get statusRestoreBackupCancelled => 'バックアップ復元をキャンセルしました。';

  @override
  String get statusRestoredBackup => 'バックアップを復元しました。内容を確認し、残す場合は保存してください。';

  @override
  String statusRestoreBackupFailed(Object errorMessage) {
    return 'バックアップ復元に失敗しました: $errorMessage';
  }
}
