# Shamisen Tab Composer

**Shamisen Tab Composer** is a desktop tablature editor for creating, saving, loading, and exporting shamisen tab sheets.

Current version: **Beta 0.2.0**

This app is currently focused on Windows desktop testing.

## Features

- Three-string shamisen tablature layout
- Tab number input
- Rhythm support:
  - Whole
  - Half
  - Quarter
  - Eighth
  - Sixteenth
- Shamisen tuning metadata:
  - Honchoshi (本調子)
  - Niagari (二上り)
  - Sansagari (三下り)
- BPM metadata
- Measure count control
- Horizontal zoom control
- Zoom in / zoom out controls
- Left-hand and right-hand technique markings
- Oshibachi and Suberi above-note markings
- Suri slide markings
- Rest input
- Lyric input under notes and rests
- Section labels
- One-measure simile repeat marks
- Two-measure simile repeat marks
- Smart erase mode
- Selected-note editing
- Undo and redo
- Save and load local song files
- Recent files list
- Save Copy support
- Open File support
- PNG export
- PDF export
- Autosave backup
- Autosave recovery
- Local error logging
- Export Error Report button
- Keyboard shortcuts
- Help, About, and Version History dialogs

## Current Beta Status

This is a public beta version intended for testing the core editor workflow.

The app is usable for personal shamisen tab writing, practice-sheet creation, and early community testing. However, file format, notation layout, and export behavior may still change before a stable 1.0 release.

## Known Limitations

- Windows desktop is the main supported platform right now.
- Mobile layout is not ready.
- PDF export currently captures the visual sheet and places it into a printable page.
- Very long songs may shrink when exported to one PDF page.
- Multi-page PDF layout is not implemented yet.
- More shamisen notation symbols still need to be added.
- Japanese UI localization is planned but not implemented yet.

## Planned Improvements

- Japanese language support
- Cleaner toolbar organization
- Better multi-page PDF export
- More notation symbols
- Sample song files
- More beginner-friendly instructions
- Better printed practice-sheet layout

## Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| Ctrl + S | Save |
| Ctrl + O | Load |
| Ctrl + N | New Song |
| Ctrl + Z | Undo |
| Ctrl + Y | Redo |
| Ctrl + P | Export PDF |
| Ctrl + Shift + P | Export PNG |
| Ctrl + 1 | Write mode |
| Ctrl + 2 | Erase mode |
| Ctrl + 3 | Suri mode |
| Ctrl + 4 | Rest mode |
| Ctrl + 5 | Repeat mode |
| Ctrl + 6 | Lyric mode |
| Ctrl + 7 | Section mode |
| Delete | Delete selected note |
| Escape | Clear selection |

## Save Behavior

- **Save** stores the current song in the app’s local song library.
- **Load** opens songs from the local song library.
- **Save Copy** exports a JSON copy anywhere on the computer without changing the active library file.
- **Open File** opens a JSON song file from anywhere on the computer.
- **Recent** opens recently used song files.

## Export Behavior

- **PNG** exports the current sheet as an image.
- **PDF** exports the current sheet onto a printable landscape page.

## Version

Beta 0.2.0