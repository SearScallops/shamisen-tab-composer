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
}
