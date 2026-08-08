## 2.0.0

* **Major Release (v2.0.0)** featuring a comprehensive suite of new components, hover animations, and floating navigation bars.
* Added `VasxSideMenu` — animated mouse-hover collapsible side navigation menu with badge tags and collapsible nested submenus.
* Added `VasxMobileBottomNavBar` — floating capsule mobile bottom navigation bar with active item capsule pill expansion.
* Added `VasxAlert` & `showVasxAlertToast` — success, warning, error, and info alert banners + smooth top-right animated toast (2s auto-hide).
* Added `VasxPaymentConfirmationDialog` — billing & checkout dialog with summary breakdown, editable payment input, and slide-to-pay button.
* Added `VasxAiSearchBar` — AI assistant capsule search bar with gradient header badge and attachment popup overlay.
* Added `VasxSearchBar` — modern action toolbar search input with clear button.
* Added `VasxButton` — primary, outlined, and secondary action buttons with sizes and loading states.
* Added `VasxToggle` & `VasxCheckbox` — animated custom toggle switch and rounded square checkmark box.
* Added `VasxFormCard` — modern card form container with header badge, prefix icon fields, obscure password toggle, and submit button.
* Added `CrmCalendar` & `CrmStatsDashboard` — CRM event schedule grid and analytics metrics dashboard with `fl_chart` integration.
* Resolved `RenderFlex` edge overflow in collapsed side menu mode with `ClipRect` + scroll calculation bounds.
* Expanded automated test suite to 33 passing unit and widget tests.

## 0.0.1

* Initial release of vasX UI.
* Added `AppPopupMenu` and `AppPopupMenuItem` — animated scale+fade popup action menu.
* Added `CustomTable` and `CustomTableColumn` — responsive, horizontally-scrollable data table.
* Added `VerticalWizardShell` and `WizardStepConfig` — multi-step wizard with a vertical left stepper; responsive mobile layout with horizontal progress bar.
* Added `ScrollableWizardShell` — all-sections-visible scrollable form wizard with scroll-position-aware sidebar.
* Added `SearchableDropdown` — single-select overlay dropdown with live search field.
* Added `MultiSelectSearchableDropdown` — multi-select overlay dropdown with chip display and live search.
* Added `CreatableDropdown` — overlay dropdown with inline "Add new item" section.
* Added `DropdownDatePicker` — three-dropdown (Year / Month / Day) date picker with controller binding and dynamic leap-year day clamping.
* Added `CustomDateRangePickerDialog` and `showCustomDateRangePicker` helper — dual-calendar date range picker dialog; responsive mobile (stacked) and desktop (side-by-side) layouts.
* Added `VasxColors` — WCAG AA-compliant color token system.
