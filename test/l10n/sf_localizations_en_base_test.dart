import 'package:adair_flutter_lib/l10n/sf_localizations_en_base.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestSfLocalizations extends SfLocalizationsEnBase {
  const _TestSfLocalizations();

  @override
  String get noEventsCalendarLabel => "No events";
}

void main() {
  const localizations = _TestSfLocalizations();

  test(
    "SfLocalizationsEnBase provides Syncfusion's default English values",
    () {
      expect(localizations.noSelectedDateCalendarLabel, "No selected date");
      expect(localizations.daySpanCountLabel, "Day");
      expect(localizations.allowedViewDayLabel, "Day");
      expect(localizations.allowedViewWeekLabel, "Week");
      expect(localizations.allowedViewWorkWeekLabel, "Work Week");
      expect(localizations.allowedViewMonthLabel, "Month");
      expect(localizations.allowedViewScheduleLabel, "Schedule");
      expect(localizations.allowedViewTimelineDayLabel, "Timeline Day");
      expect(localizations.allowedViewTimelineWeekLabel, "Timeline Week");
      expect(
        localizations.allowedViewTimelineWorkWeekLabel,
        "Timeline Work Week",
      );
      expect(localizations.allowedViewTimelineMonthLabel, "Timeline Month");
      expect(localizations.todayLabel, "Today");
      expect(localizations.weeknumberLabel, "Week");
      expect(localizations.allDayLabel, "All Day");
      expect(localizations.muharramLabel, "Muharram");
      expect(localizations.safarLabel, "Safar");
      expect(localizations.rabi1Label, "Rabi' al-awwal");
      expect(localizations.rabi2Label, "Rabi' al-thani");
      expect(localizations.jumada1Label, "Jumada al-awwal");
      expect(localizations.jumada2Label, "Jumada al-thani");
      expect(localizations.rajabLabel, "Rajab");
      expect(localizations.shaabanLabel, "Sha'aban");
      expect(localizations.ramadanLabel, "Ramadan");
      expect(localizations.shawwalLabel, "Shawwal");
      expect(localizations.dhualqiLabel, "Dhu al-Qi'dah");
      expect(localizations.dhualhiLabel, "Dhu al-Hijjah");
      expect(localizations.shortMuharramLabel, "Muh.");
      expect(localizations.shortSafarLabel, "Saf.");
      expect(localizations.shortRabi1Label, "Rabi. I");
      expect(localizations.shortRabi2Label, "Rabi. II");
      expect(localizations.shortJumada1Label, "Jum. I");
      expect(localizations.shortJumada2Label, "Jum. II");
      expect(localizations.shortRajabLabel, "Raj.");
      expect(localizations.shortShaabanLabel, "Sha.");
      expect(localizations.shortRamadanLabel, "Ram.");
      expect(localizations.shortShawwalLabel, "Shaw.");
      expect(localizations.shortDhualqiLabel, "Dhu'l-Q");
      expect(localizations.shortDhualhiLabel, "Dhu'l-H");
      expect(localizations.ofDataPagerLabel, "of");
      expect(localizations.pagesDataPagerLabel, "pages");
      expect(localizations.rowsPerPageDataPagerLabel, "Rows per page");
      expect(localizations.afterDataGridFilteringLabel, "After");
      expect(
        localizations.afterOrEqualDataGridFilteringLabel,
        "After Or Equal",
      );
      expect(localizations.beforeDataGridFilteringLabel, "Before");
      expect(
        localizations.beforeOrEqualDataGridFilteringLabel,
        "Before Or Equal",
      );
      expect(localizations.beginsWithDataGridFilteringLabel, "Begins With");
      expect(localizations.containsDataGridFilteringLabel, "Contains");
      expect(
        localizations.doesNotBeginWithDataGridFilteringLabel,
        "Does Not Begin With",
      );
      expect(
        localizations.doesNotContainDataGridFilteringLabel,
        "Does Not Contain",
      );
      expect(
        localizations.doesNotEndWithDataGridFilteringLabel,
        "Does Not End With",
      );
      expect(
        localizations.doesNotEqualDataGridFilteringLabel,
        "Does Not Equal",
      );
      expect(localizations.emptyDataGridFilteringLabel, "Empty");
      expect(localizations.endsWithDataGridFilteringLabel, "Ends With");
      expect(localizations.equalsDataGridFilteringLabel, "Equals");
      expect(localizations.greaterThanDataGridFilteringLabel, "Greater Than");
      expect(
        localizations.greaterThanOrEqualDataGridFilteringLabel,
        "Greater Than Or Equal",
      );
      expect(localizations.lessThanDataGridFilteringLabel, "Less Than");
      expect(
        localizations.lessThanOrEqualDataGridFilteringLabel,
        "Less Than Or Equal",
      );
      expect(localizations.notEmptyDataGridFilteringLabel, "Not Empty");
      expect(localizations.notNullDataGridFilteringLabel, "Not Null");
      expect(localizations.nullDataGridFilteringLabel, "Null");
      expect(
        localizations.sortSmallestToLargestDataGridFilteringLabel,
        "Sort Smallest to Largest",
      );
      expect(
        localizations.sortLargestToSmallestDataGridFilteringLabel,
        "Sort Largest to Smallest",
      );
      expect(localizations.sortAToZDataGridFilteringLabel, "Sort A to Z");
      expect(localizations.sortZToADataGridFilteringLabel, "Sort Z to A");
      expect(
        localizations.sortOldestToNewestDataGridFilteringLabel,
        "Sort Oldest to Newest",
      );
      expect(
        localizations.sortNewestToOldestDataGridFilteringLabel,
        "Sort Newest to Oldest",
      );
      expect(localizations.clearFilterDataGridFilteringLabel, "Clear Filter");
      expect(localizations.fromDataGridFilteringLabel, "From");
      expect(localizations.textFiltersDataGridFilteringLabel, "Text Filters");
      expect(
        localizations.numberFiltersDataGridFilteringLabel,
        "Number Filters",
      );
      expect(localizations.dateFiltersDataGridFilteringLabel, "Date Filters");
      expect(localizations.searchDataGridFilteringLabel, "Search");
      expect(localizations.noMatchesDataGridFilteringLabel, "No matches");
      expect(localizations.okDataGridFilteringLabel, "OK");
      expect(localizations.cancelDataGridFilteringLabel, "Cancel");
      expect(
        localizations.showRowsWhereDataGridFilteringLabel,
        "Show rows where",
      );
      expect(localizations.andDataGridFilteringLabel, "And");
      expect(localizations.orDataGridFilteringLabel, "Or");
      expect(localizations.selectAllDataGridFilteringLabel, "Select All");
      expect(
        localizations.sortAndFilterDataGridFilteringLabel,
        "Sort and Filter",
      );
      expect(localizations.pdfBookmarksLabel, "Bookmarks");
      expect(localizations.pdfNoBookmarksLabel, "No bookmarks found");
      expect(localizations.pdfScrollStatusOfLabel, "of");
      expect(localizations.pdfGoToPageLabel, "Go to page");
      expect(localizations.pdfEnterPageNumberLabel, "Enter page number");
      expect(
        localizations.pdfInvalidPageNumberLabel,
        "Please enter a valid number",
      );
      expect(localizations.pdfPaginationDialogOkLabel, "OK");
      expect(localizations.pdfPaginationDialogCancelLabel, "CANCEL");
      expect(localizations.pdfHyperlinkLabel, "Open Web Page");
      expect(
        localizations.pdfHyperlinkContentLabel,
        "Do you want to open the page at",
      );
      expect(localizations.pdfHyperlinkDialogOpenLabel, "OPEN");
      expect(localizations.pdfHyperlinkDialogCancelLabel, "CANCEL");
      expect(localizations.passwordDialogHeaderTextLabel, "Password Protected");
      expect(
        localizations.passwordDialogContentLabel,
        "Enter the password to open this PDF file",
      );
      expect(localizations.passwordDialogHintTextLabel, "Enter Password");
      expect(
        localizations.passwordDialogInvalidPasswordLabel,
        "Invalid Password",
      );
      expect(localizations.pdfPasswordDialogOpenLabel, "OPEN");
      expect(localizations.pdfPasswordDialogCancelLabel, "CANCEL");
      expect(
        localizations.pdfSignaturePadDialogHeaderTextLabel,
        "Draw your signature",
      );
      expect(localizations.pdfSignaturePadDialogPenColorLabel, "Pen Color");
      expect(localizations.pdfSignaturePadDialogClearLabel, "CLEAR");
      expect(localizations.pdfSignaturePadDialogSaveLabel, "SAVE");
      expect(localizations.pdfTextSelectionMenuCopyLabel, "Copy");
      expect(localizations.pdfTextSelectionMenuHighlightLabel, "Highlight");
      expect(
        localizations.pdfTextSelectionMenuStrikethroughLabel,
        "Strikethrough",
      );
      expect(localizations.pdfTextSelectionMenuUnderlineLabel, "Underline");
      expect(localizations.pdfTextSelectionMenuSquigglyLabel, "Squiggly");
      expect(localizations.series, "Series");
    },
  );

  test("Subclass override replaces noEventsCalendarLabel", () {
    expect(localizations.noEventsCalendarLabel, "No events");
  });
}
