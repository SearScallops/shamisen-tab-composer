# Windows Installation Guide

This guide explains how to download and run Shamisen Tab Composer on Windows.

## Current Version

Shamisen Tab Composer Alpha 0.1

## Requirements

- Windows 10 or Windows 11
- A downloaded release zip file from the GitHub Releases page

## How to Install

1. Go to the GitHub Releases page.
2. Download the latest Windows zip file.
3. Right-click the zip file and choose **Extract All**.
4. Open the extracted folder.
5. Run the `.exe` file inside the folder.

## Important

Do not move only the `.exe` file by itself.

The app needs the full extracted folder because it depends on the included `.dll` files and the `data` folder.

Correct:

Shamisen Tab Composer Alpha 0.1 Windows/
├── shamisen_tab_app.exe
├── flutter_windows.dll
├── data/
└── other required files

Wrong:

Desktop/
└── shamisen_tab_app.exe

## Windows Security Warning

Windows may show a warning because this alpha build is not code-signed yet.

Choose:

1. **More info**
2. **Run anyway**

Only do this if you downloaded the app from the official GitHub Releases page.

## Where Songs Are Saved

Saved songs are stored locally in your Documents folder:

`Documents/ShamisenTabComposer`

Exports are stored in:

`Documents/ShamisenTabComposer/Exports`

## Reporting Bugs

Please report bugs through GitHub Issues using the Bug Report template.