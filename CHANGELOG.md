# Change Log

## [1.0.10] - 2026-08-20

### Fixed

- [Issue 36](https://github.com/fexend/fexend-theme/issues/36) - Fixed the Peek References / Peek Definition widget rendering with VS Code's default near-black background and orange match highlights in Medium Purple, Medium Purple Italic, Soft Dark, and Soft Dark Italic. Those four variants defined no `peekView*` colors at all, so the whole widget fell back to the built-in dark defaults. Added the full peek view color set (editor, gutter, sticky scroll, result list, title bar, match highlights) mapped to each theme's own surfaces and accent.

## [1.0.9] - 2026-08-12

### Fixed

- [Issue 34](https://github.com/fexend/fexend-theme/issues/34) - Fixed unreadable dropdown text in the Settings editor across all 6 theme variants: `dropdown.foreground` was a 12%-opacity accent color (invisible), and `dropdown.background`/`dropdown.listBackground` were translucent so content behind the open option list bled through. Both are now opaque surfaces with high-contrast foregrounds.

## [1.0.8] - 2026-04-25

### Fixed

- [Issue 31](https://github.com/fexend/fexend-theme/issues/31) - Fixed invisible input validation messages (error/warning/info) in the file explorer across all 6 theme variants by using dark tinted backgrounds with contrasting light foregrounds

## [1.0.7] - 2026-03-29

### Fixed

- [Issue 29](https://github.com/fexend/fexend-theme/issues/29) - Synced color schema between Soft Dark and Soft Dark Italic, and between Medium Purple and Medium Purple Italic by adding missing token entries (Storage Types, Operators, CSS Selectors, CSS Properties, JSON Keys, YAML Keys, YAML Values, Punctuation) to the non-italic variants

## [1.0.6] - 2026-03-20

### Added

- [Issue 27](https://github.com/fexend/fexend-theme/issues/27) - Fexend Theme Soft Dark Italic variant with italic font styles for strings, variables, keywords, functions, and classes
- [Issue 27](https://github.com/fexend/fexend-theme/issues/27) - Fexend Theme Medium Purple Italic variant with italic font styles for strings, variables, keywords, functions, and classes

## [1.0.0] - 2025-07-30

### Added

- Initial release of Fexend Theme
- Dark theme with Tailwind CSS inspired colors
- Support for syntax highlighting across multiple languages

## [1.0.1] - 2025-07-30

### Fixed

- [Issue 1](https://github.com/fexend/fexend-theme/issues/1)
- [Issue 3](https://github.com/fexend/fexend-theme/issues/3)

## [1.0.2] - 2025-08-04

### Fixed

- [Issue 5](https://github.com/fexend/fexend-theme/issues/5)
- [Issue 7](https://github.com/fexend/fexend-theme/issues/7)

### New feature

- [Issue 6](https://github.com/fexend/fexend-theme/issues/6)

## [1.0.4] - 2026-03-14

### Added

- [Issue 2](https://github.com/fexend/fexend-theme/issues/2) - Soft Dark theme variant with softer slate backgrounds

### Fixed

- [Issue 14](https://github.com/fexend/fexend-theme/issues/14)

## [1.0.5] - 2026-03-15

### Added

- [Issue 20](https://github.com/fexend/fexend-theme/issues/20) - Comprehensive Markdown syntax highlighting to all themes

### Fixed

- [Issue 16](https://github.com/fexend/fexend-theme/issues/16) - Missing popup/widget color sections in Medium Purple and Soft Dark themes
- [Issue 19](https://github.com/fexend/fexend-theme/issues/19) - Missing menu color definitions in Medium Purple and Soft Dark themes
