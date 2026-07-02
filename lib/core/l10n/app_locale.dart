import 'package:flutter_localization/flutter_localization.dart';

class AppLocale {
  // ── Helper ────────────────────────────────────────────────────────────────
  static String format(String key, {Map<String, String>? replace}) {
    final code =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
    String value;
    if (code == 'en') {
      value = eN[key] ?? key;
    } else {
      value = bN[key] ?? key;
    }
    if (replace != null) {
      for (final entry in replace.entries) {
        value = value.replaceAll('{${entry.key}}', entry.value);
      }
    }
    return value;
  }

  // ── Keys ──────────────────────────────────────────────────────────────────
  static const navHome = 'navHome';
  static const navQuran = 'navQuran';
  static const navTimes = 'navTimes';
  static const navDua = 'navDua';
  static const navSettings = 'navSettings';
  static const navCommunity = 'navCommunity';

  static const communityTitle = 'communityTitle';
  static const communityFeed = 'communityFeed';
  static const communityCalendar = 'communityCalendar';
  static const communityQA = 'communityQA';
  static const communityAnnouncements = 'communityAnnouncements';
  static const communityEvents = 'communityEvents';
  static const communityRequestEvent = 'communityRequestEvent';
  static const communityEventTitle = 'communityEventTitle';
  static const communityEventDescription = 'communityEventDescription';
  static const communityEventCategory = 'communityEventCategory';
  static const communityEventDateTime = 'communityEventDateTime';
  static const communityPickDateTime = 'communityPickDateTime';
  static const communityExpectedAttendance = 'communityExpectedAttendance';
  static const communityEnableDonation = 'communityEnableDonation';
  static const communitySubmitRequest = 'communitySubmitRequest';
  static const communityRequestSubmitted = 'communityRequestSubmitted';
  static const communityValidationRequired = 'communityValidationRequired';
  static const communityValidationAttendance = 'communityValidationAttendance';
  static const communityStatusPending = 'communityStatusPending';
  static const communityStatusApproved = 'communityStatusApproved';
  static const communityStatusRejected = 'communityStatusRejected';
  static const communityStatusRescheduled = 'communityStatusRescheduled';
  static const communityOrganizer = 'communityOrganizer';
  static const communityComments = 'communityComments';
  static const communityWriteComment = 'communityWriteComment';
  static const communityNoApprovedEvents = 'communityNoApprovedEvents';
  static const communityDonationTransparency = 'communityDonationTransparency';
  static const communityDonationCollected = 'communityDonationCollected';
  static const communityDonationSpent = 'communityDonationSpent';
  static const communityDonationRemaining = 'communityDonationRemaining';
  static const communityAnnouncementTitle = 'communityAnnouncementTitle';
  static const communityAnnouncementMessage = 'communityAnnouncementMessage';
  static const communityCreateAnnouncement = 'communityCreateAnnouncement';
  static const communityAnnouncementCreated = 'communityAnnouncementCreated';

  static const sectionInspirations = 'sectionInspirations';
  static const sectionDailyAmal = 'sectionDailyAmal';

  static const duaPeriodDay = 'duaPeriodDay';
  static const duaPeriodEvening = 'duaPeriodEvening';
  static const duaPeriodNight = 'duaPeriodNight';
  static const duaPeriodAll = 'duaPeriodAll';

  static const duaHeaderDay = 'duaHeaderDay';
  static const duaHeaderEvening = 'duaHeaderEvening';
  static const duaHeaderNight = 'duaHeaderNight';
  static const duaHeaderAll = 'duaHeaderAll';

  static const duaSubtitleDay = 'duaSubtitleDay';
  static const duaSubtitleEvening = 'duaSubtitleEvening';
  static const duaSubtitleNight = 'duaSubtitleNight';
  static const duaSubtitleAll = 'duaSubtitleAll';

  static const duaSearchHint = 'duaSearchHint';
  static const duaOfTheDay = 'duaOfTheDay';
  static const duaSectionMorning = 'duaSectionMorning';
  static const duaSectionDaily = 'duaSectionDaily';
  static const duaNoFavorites = 'duaNoFavorites';
  static const duaNoFavoritesHint = 'duaNoFavoritesHint';
  static const duaNoResults = 'duaNoResults';
  static const duaNoResultsHint = 'duaNoResultsHint';
  static const duaEmptyPeriod = 'duaEmptyPeriod';

  static const duaCategoryMorning = 'duaCategoryMorning';
  static const duaCategoryEvening = 'duaCategoryEvening';
  static const duaCategoryNight = 'duaCategoryNight';
  static const duaCategoryDaily = 'duaCategoryDaily';
  static const duaCategoryRamadan = 'duaCategoryRamadan';
  static const duaCategoryTravel = 'duaCategoryTravel';
  static const duaCategoryForgiveness = 'duaCategoryForgiveness';

  static const duaDetailTranslation = 'duaDetailTranslation';
  static const duaDetailPronunciation = 'duaDetailPronunciation';
  static const duaDetailCopied = 'duaDetailCopied';

  static const duaCardTitle = 'duaCardTitle';

  static const asmaulHusnaTitle = 'asmaulHusnaTitle';
  static const asmaulHusnaOf = 'asmaulHusnaOf';

  static const settingsTitle = 'settingsTitle';
  static const settingsLanguage = 'settingsLanguage';
  static const settingsAccount = 'settingsAccount';
  static const settingsEmail = 'settingsEmail';
  static const settingsSession = 'settingsSession';
  static const settingsLogout = 'settingsLogout';
  static const settingsLogoutTitle = 'settingsLogoutTitle';
  static const settingsLogoutMessage = 'settingsLogoutMessage';
  static const settingsLogoutCancel = 'settingsLogoutCancel';
  static const settingsLogoutConfirm = 'settingsLogoutConfirm';

  // Time Screen
  static const timePrayerTimes = 'timePrayerTimes';
  static const timeFetching = 'timeFetching';
  static const timeRetry = 'timeRetry';
  static const timeNoData = 'timeNoData';
  static const timeIftarTitle = 'timeIftarTitle';
  static const timeTableTitle = 'timeTableTitle';
  static const timeFajr = 'timeFajr';
  static const timeSunrise = 'timeSunrise';
  static const timeDhuhr = 'timeDhuhr';
  static const timeAsr = 'timeAsr';
  static const timeMaghrib = 'timeMaghrib';
  static const timeIsha = 'timeIsha';
  static const timeNextPrayer = 'timeNextPrayer';
  static const timeNextPrayerIn = 'timeNextPrayerIn';

  // Home Section Headers
  static const homeInspirations = 'homeInspirations';
  static const homeDailyAmal = 'homeDailyAmal';

  // Ayah Card
  static const ayahTitle = 'ayahTitle';
  static const ayahText = 'ayahText';
  static const ayahTranslation = 'ayahTranslation';
  static const ayahReference = 'ayahReference';

  // Salah Tracker
  static const salahTitle = 'salahTitle';
  static const salahWaiting = 'salahWaiting';
  static const salahDone = 'salahDone';

  // Sunnah Checklist
  static const checklistTitle = 'checklistTitle';
  static const checklistSadaqah = 'checklistSadaqah';
  static const checklistMulk = 'checklistMulk';
  static const checklistUmmah = 'checklistUmmah';

  // Quran Progress
  static const quranProgressTitle = 'quranProgressTitle';
  static const quranTarget = 'quranTarget';
  static const quranCurrent = 'quranCurrent';
  static const quranJuz = 'quranJuz';
  static const quranPage = 'quranPage';
  static const quranUpdateLog = 'quranUpdateLog';
  static const quranVerses = 'quranVerses';
  static const quranFailedLoad = 'quranFailedLoad';
  static const quranRetry = 'quranRetry';
  static const quranUpdateTitle = 'quranUpdateTitle';
  static const quranCurrentJuzLabel = 'quranCurrentJuzLabel';
  static const quranJuzHint = 'quranJuzHint';
  static const quranCurrentPageLabel = 'quranCurrentPageLabel';
  static const quranPageHint = 'quranPageHint';
  static const quranJuzRequired = 'quranJuzRequired';
  static const quranJuzInvalid = 'quranJuzInvalid';
  static const quranPageRequired = 'quranPageRequired';
  static const quranPageInvalid = 'quranPageInvalid';
  static const quranSave = 'quranSave';
  static const quranUpdateSuccess = 'quranUpdateSuccess';
  static const quranNoSurahs = 'quranNoSurahs';
  static const quranAudioError = 'quranAudioError';

  // Notices
  static const noticeBoardTitle = 'noticeBoardTitle';
  static const noticeNew = 'noticeNew';
  static const noticeComingSoon = 'noticeComingSoon';
  static const noticeShareComingSoon = 'noticeShareComingSoon';

  // Zakat
  static const zakatTitle = 'zakatTitle';
  static const zakatSubtitle = 'zakatSubtitle';
  static const zakatFamilyMembers = 'zakatFamilyMembers';
  static const zakatSelectType = 'zakatSelectType';
  static const zakatTotalAmount = 'zakatTotalAmount';
  static const zakatFitraWheat = 'zakatFitraWheat';
  static const zakatFitraBarley = 'zakatFitraBarley';
  static const zakatFitraDates = 'zakatFitraDates';
  static const zakatFitraRaisins = 'zakatFitraRaisins';
  static const zakatFitraCheese = 'zakatFitraCheese';
  static const zakatCalculateFitra = 'zakatCalculateFitra';
  static const zakatFitraDisclaimer = 'zakatFitraDisclaimer';

  static const duaCountSuffix = 'duaCountSuffix';

  // Header
  static const headerIftar = 'headerIftar';
  static const headerSuhoor = 'headerSuhoor';
  static const headerSuhoorEnds = 'headerSuhoorEnds';
  static const headerIftarToday = 'headerIftarToday';
  static const headerIftarIn = 'headerIftarIn';
  static const headerSuhoorTime = 'headerSuhoorTime';
  static const headerSuhoorIn = 'headerSuhoorIn';
  static const headerIftarTime = 'headerIftarTime';
  static const headerEverydayTitle = 'headerEverydayTitle';
  static const headerFetching = 'headerFetching';
  static const headerLoading = 'headerLoading';

  // Auth
  static const authWelcomeBack = 'authWelcomeBack';
  static const authSignInSubtitle = 'authSignInSubtitle';
  static const authEmailLabel = 'authEmailLabel';
  static const authEmailHint = 'authEmailHint';
  static const authPasswordLabel = 'authPasswordLabel';
  static const authLoginButton = 'authLoginButton';
  static const authNoAccount = 'authNoAccount';
  static const authCreateOne = 'authCreateOne';
  static const authEmailRequired = 'authEmailRequired';
  static const authEmailInvalid = 'authEmailInvalid';
  static const authPasswordRequired = 'authPasswordRequired';
  static const authCreateAccount = 'authCreateAccount';
  static const authRegisterSubtitle = 'authRegisterSubtitle';
  static const authFullNameLabel = 'authFullNameLabel';
  static const authFullNameHint = 'authFullNameHint';
  static const authRegisterButton = 'authRegisterButton';
  static const authHaveAccount = 'authHaveAccount';
  static const authNameRequired = 'authNameRequired';
  static const authPasswordTooShort = 'authPasswordTooShort';

  // AI Features
  static const aiAssistantTitle = 'aiAssistantTitle';
  static const aiAssistantHint = 'aiAssistantHint';
  static const aiAssistantTyping = 'aiAssistantTyping';
  static const aiDuaTitle = 'aiDuaTitle';
  static const aiDuaHint = 'aiDuaHint';
  static const aiDuaFeelingAnxious = 'aiDuaFeelingAnxious';
  static const aiDuaFeelingGrateful = 'aiDuaFeelingGrateful';
  static const aiDuaFeelingSad = 'aiDuaFeelingSad';
  static const aiDuaGenerateBtn = 'aiDuaGenerateBtn';
  static const aiZakatTitle = 'aiZakatTitle';
  static const aiZakatHint = 'aiZakatHint';
  static const aiZakatInitialMsg = 'aiZakatInitialMsg';
  static const aiZakatCalculating = 'aiZakatCalculating';
  static const aiZakatError = 'aiZakatError';
  static const aiQuranPlanTitle = 'aiQuranPlanTitle';
  static const aiQuranPlanGenerating = 'aiQuranPlanGenerating';
  static const aiQuranPlanResultTitle = 'aiQuranPlanResultTitle';
  static const aiQuranPlanNewBtn = 'aiQuranPlanNewBtn';
  static const aiQuranPlanDaysLeft = 'aiQuranPlanDaysLeft';
  static const aiQuranPlanMins = 'aiQuranPlanMins';
  static const aiQuranPlanSpeed = 'aiQuranPlanSpeed';
  static const aiQuranPlanSpeedSlow = 'aiQuranPlanSpeedSlow';
  static const aiQuranPlanSpeedAverage = 'aiQuranPlanSpeedAverage';
  static const aiQuranPlanSpeedFast = 'aiQuranPlanSpeedFast';
  static const aiQuranPlanGenerateBtn = 'aiQuranPlanGenerateBtn';
  static const aiSunnahTitle = 'aiSunnahTitle';
  static const aiSunnahGenerating = 'aiSunnahGenerating';
  static const aiSunnahError = 'aiSunnahError';
  static const aiSunnahEmpty = 'aiSunnahEmpty';
  static const aiSunnahCompletedAll = 'aiSunnahCompletedAll';
  static const moreToolZakatAI = 'moreToolZakatAI';
  static const quranPlanFabAI = 'quranPlanFabAI';

  // ── Nav
  static const navMore = 'navMore';

  // ── More screen
  static const moreTitle = 'moreTitle';
  static const moreTasbih = 'moreTasbih';
  static const moreQibla = 'moreQibla';
  static const moreFasting = 'moreFasting';
  static const moreCommunity = 'moreCommunity';
  static const moreHadith = 'moreHadith';
  static const moreIslamicCalendar = 'moreIslamicCalendar';
  static const moreStreaks = 'moreStreaks';
  static const moreCharity = 'moreCharity';
  static const moreQuranPlan = 'moreQuranPlan';
  static const moreJournal = 'moreJournal';
  static const moreMosques = 'moreMosques';
  static const moreSettings = 'moreSettings';

  // ── Quran Plan
  static const quranPlanTitle = 'quranPlanTitle';
  static const quranPlanRecent = 'quranPlanRecent';
  static const quranPlanLogMore = 'quranPlanLogMore';
  static const quranPlanLogToday = 'quranPlanLogToday';
  static const quranPlanStartJourney = 'quranPlanStartJourney';
  static const quranPlanLogReading = 'quranPlanLogReading';
  static const quranPlanPagesRead = 'quranPlanPagesRead';
  static const quranPlanPagesHint = 'quranPlanPagesHint';
  static const quranPlanCancel = 'quranPlanCancel';
  static const quranPlanSave = 'quranPlanSave';
  static const quranPlanSetTarget = 'quranPlanSetTarget';
  static const quranPlanPagesPerDay = 'quranPlanPagesPerDay';
  static const quranPlanPagesPerDayHint = 'quranPlanPagesPerDayHint';
  static const quranPlanTodayReading = 'quranPlanTodayReading';
  static const quranPlanTargetAchieved = 'quranPlanTargetAchieved';
  static const quranPlanMonthlyProgress = 'quranPlanMonthlyProgress';
  static const quranPlanPagesReadStat = 'quranPlanPagesReadStat';
  static const quranPlanDaysCompleted = 'quranPlanDaysCompleted';
  static const quranPlanDailyTarget = 'quranPlanDailyTarget';
  static const quranPlanReadingFraction = 'quranPlanReadingFraction';

  // ── Community
  static const communityNotifications = 'communityNotifications';
  static const communityNoNotifications = 'communityNoNotifications';
  static const communityCompleted = 'communityCompleted';
  static const communityCancelled = 'communityCancelled';
  static const communityAccountRequired = 'communityAccountRequired';
  static const communitySignInRegister = 'communitySignInRegister';
  static const communityAuthPrompt = 'communityAuthPrompt';

  static const homeCommunity = 'homeCommunity';
  static const communityExplore = 'communityExplore';

  // ── Event Detail
  static const eventDetailTitle = 'eventDetailTitle';
  static const eventDetailAbout = 'eventDetailAbout';
  static const eventDetailOrganizedBy = 'eventDetailOrganizedBy';
  static const eventDetailContact = 'eventDetailContact';
  static const eventDetailRaised = 'eventDetailRaised';
  static const eventDetailGoal = 'eventDetailGoal';
  static const eventDetailContributeNow = 'eventDetailContributeNow';
  static const eventDetailLike = 'eventDetailLike';
  static const eventDetailSupport = 'eventDetailSupport';
  static const eventDetailComments = 'eventDetailComments';
  static const eventDetailAddComment = 'eventDetailAddComment';
  static const eventDetailNoComments = 'eventDetailNoComments';
  static const eventDetailPercentReached = 'eventDetailPercentReached';
  static const eventDetailUnknownOrganizer = 'eventDetailUnknownOrganizer';
  static const eventDetailUser = 'eventDetailUser';
  static const eventDetailTimeFormat = 'eventDetailTimeFormat';
  static const eventDetailMainContentComments = 'eventDetailMainContentComments';

  // ── Journal
  static const journalTitle = 'journalTitle';
  static const journalSubtitle = 'journalSubtitle';
  static const journalWriteFirst = 'journalWriteFirst';
  static const journalTapToAdd = 'journalTapToAdd';
  static const journalEditEntry = 'journalEditEntry';
  static const journalNewEntry = 'journalNewEntry';
  static const journalTitleLabel = 'journalTitleLabel';
  static const journalReflectionLabel = 'journalReflectionLabel';
  static const journalTagsLabel = 'journalTagsLabel';
  static const journalUpdate = 'journalUpdate';
  static const journalSave = 'journalSave';
  static const journalDelete = 'journalDelete';
  static const journalNoEntries = 'journalNoEntries';

  // ── Tasbih
  static const tasbihTitle = 'tasbihTitle';
  static const tasbihResetAllTitle = 'tasbihResetAllTitle';
  static const tasbihResetAllMessage = 'tasbihResetAllMessage';
  static const tasbihCancel = 'tasbihCancel';
  static const tasbihReset = 'tasbihReset';
  static const tasbihCompleted = 'tasbihCompleted';
  static const tasbihRemaining = 'tasbihRemaining';
  static const tasbihTodaySummary = 'tasbihTodaySummary';
  static const tasbihCounterTitle = 'tasbihCounterTitle';
  static const tasbihCounterCompleted = 'tasbihCounterCompleted';
  static const tasbihCounterReset = 'tasbihCounterReset';
  static const tasbihCounterTapHint = 'tasbihCounterTapHint';

  // ── Fasting
  static const fastingTitle = 'fastingTitle';
  static const fastingDescription = 'fastingDescription';
  static const fastingCalendar = 'fastingCalendar';
  static const fastingToday = 'fastingToday';
  static const fastingMonday = 'fastingMonday';
  static const fastingThursday = 'fastingThursday';
  static const fastingWhiteDays = 'fastingWhiteDays';
  static const fastingFastKept = 'fastingFastKept';
  static const fastingMissed = 'fastingMissed';
  static const fastingMarkMissed = 'fastingMarkMissed';
  static const fastingMarkKept = 'fastingMarkKept';
  static const fastingThisMonth = 'fastingThisMonth';
  static const fastingStreak = 'fastingStreak';
  static const fastingThisYear = 'fastingThisYear';
  static const fastingLegendKept = 'fastingLegendKept';
  static const fastingLegendMissed = 'fastingLegendMissed';
  static const fastingLegendRecommended = 'fastingLegendRecommended';

  // ── Charity
  static const charityTitle = 'charityTitle';
  static const charityHistory = 'charityHistory';
  static const charityAdd = 'charityAdd';
  static const charityNoRecords = 'charityNoRecords';
  static const charityAddFirst = 'charityAddFirst';
  static const charityAddDonation = 'charityAddDonation';
  static const charityAmount = 'charityAmount';
  static const charityCategory = 'charityCategory';
  static const charityNoteOptional = 'charityNoteOptional';
  static const charitySave = 'charitySave';
  static const charityThisMonth = 'charityThisMonth';
  static const charityAllTime = 'charityAllTime';
  static const charityAvgDay = 'charityAvgDay';
  static const charityDailyAverage = 'charityDailyAverage';

  // ── Streaks
  static const streakTitle = 'streakTitle';
  static const streakYourStreaks = 'streakYourStreaks';
  static const streakSalah = 'streakSalah';
  static const streakSunnahChecklist = 'streakSunnahChecklist';
  static const streakQuranReading = 'streakQuranReading';
  static const streakDayStreak = 'streakDayStreak';
  static const streakStayConsistent = 'streakStayConsistent';
  static const streakInfo = 'streakInfo';

  // ── Qibla
  static const qiblaTitle = 'qiblaTitle';
  static const qiblaFindingLocation = 'qiblaFindingLocation';
  static const qiblaCalibratePrompt = 'qiblaCalibratePrompt';
  static const qiblaAlignPrompt = 'qiblaAlignPrompt';
  static const qiblaLocation = 'qiblaLocation';
  static const qiblaBearing = 'qiblaBearing';
  static const qiblaFacing = 'qiblaFacing';

  // ── Mosque
  static const mosqueTitle = 'mosqueTitle';
  static const mosqueFinding = 'mosqueFinding';
  static const mosqueTryAgain = 'mosqueTryAgain';
  static const mosqueNoFound = 'mosqueNoFound';
  static const mosqueDirections = 'mosqueDirections';

  // ── Islamic Calendar
  static const islamicCalendarTitle = 'islamicCalendarTitle';
  static const islamicCalendarNoEvents = 'islamicCalendarNoEvents';

  // ── Ads
  static const adSkip = 'adSkip';
  static const adLabel = 'adLabel';
  static const adBannerLabel = 'adBannerLabel';
  static const adAppName = 'adAppName';

  // ── Settings
  static const settingsContactInfo = 'settingsContactInfo';
  static const settingsSignInRegister = 'settingsSignInRegister';
  static const settingsLanguageLabel = 'settingsLanguageLabel';
  static const settingsGuest = 'settingsGuest';
  static const settingsNotSignedIn = 'settingsNotSignedIn';
  static const settingsNoContact = 'settingsNoContact';
  static const settingsUser = 'settingsUser';

  // ── Hadith
  static const hadithCardTitle = 'hadithCardTitle';
  static const hadithNumber = 'hadithNumber';

  // ── Time
  static const timeJummah = 'timeJummah';

  // ── Misc
  static const cancel = 'cancel';
  static const authRememberMe = 'authRememberMe';
  static const save = 'save';
  static const reset = 'reset';
  static const completed = 'completed';
  static const urgent = 'urgent';
  static const important = 'important';
  static const broadcast = 'broadcast';
  static const justNow = 'justNow';
  static const donation = 'donation';
  static const tbd = 'tbd';
  static const event = 'event';
  static const timeAgoDays = 'timeAgoDays';
  static const timeAgoHours = 'timeAgoHours';
  static const timeAgoMinutes = 'timeAgoMinutes';

  // ── Book Store
  static const bookStoreTitle = 'bookStoreTitle';
  static const bookStoreNoBooks = 'bookStoreNoBooks';
  static const bookStoreOrder = 'bookStoreOrder';
  static const bookStoreBookTitle = 'bookStoreBookTitle';
  static const bookStoreName = 'bookStoreName';
  static const bookStorePhone = 'bookStorePhone';
  static const bookStoreAddress = 'bookStoreAddress';
  static const bookStoreOrderType = 'bookStoreOrderType';
  static const bookStoreDelivery = 'bookStoreDelivery';
  static const bookStorePickup = 'bookStorePickup';
  static const bookStorePlaceOrder = 'bookStorePlaceOrder';
  static const bookStoreOrderSuccess = 'bookStoreOrderSuccess';
  static const bookStoreQuantity = 'bookStoreQuantity';

  // ── Countdown
  static const countdownTitle = 'countdownTitle';
  static const countdownDays = 'countdownDays';
  static const countdownHours = 'countdownHours';
  static const countdownMinutes = 'countdownMinutes';
  static const countdownSeconds = 'countdownSeconds';

  // ── Quran LMS
  static const lmsTitle = 'lmsTitle';
  static const lmsNoLectures = 'lmsNoLectures';
  static const lmsWatch = 'lmsWatch';
  static const lmsCompleted = 'lmsCompleted';
  static const lmsProgress = 'lmsProgress';
  static const lmsInProgress = 'lmsInProgress';

  // ── Calendar PDF
  static const calendarPdfTitle = 'calendarPdfTitle';
  static const calendarPdfError = 'calendarPdfError';
  static const calendarPdfShare = 'calendarPdfShare';
  static const calendarPdfCity = 'calendarPdfCity';
  static const calendarPdfLanguage = 'calendarPdfLanguage';
  static const calendarPdfTimeFormat = 'calendarPdfTimeFormat';
  static const calendarPdfGenerating = 'calendarPdfGenerating';
  static const calendarPdfGenerate = 'calendarPdfGenerate';
  static const calendarPdfMethod = 'calendarPdfMethod';

  // ── Services
  static const servicesTitle = 'servicesTitle';
  static const servicesSubtitle = 'servicesSubtitle';
  static const servicesLearnMore = 'servicesLearnMore';

  // ── English strings ────────────────────────────────────────────────────────
  static const Map<String, dynamic> eN = {
    navHome: 'Home',
    navQuran: 'Quran',
    navTimes: 'Times',
    navDua: 'Dua',
    navSettings: 'Settings',
    navCommunity: 'Community',

    homeCommunity: 'Community',
    communityExplore: 'Explore Community',
    communityTitle: 'Mosque Community',
    communityFeed: 'Feed',
    communityCalendar: 'Calendar',
    communityQA: 'Q&A',
    communityAnnouncements: 'Announcements',
    communityEvents: 'Events',
    communityRequestEvent: 'Request Event',
    communityEventTitle: 'Title',
    communityEventDescription: 'Description',
    communityEventCategory: 'Category',
    communityEventDateTime: 'Date and time',
    communityPickDateTime: 'Pick date and time',
    communityExpectedAttendance: 'Expected attendance',
    communityEnableDonation: 'Enable donation',
    communitySubmitRequest: 'Submit request',
    communityRequestSubmitted: 'Event request submitted.',
    communityValidationRequired: 'This field is required.',
    communityValidationAttendance: 'Enter a valid attendee number.',
    communityStatusPending: 'Pending',
    communityStatusApproved: 'Approved',
    communityStatusRejected: 'Rejected',
    communityStatusRescheduled: 'Rescheduled',
    communityOrganizer: 'Organizer',
    communityComments: 'Comments',
    communityWriteComment: 'Write a comment...',
    communityNoApprovedEvents: 'No approved events yet.',
    communityDonationTransparency: 'Donation Transparency',
    communityDonationCollected: 'Collected',
    communityDonationSpent: 'Spent',
    communityDonationRemaining: 'Remaining',
    communityAnnouncementTitle: 'Announcement title',
    communityAnnouncementMessage: 'Announcement message',
    communityCreateAnnouncement: 'Create announcement',
    communityAnnouncementCreated: 'Announcement published.',

    sectionInspirations: "Today's Inspirations",
    sectionDailyAmal: "Today's Deeds",

    duaPeriodDay: 'Day',
    duaPeriodEvening: 'Evening',
    duaPeriodNight: 'Night',
    duaPeriodAll: 'All',

    duaHeaderDay: 'Morning & Daily Duas',
    duaHeaderEvening: 'Evening Adhkar',
    duaHeaderNight: 'Night Duas',
    duaHeaderAll: 'All Duas',

    duaSubtitleDay: 'From Fajr to Maghrib',
    duaSubtitleEvening: 'From Asr to Isha',
    duaSubtitleNight: 'From Isha to Fajr',
    duaSubtitleAll: 'Collection of duas',

    duaSearchHint: 'Search duas...',
    duaOfTheDay: 'Dua of the Day',
    duaSectionMorning: 'Morning Adhkar',
    duaSectionDaily: 'Daily Duas',
    duaNoFavorites: 'No favorite duas',
    duaNoFavoritesHint: 'Tap the heart icon to add favorites',
    duaNoResults: 'No duas found',
    duaNoResultsHint: 'Try searching with different terms',
    duaEmptyPeriod: 'No duas for this period',

    duaCategoryMorning: 'Morning',
    duaCategoryEvening: 'Evening',
    duaCategoryNight: 'Night',
    duaCategoryDaily: 'Daily',
    duaCategoryRamadan: 'Ramadan',
    duaCategoryTravel: 'Travel',
    duaCategoryForgiveness: 'Forgiveness',

    duaDetailTranslation: 'Translation',
    duaDetailPronunciation: 'Pronunciation',
    duaDetailCopied: 'Copied',

    duaCardTitle: 'Dua of the Day',

    asmaulHusnaTitle: 'Asmaul Husna',
    asmaulHusnaOf: 'of 99',

    settingsTitle: 'Settings',
    settingsLanguage: 'Language',
    settingsAccount: 'Account',
    settingsEmail: 'Email',
    settingsSession: 'Session',
    settingsLogout: 'Log out',
    settingsLogoutTitle: 'Log out?',
    settingsLogoutMessage: 'You will need to sign in again to use the app.',
    settingsLogoutCancel: 'Cancel',
    settingsLogoutConfirm: 'Log out',

    // Time Screen
    timePrayerTimes: 'Prayer Times',
    timeFetching: 'Fetching location and timings...',
    timeRetry: 'Retry Location',
    timeNoData: 'No timing data available.',
    timeIftarTitle: 'Iftar Time\n(Maghrib)',
    timeTableTitle: 'Prayer Times Table',
    timeFajr: 'Fajr',
    timeSunrise: 'Sunrise',
    timeDhuhr: 'Dhuhr',
    timeAsr: 'Asr',
    timeMaghrib: 'Maghrib',
    timeIsha: 'Isha',
    timeNextPrayer: 'Next Prayer',
    timeNextPrayerIn: 'Starts In',

    // Home Section Headers
    homeInspirations: "Today's Inspirations",
    homeDailyAmal: "Today's Deeds",

    // Ayah Card
    ayahTitle: 'Ayah of the Day',
    ayahText: 'شَهْرُ رَمَضَانَ الَّذِي أُنزِلَ ফিহিল কুরআনু হুদাল্লিন নাসি',
    ayahTranslation: '"The month of Ramadan [is that] in which was revealed the Qur\'an, a guidance for the people."',
    ayahReference: '— Surah Al-Baqarah 2:185',

    // Salah Tracker
    salahTitle: 'Daily Salah',
    salahWaiting: 'Waiting for Fajr time to begin...',
    salahDone: 'Done',

    // Sunnah Checklist
    checklistTitle: 'Sunnah Checklist',
    checklistSadaqah: 'Give Sadaqah (Charity) today',
    checklistMulk: 'Recite Surah Al-Mulk before bed',
    checklistUmmah: 'Make Dua for the Ummah',

    // Quran Progress
    quranProgressTitle: 'Quran Progress',
    quranTarget: 'Target',
    quranCurrent: 'Current',
    quranJuz: 'Juz',
    quranPage: 'Page',
    quranUpdateLog: 'Update Log',
    quranVerses: 'Verses',
    quranFailedLoad: 'Failed to load Surah details',
    quranRetry: 'Retry',
    quranUpdateTitle: 'Update Quran Progress',
    quranCurrentJuzLabel: 'Current Juz',
    quranJuzHint: 'Enter Juz number (1-30)',
    quranCurrentPageLabel: 'Current Page',
    quranPageHint: 'Enter page number (1-604)',
    quranJuzRequired: 'Please enter Juz number',
    quranJuzInvalid: 'Juz must be between 1 and 30',
    quranPageRequired: 'Please enter page number',
    quranPageInvalid: 'Page must be between 1 and 604',
    quranSave: 'Save',
    quranUpdateSuccess: 'Progress updated successfully!',
    quranNoSurahs: 'No Surahs found',
    quranAudioError: 'Failed to play audio. Check internet connection.',

    // Notices
    noticeBoardTitle: 'Live Notice Board',
    noticeNew: 'NEW',
    noticeComingSoon: 'Coming soon!',
    noticeShareComingSoon: 'Share functionality coming soon!',

    // Zakat
    zakatTitle: 'Zakat-al-Fitr',
    zakatSubtitle: 'Calculate your Sadaqatul Fitr',
    zakatFamilyMembers: 'Family Members',
    zakatSelectType: 'Select Item Type',
    zakatTotalAmount: 'Total Amount',
    zakatFitraWheat: 'Wheat (Minimum)',
    zakatFitraBarley: 'Barley',
    zakatFitraDates: 'Dates',
    zakatFitraRaisins: 'Raisins',
    zakatFitraCheese: 'Cheese / Ajwa',
    zakatCalculateFitra: 'Calculate Fitra',
    zakatFitraDisclaimer: 'Rates are approximate and based on current market values.',

    duaCountSuffix: '',

    // Header
    headerIftar: 'Iftar At',
    headerSuhoor: 'Suhoor Ends',
    headerSuhoorEnds: 'Suhoor Ends',
    headerIftarToday: 'Iftar Today',
    headerIftarIn: 'Iftar In',
    headerSuhoorTime: 'Suhoor Time',
    headerSuhoorIn: 'Suhoor In',
    headerIftarTime: 'Iftar Time',
    headerEverydayTitle: 'Daily Tracker',
    headerFetching: 'Fetching Date...',
    headerLoading: 'Loading',

    // Auth
    authWelcomeBack: 'Welcome back',
    authSignInSubtitle: 'Sign in to your Ramadan Planner',
    authEmailLabel: 'Email address',
    authEmailHint: 'you@example.com',
    authPasswordLabel: 'Password',
    authLoginButton: 'Log In',
    authNoAccount: "Don't have an account? ",
    authCreateOne: 'Create one',
    authEmailRequired: 'Email is required.',
    authEmailInvalid: 'Enter a valid email.',
    authPasswordRequired: 'Password is required.',
    authCreateAccount: 'Create account',
    authRegisterSubtitle: 'Join us for a productive Ramadan',
    authFullNameLabel: 'Full Name',
    authFullNameHint: 'John Doe',
    authRegisterButton: 'Sign Up',
    authHaveAccount: 'Already have an account? ',
    authNameRequired: 'Name is required.',
    authPasswordTooShort: 'Password must be at least 6 characters.',

    // AI Features (English)
    aiAssistantTitle: 'Islamic Assistant',
    aiAssistantHint: 'Ask your question...',
    aiAssistantTyping: 'Typing...',
    aiDuaTitle: 'Smart Dua Recommender',
    aiDuaHint: 'How are you feeling today?',
    aiDuaFeelingAnxious: 'Anxious',
    aiDuaFeelingGrateful: 'Grateful',
    aiDuaFeelingSad: 'Sad',
    aiDuaGenerateBtn: 'Suggest Dua',
    aiZakatTitle: 'Zakat Assistant',
    aiZakatHint: 'Type your answer...',
    aiZakatInitialMsg: 'Assalamu Alaikum! I am your interactive Zakat calculator. I will help you calculate your Zakat step-by-step. First, do you have any gold (Gold)? If so, how many grams or bhori?',
    aiZakatCalculating: 'Calculating...',
    aiZakatError: 'Connection error',
    aiQuranPlanTitle: 'AI Quran Routine',
    aiQuranPlanGenerating: 'Generating a custom plan for you...',
    aiQuranPlanResultTitle: 'Your Quran Plan',
    aiQuranPlanNewBtn: 'Generate New Plan',
    aiQuranPlanDaysLeft: 'Ramadan days left',
    aiQuranPlanMins: 'Daily reading time (mins)',
    aiQuranPlanSpeed: 'Reading speed',
    aiQuranPlanSpeedSlow: 'Slow',
    aiQuranPlanSpeedAverage: 'Average',
    aiQuranPlanSpeedFast: 'Fast',
    aiQuranPlanGenerateBtn: 'Generate My Plan',
    aiSunnahTitle: 'Daily AI Sunnahs',
    aiSunnahGenerating: 'Generating your daily Sunnahs...',
    aiSunnahError: 'Failed to generate Sunnahs. Please try again.',
    aiSunnahEmpty: 'No Sunnahs available for today.',
    aiSunnahCompletedAll: 'MashaAllah! You completed all daily Sunnahs!',
    moreToolZakatAI: 'Zakat (AI)',
    quranPlanFabAI: 'AI Plan',

    // Nav
    navMore: 'More',

    // More
    moreTitle: 'Islamic Tools',
    moreTasbih: 'Tasbih',
    moreQibla: 'Qibla',
    moreFasting: 'Fasting',
    moreCommunity: 'Community',
    moreHadith: 'Hadith',
    moreIslamicCalendar: 'Islamic Calendar',
    moreStreaks: 'Streaks',
    moreCharity: 'Charity',
    moreQuranPlan: 'Quran Plan',
    moreJournal: 'Journal',
    moreMosques: 'Mosques',
    moreSettings: 'Settings',

    // Quran Plan
    quranPlanTitle: 'Quran Reading Plan',
    quranPlanRecent: 'Recent Activity',
    quranPlanLogMore: 'Log more',
    quranPlanLogToday: "Log today's reading",
    quranPlanStartJourney: 'Start your Quran journey today!',
    quranPlanLogReading: 'Log Reading',
    quranPlanPagesRead: 'Pages read',
    quranPlanPagesHint: 'Enter number of pages',
    quranPlanCancel: 'Cancel',
    quranPlanSave: 'Save',
    quranPlanSetTarget: 'Set Reading Target',
    quranPlanPagesPerDay: 'Pages per day',
    quranPlanPagesPerDayHint: 'e.g. 5',
    quranPlanTodayReading: "Today's Reading",
    quranPlanTargetAchieved: 'Daily target achieved!',
    quranPlanMonthlyProgress: 'Monthly Progress',
    quranPlanPagesReadStat: 'Pages Read',
    quranPlanDaysCompleted: 'Days Completed',
    quranPlanDailyTarget: 'Daily Target',
    quranPlanReadingFraction: '{read}/{target} pages',

    // Community
    communityNotifications: 'Notifications',
    communityNoNotifications: 'No notifications yet',
    communityCompleted: 'Completed',
    communityCancelled: 'Cancelled',
    communityAccountRequired: 'Account Required',
    communitySignInRegister: 'Sign In / Register',
    communityAuthPrompt: 'You need to create an account or sign in to {action}. It takes less than a minute!',

    // Event Detail
    eventDetailTitle: 'Event Details',
    eventDetailAbout: 'About this event',
    eventDetailOrganizedBy: 'Organized by',
    eventDetailContact: 'Contact',
    eventDetailRaised: 'Raised',
    eventDetailGoal: 'Goal',
    eventDetailContributeNow: 'Contribute Now',
    eventDetailLike: 'Like',
    eventDetailSupport: 'Support',
    eventDetailComments: 'Comments',
    eventDetailAddComment: 'Add a comment...',
    eventDetailNoComments: 'No comments yet. Be the first to say something!',
    eventDetailPercentReached: '{percent}% of the target reached',
    eventDetailUnknownOrganizer: 'Unknown Organizer',
    eventDetailUser: 'User',
    eventDetailTimeFormat: 'EEEE, MMMM d',
    eventDetailMainContentComments: 'Comments ({count})',

    // Journal
    journalTitle: 'Islamic Journal',
    journalSubtitle: 'Your Islamic Journal',
    journalWriteFirst: 'Write First Entry',
    journalTapToAdd: 'Tap + to add new',
    journalEditEntry: 'Edit Entry',
    journalNewEntry: 'New Journal Entry',
    journalTitleLabel: 'Title',
    journalReflectionLabel: 'Reflection',
    journalTagsLabel: 'Tags',
    journalUpdate: 'Update',
    journalSave: 'Save',
    journalDelete: 'Delete Entry',
    journalNoEntries: 'Reflect on your day, record duas answered,\nset goals, and track your spiritual journey',

    // Tasbih
    tasbihTitle: 'Tasbih Counter',
    tasbihResetAllTitle: 'Reset all counters?',
    tasbihResetAllMessage: 'This will reset all dhikr counts to 0.',
    tasbihCancel: 'Cancel',
    tasbihReset: 'Reset',
    tasbihCompleted: 'Completed!',
    tasbihRemaining: '{count} remaining',
    tasbihTodaySummary: 'Today: {total} total · {completed}/{all} completed',
    tasbihCounterTitle: 'Tasbih Counter',
    tasbihCounterCompleted: 'Completed!',
    tasbihCounterReset: 'Reset',
    tasbihCounterTapHint: 'Tap to count',

    // Fasting
    fastingTitle: 'Voluntary Fasting',
    fastingDescription: "Track your voluntary fasts: Mon/Thu, White Days (13-14-15), and Dawud's fast",
    fastingCalendar: 'Calendar',
    fastingToday: 'Today',
    fastingMonday: 'Monday',
    fastingThursday: 'Thursday',
    fastingWhiteDays: 'White Days',
    fastingFastKept: 'Fast Kept',
    fastingMissed: 'Missed',
    fastingMarkMissed: 'Mark Missed',
    fastingMarkKept: 'Mark Kept',
    fastingThisMonth: 'This Month',
    fastingStreak: 'Streak',
    fastingThisYear: 'This Year',
    fastingLegendKept: 'Fast Kept',
    fastingLegendMissed: 'Missed',
    fastingLegendRecommended: 'Recommended',

    // Charity
    charityTitle: 'Charity Tracker',
    charityHistory: 'History',
    charityAdd: 'Add',
    charityNoRecords: 'No charity records yet',
    charityAddFirst: 'Add your first donation',
    charityAddDonation: 'Add Donation',
    charityAmount: 'Amount (\$)',
    charityCategory: 'Category',
    charityNoteOptional: 'Note (optional)',
    charitySave: 'Save',
    charityThisMonth: 'This Month',
    charityAllTime: 'All Time',
    charityAvgDay: 'Avg/Day',
    charityDailyAverage: 'daily average',

    // Streaks
    streakTitle: 'Habit Streaks',
    streakYourStreaks: 'Your Streaks',
    streakSalah: 'Salah',
    streakSunnahChecklist: 'Sunnah Checklist',
    streakQuranReading: 'Quran Reading',
    streakDayStreak: 'Day Streak',
    streakStayConsistent: 'Stay consistent!',
    streakInfo: 'Streaks update when you complete activities daily. Keep going to build consistency!',

    // Qibla
    qiblaTitle: 'Qibla Compass',
    qiblaFindingLocation: 'Finding your location...',
    qiblaCalibratePrompt: 'Move your phone in a figure-8 pattern\nto calibrate the compass',
    qiblaAlignPrompt: 'Align the red needle to Qibla',
    qiblaLocation: 'Location: {lat}, {lng}',
    qiblaBearing: 'Qibla: {dir}',
    qiblaFacing: 'Facing Qibla!',

    // Mosque
    mosqueTitle: 'Nearby Mosques',
    mosqueFinding: 'Finding nearby mosques...',
    mosqueTryAgain: 'Try Again',
    mosqueNoFound: 'No mosques found nearby',
    mosqueDirections: 'Directions',

    // Islamic Calendar
    islamicCalendarTitle: 'Islamic Calendar',
    islamicCalendarNoEvents: 'No events this month',

    // Ads
    adSkip: 'Skip',
    adLabel: 'AD',
    adBannerLabel: 'Ad',
    adAppName: 'Ramadan Planner',

    // Settings
    settingsContactInfo: 'Contact Info',
    settingsSignInRegister: 'Sign In / Create Account',
    settingsLanguageLabel: 'App Language',
    settingsGuest: 'Guest',
    settingsNotSignedIn: 'Not signed in',
    settingsNoContact: 'No contact info',
    settingsUser: 'User',

    // Hadith
    hadithCardTitle: 'Hadith of the Day',
    hadithNumber: 'Hadith #{number}',

    // Time
    timeJummah: 'Jummah',

    // Misc
    cancel: 'Cancel',
    authRememberMe: 'Remember Me',
    save: 'Save',
    reset: 'Reset',
    completed: 'Completed',
    urgent: 'URGENT',
    important: 'IMPORTANT',
    broadcast: 'BROADCAST',
    justNow: 'Just now',
    donation: 'Donation',
    tbd: 'TBD',
    event: 'EVENT',
    timeAgoDays: '{count}d ago',
    timeAgoHours: '{count}h ago',
    timeAgoMinutes: '{count}m ago',

    // Book Store
    bookStoreTitle: 'Book Store',
    bookStoreNoBooks: 'No books available',
    bookStoreOrder: 'Order',
    bookStoreBookTitle: 'Book',
    bookStoreName: 'Full Name',
    bookStorePhone: 'Phone Number',
    bookStoreAddress: 'Delivery Address',
    bookStoreOrderType: 'Order Type',
    bookStoreDelivery: 'Delivery',
    bookStorePickup: 'Pickup',
    bookStorePlaceOrder: 'Place Order',
    bookStoreOrderSuccess: 'Order placed successfully!',
    bookStoreQuantity: 'Qty',

    // Countdown
    countdownTitle: 'Countdown',
    countdownDays: 'Days',
    countdownHours: 'Hours',
    countdownMinutes: 'Minutes',
    countdownSeconds: 'Seconds',

    // Quran LMS
    lmsTitle: 'Quran Lectures',
    lmsNoLectures: 'No lectures available',
    lmsWatch: 'Watch',
    lmsCompleted: 'Completed',
    lmsProgress: 'Mark Completed',
    lmsInProgress: 'In Progress',

    // Calendar PDF
    calendarPdfTitle: 'Ramadan Calendar',
    calendarPdfError: 'Error',
    calendarPdfShare: 'Share PDF',
    calendarPdfCity: 'City',
    calendarPdfLanguage: 'Language',
    calendarPdfTimeFormat: 'Time Format',
    calendarPdfGenerating: 'Generating...',
    calendarPdfGenerate: 'Generate PDF',
    calendarPdfMethod: 'Calculation Method',

    // Services
    servicesTitle: 'Services',
    servicesSubtitle: 'Explore our services designed to enrich your Ramadan experience',
    servicesLearnMore: 'Learn More',
  };

  // ── Bengali strings ────────────────────────────────────────────────────────
  static const Map<String, dynamic> bN = {
    navHome: 'হোম',
    navQuran: 'কুরআন',
    navTimes: 'নামাজ',
    navDua: 'দোয়া',
    navSettings: 'সেটিংস',
    navCommunity: 'কমিউনিটি',

    homeCommunity: 'কমিউনিটি',
    communityExplore: 'কমিউনিটি এক্সপ্লোর করুন',
    communityTitle: 'মসজিদ কমিউনিটি',
    communityFeed: 'ফিড',
    communityCalendar: 'ক্যালেন্ডার',
    communityQA: 'প্রশ্ন ও উত্তর',
    communityAnnouncements: 'ঘোষণা',
    communityEvents: 'ইভেন্ট',
    communityRequestEvent: 'ইভেন্ট অনুরোধ',
    communityEventTitle: 'শিরোনাম',
    communityEventDescription: 'বিস্তারিত',
    communityEventCategory: 'ক্যাটাগরি',
    communityEventDateTime: 'তারিখ ও সময়',
    communityPickDateTime: 'তারিখ ও সময় নির্বাচন করুন',
    communityExpectedAttendance: 'সম্ভাব্য উপস্থিতি',
    communityEnableDonation: 'দান চালু করুন',
    communitySubmitRequest: 'অনুরোধ পাঠান',
    communityRequestSubmitted: 'ইভেন্ট অনুরোধ জমা হয়েছে।',
    communityValidationRequired: 'এই ঘরটি পূরণ করুন।',
    communityValidationAttendance: 'সঠিক উপস্থিতির সংখ্যা দিন।',
    communityStatusPending: 'অপেক্ষমাণ',
    communityStatusApproved: 'অনুমোদিত',
    communityStatusRejected: 'প্রত্যাখ্যাত',
    communityStatusRescheduled: 'পুনঃনির্ধারিত',
    communityOrganizer: 'আয়োজক',
    communityComments: 'মন্তব্য',
    communityWriteComment: 'মন্তব্য লিখুন...',
    communityNoApprovedEvents: 'এখনও অনুমোদিত ইভেন্ট নেই।',
    communityDonationTransparency: 'দান স্বচ্ছতা',
    communityDonationCollected: 'সংগৃহীত',
    communityDonationSpent: 'ব্যয়',
    communityDonationRemaining: 'অবশিষ্ট',
    communityAnnouncementTitle: 'ঘোষণার শিরোনাম',
    communityAnnouncementMessage: 'ঘোষণার বার্তা',
    communityCreateAnnouncement: 'ঘোষণা প্রকাশ করুন',
    communityAnnouncementCreated: 'ঘোষণা প্রকাশিত হয়েছে।',

    sectionInspirations: 'আজকের অনুপ্রেরণা',
    sectionDailyAmal: 'আজকের আমল',

    duaPeriodDay: 'দিন',
    duaPeriodEvening: 'সন্ধ্যা',
    duaPeriodNight: 'রাত',
    duaPeriodAll: 'সব',

    duaHeaderDay: 'সকাল ও দৈনিক দোয়া',
    duaHeaderEvening: 'সন্ধ্যার আযকার',
    duaHeaderNight: 'রাতের দোয়া',
    duaHeaderAll: 'দোয়া সমূহ',

    duaSubtitleDay: 'ফজর থেকে মাগরিব পর্যন্ত',
    duaSubtitleEvening: 'আসর থেকে ইশা পর্যন্ত',
    duaSubtitleNight: 'ইশার পর থেকে ফজর পর্যন্ত',
    duaSubtitleAll: 'দোয়া সংকলন',

    duaSearchHint: 'দোয়া খুঁজুন...',
    duaOfTheDay: 'আজকের দোয়া',
    duaSectionMorning: 'সকালের আযকার',
    duaSectionDaily: 'দৈনিক দোয়া',
    duaNoFavorites: 'কোনো প্রিয় দোয়া নেই',
    duaNoFavoritesHint: 'হৃদয় আইকনে ট্যাপ করে প্রিয় দোয়া যোগ করুন',
    duaNoResults: 'কোনো দোয়া পাওয়া যায়নি',
    duaNoResultsHint: 'অন্য কিছু দিয়ে খোঁজার চেষ্টা করুন',
    duaEmptyPeriod: 'এই সময়ের কোনো দোয়া নেই',

    duaCategoryMorning: 'সকাল',
    duaCategoryEvening: 'সন্ধ্যা',
    duaCategoryNight: 'রাত',
    duaCategoryDaily: 'দৈনিক',
    duaCategoryRamadan: 'রমজান',
    duaCategoryTravel: 'সফর',
    duaCategoryForgiveness: 'ক্ষমা',

    duaDetailTranslation: 'বাংলা অর্থ',
    duaDetailPronunciation: 'উচ্চারণ',
    duaDetailCopied: 'কপি হয়েছে',

    duaCardTitle: 'আজকের দোয়া',

    asmaulHusnaTitle: 'আসমাউল হুসনা',
    asmaulHusnaOf: 'এর মধ্যে',

    settingsTitle: 'সেটিংস',
    settingsLanguage: 'ভাষা',
    settingsAccount: 'অ্যাকাউন্ট',
    settingsEmail: 'ইমেইল',
    settingsSession: 'সেশন',
    settingsLogout: 'লগআউট',
    settingsLogoutTitle: 'লগআউট করবেন?',
    settingsLogoutMessage: 'পুনরায় ব্যবহার করতে সাইন ইন করতে হবে।',
    settingsLogoutCancel: 'বাতিল',
    settingsLogoutConfirm: 'লগআউট',

    // Time Screen
    timePrayerTimes: 'নামাজের সময়সূচী',
    timeFetching: 'লোকেশন এবং সময়সূচী লোড হচ্ছে...',
    timeRetry: 'পুনরায় চেষ্টা করুন',
    timeNoData: 'কোনো সময়সূচী পাওয়া যায়নি।',
    timeIftarTitle: 'ইফতারের সময়\n(মাগরিব)',
    timeTableTitle: 'নামাজের সময়সূচী টেবিল',
    timeFajr: 'ফজর',
    timeSunrise: 'সূর্যোদয়',
    timeDhuhr: 'যোহর',
    timeAsr: 'আসর',
    timeMaghrib: 'মাগরিব',
    timeIsha: 'ইশা',
    timeNextPrayer: 'পরবর্তী নামাজ',
    timeNextPrayerIn: 'শুরু হতে',

    // Home Section Headers
    homeInspirations: 'আজকের অনুপ্রেরণা',
    homeDailyAmal: 'আজকের আমল',

    // Ayah Card
    ayahTitle: 'আজকের আয়াত',
    ayahText: 'শহরু রামাদানাল্লাজি উনজিলা ফিহিল কুরআন',
    ayahTranslation: '"রমজান মাসই হলো সেই মাস, যাতে নাযিল করা হয়েছে কুরআন, যা মানুষের জন্য হেদায়েত."',
    ayahReference: '— সূরা আল-বাকারা ২:১৮৫',

    // Salah Tracker
    salahTitle: 'দৈনিক নামাজ',
    salahWaiting: 'ফজরের ওয়াক্তের জন্য অপেক্ষা করা হচ্ছে...',
    salahDone: 'সম্পন্ন',

    // Sunnah Checklist
    checklistTitle: 'সুন্নাহ চেকলিস্ট',
    checklistSadaqah: 'আজ সদকা (দান) করুন',
    checklistMulk: 'ঘুমানোর আগে সূরা মুলক পাঠ করুন',
    checklistUmmah: 'উম্মাহর জন্য দোয়া করুন',

    // Quran Progress
    quranProgressTitle: 'কুরআন অগ্রগতি',
    quranTarget: 'লক্ষ্য',
    quranCurrent: 'বর্তমান',
    quranJuz: 'পারা',
    quranPage: 'পৃষ্ঠা',
    quranUpdateLog: 'আপডেট করুন',
    quranVerses: 'আয়াত',
    quranFailedLoad: 'সূরা লোড করতে ব্যর্থ হয়েছে',
    quranRetry: 'পুনরায় চেষ্টা করুন',
    quranUpdateTitle: 'কুরআন অগ্রগতি আপডেট করুন',
    quranCurrentJuzLabel: 'বর্তমান পারা',
    quranJuzHint: 'পারা নম্বর দিন (১-৩০)',
    quranCurrentPageLabel: 'বর্তমান পৃষ্ঠা',
    quranPageHint: 'পৃষ্ঠা নম্বর দিন (১-৬০৪)',
    quranJuzRequired: 'অনুগ্রহ করে পারা নম্বর দিন',
    quranJuzInvalid: 'পারা ১ থেকে ৩০ এর মধ্যে হতে হবে',
    quranPageRequired: 'অনুগ্রহ করে পৃষ্ঠা নম্বর দিন',
    quranPageInvalid: 'পৃষ্ঠা ১ থেকে ৬০৪ এর মধ্যে হতে হবে',
    quranSave: 'সংরক্ষণ করুন',
    quranUpdateSuccess: 'অগ্রগতি সফলভাবে আপডেট করা হয়েছে!',
    quranNoSurahs: 'কোনো সূরা পাওয়া যায়নি',
    quranAudioError: 'অডিও বাজাতে ব্যর্থ হয়েছে। ইন্টারনেট সংযোগ পরীক্ষা করুন।',

    // Notices
    noticeBoardTitle: 'লাইভ নোটিশ বোর্ড',
    noticeNew: 'নতুন',
    noticeComingSoon: 'শীঘ্রই আসছে!',
    noticeShareComingSoon: 'শেয়ার সুবিধা শীঘ্রই আসছে!',

    // Zakat
    zakatTitle: 'যাকাতুল ফিতর',
    zakatSubtitle: 'আপনার ফিতরা হিসাব করুন',
    zakatFamilyMembers: 'পরিবারের সদস্য সংখ্যা',
    zakatSelectType: 'দ্রব্যের ধরন নির্বাচন করুন',
    zakatTotalAmount: 'মোট পরিমাণ',
    zakatFitraWheat: 'আটা (সর্বনিম্ন)',
    zakatFitraBarley: 'যব',
    zakatFitraDates: 'খেজুর',
    zakatFitraRaisins: 'কিশমিশ',
    zakatFitraCheese: 'পনির / আজওয়া',
    zakatCalculateFitra: 'ফিতরা হিসাব করুন',
    zakatFitraDisclaimer: 'এই হারগুলো বাজার মূল্যের উপর ভিত্তি করে আনুমানিক।',

    duaCountSuffix: 'টি',

    // Header
    headerIftar: 'ইফতার',
    headerSuhoor: 'সাহরি শেষ',
    headerSuhoorEnds: 'সাহরি শেষ',
    headerIftarToday: 'আজ ইফতার',
    headerIftarIn: 'ইফতার হতে',
    headerSuhoorTime: 'সাহরির সময়',
    headerSuhoorIn: 'সাহরি হতে',
    headerIftarTime: 'ইফতারের সময়',
    headerEverydayTitle: 'দৈনিক ইবাদত',
    headerFetching: 'তারিখ লোড হচ্ছে...',
    headerLoading: 'লোড হচ্ছে',

    // Auth
    authWelcomeBack: 'স্বাগতম',
    authSignInSubtitle: 'আপনার রমজান প্ল্যানার সাইন ইন করুন',
    authEmailLabel: 'ইমেইল ঠিকানা',
    authEmailHint: 'you@example.com',
    authPasswordLabel: 'পাসওয়ার্ড',
    authLoginButton: 'লগ ইন',
    authNoAccount: "অ্যাকাউন্ট নেই? ",
    authCreateOne: 'নতুন তৈরি করুন',
    authEmailRequired: 'ইমেইল আবশ্যক।',
    authEmailInvalid: 'সঠিক ইমেইল দিন।',
    authPasswordRequired: 'পাসওয়ার্ড আবশ্যক।',
    authCreateAccount: 'অ্যাকাউন্ট তৈরি করুন',
    authRegisterSubtitle: 'ফলপ্রসূ রমজানের জন্য আমাদের সাথে যুক্ত হোন',
    authFullNameLabel: 'পুরো নাম',
    authFullNameHint: 'John Doe',
    authRegisterButton: 'সাইন আপ',
    authHaveAccount: 'অ্যাকাউন্ট আছে? ',
    authNameRequired: 'নাম আবশ্যক।',
    authPasswordTooShort: 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে।',

    // AI Features (Bengali)
    aiAssistantTitle: 'ইসলামিক অ্যাসিস্ট্যান্ট',
    aiAssistantHint: 'আপনার প্রশ্ন লিখুন...',
    aiAssistantTyping: 'টাইপ করছে...',
    aiDuaTitle: 'স্মার্ট দোয়া রিকমেন্ডার',
    aiDuaHint: 'আপনি কেমন অনুভব করছেন?',
    aiDuaFeelingAnxious: 'উদ্বিগ্ন',
    aiDuaFeelingGrateful: 'কৃতজ্ঞ',
    aiDuaFeelingSad: 'দুঃখিত',
    aiDuaGenerateBtn: 'দোয়া তৈরি করুন',
    aiZakatTitle: 'যাকাত অ্যাসিস্ট্যান্ট',
    aiZakatHint: 'আপনার উত্তর লিখুন...',
    aiZakatInitialMsg: 'আসসালামু আলাইকুম! আমি আপনার ইন্টারেক্টিভ জাকাত ক্যালকুলেটর। আমি ধাপে ধাপে কিছু প্রশ্ন করে আপনার জাকাত হিসাব করতে সাহায্য করব। প্রথমে বলুন, আপনার কি কোনো সোনা (Gold) আছে? থাকলে কত গ্রাম বা ভরি আছে?',
    aiZakatCalculating: 'হিসাব করা হচ্ছে...',
    aiZakatError: 'সংযোগ ত্রুটি',
    aiQuranPlanTitle: 'এআই দিয়ে কোরআন রুটিন',
    aiQuranPlanGenerating: 'আপনার জন্য একটি কাস্টম প্ল্যান তৈরি করা হচ্ছে...',
    aiQuranPlanResultTitle: 'আপনার কোরআন পড়ার রুটিন',
    aiQuranPlanNewBtn: 'নতুন প্ল্যান তৈরি করুন',
    aiQuranPlanDaysLeft: 'রমজানের বাকি দিন',
    aiQuranPlanMins: 'দৈনিক পড়ার সময় (মিনিট)',
    aiQuranPlanSpeed: 'পড়ার গতি',
    aiQuranPlanSpeedSlow: 'ধীর (Slow)',
    aiQuranPlanSpeedAverage: 'মাঝারি (Average)',
    aiQuranPlanSpeedFast: 'দ্রুত (Fast)',
    aiQuranPlanGenerateBtn: 'আমার প্ল্যান তৈরি করুন',
    aiSunnahTitle: 'দৈনিক এআই সুন্নাহ',
    aiSunnahGenerating: 'আপনার আজকের সুন্নাহ তৈরি হচ্ছে...',
    aiSunnahError: 'সুন্নাহ তৈরি করতে ব্যর্থ হয়েছে। আবার চেষ্টা করুন।',
    aiSunnahEmpty: 'আজকের জন্য কোনো সুন্নাহ নেই।',
    aiSunnahCompletedAll: 'মাশাআল্লাহ! আপনি আজকের সব সুন্নাহ সম্পন্ন করেছেন!',
    moreToolZakatAI: 'যাকাত (AI)',
    quranPlanFabAI: 'এআই প্ল্যান',

    // Nav
    navMore: 'আরো',

    // More
    moreTitle: 'ইসলামিক টুলস',
    moreTasbih: 'তাসবীহ',
    moreQibla: 'কিবলা',
    moreFasting: 'রোজা',
    moreCommunity: 'কমিউনিটি',
    moreHadith: 'হাদিস',
    moreIslamicCalendar: 'ইসলামিক ক্যালেন্ডার',
    moreStreaks: 'স্ট্রীক',
    moreCharity: 'সদকা',
    moreQuranPlan: 'কোরআন প্ল্যান',
    moreJournal: 'ডায়েরি',
    moreMosques: 'মসজিদ',
    moreSettings: 'সেটিংস',

    // Quran Plan
    quranPlanTitle: 'কোরআন পড়ার প্ল্যান',
    quranPlanRecent: 'সাম্প্রতিক কার্যকলাপ',
    quranPlanLogMore: 'আরো লগ',
    quranPlanLogToday: 'আজকের পড়া লগ করুন',
    quranPlanStartJourney: 'আপনার কোরআন যাত্রা শুরু করুন!',
    quranPlanLogReading: 'পড়া লগ করুন',
    quranPlanPagesRead: 'পড়া পৃষ্ঠা',
    quranPlanPagesHint: 'পৃষ্ঠা সংখ্যা লিখুন',
    quranPlanCancel: 'বাতিল',
    quranPlanSave: 'সংরক্ষণ',
    quranPlanSetTarget: 'পড়ার লক্ষ্য নির্ধারণ',
    quranPlanPagesPerDay: 'প্রতিদিনের পৃষ্ঠা',
    quranPlanPagesPerDayHint: 'যেমন: ৫',
    quranPlanTodayReading: 'আজকের পড়া',
    quranPlanTargetAchieved: 'দৈনিক লক্ষ্য অর্জিত!',
    quranPlanMonthlyProgress: 'মাসিক অগ্রগতি',
    quranPlanPagesReadStat: 'পড়া পৃষ্ঠা',
    quranPlanDaysCompleted: 'সম্পন্ন দিন',
    quranPlanDailyTarget: 'দৈনিক লক্ষ্য',
    quranPlanReadingFraction: '{read}/{target} পৃষ্ঠা',

    // Community
    communityNotifications: 'নোটিফিকেশন',
    communityNoNotifications: 'এখনো কোনো নোটিফিকেশন নেই',
    communityCompleted: 'সম্পন্ন',
    communityCancelled: 'বাতিল',
    communityAccountRequired: 'অ্যাকাউনٹ প্রয়োজন',
    communitySignInRegister: 'সাইন ইন / রেজিস্টার',
    communityAuthPrompt: '{action} করার জন্য আপনাকে একটি অ্যাকাউন্ট তৈরি বা সাইন ইন করতে হবে। এটি এক মিনিটেরও কম সময় নেয়!',

    // Event Detail
    eventDetailTitle: 'ইভেন্টের বিবরণ',
    eventDetailAbout: 'এই ইভেন্ট সম্পর্কে',
    eventDetailOrganizedBy: 'আয়োজক',
    eventDetailContact: 'যোগাযোগ',
    eventDetailRaised: 'সংগৃহীত',
    eventDetailGoal: 'লক্ষ্য',
    eventDetailContributeNow: 'এখনই দান করুন',
    eventDetailLike: 'পছন্দ',
    eventDetailSupport: 'সমর্থন',
    eventDetailComments: 'মন্তব্য',
    eventDetailAddComment: 'মন্তব্য লিখুন...',
    eventDetailNoComments: 'এখনো কোনো মন্তব্য নেই। প্রথম মন্তব্য করুন!',
    eventDetailPercentReached: 'লক্ষ্যের {percent}% পৌঁছেছে',
    eventDetailUnknownOrganizer: 'অজানা আয়োজক',
    eventDetailUser: 'ব্যবহারকারী',
    eventDetailTimeFormat: 'EEEE, MMMM d',
    eventDetailMainContentComments: 'মন্তব্য ({count})',

    // Journal
    journalTitle: 'ইসলামিক ডায়েরি',
    journalSubtitle: 'আপনার ইসলামিক ডায়েরি',
    journalWriteFirst: 'প্রথম এন্ট্রি লিখুন',
    journalTapToAdd: 'নতুন যোগ করতে + ট্যাপ করুন',
    journalEditEntry: 'এন্ট্রি সম্পাদনা',
    journalNewEntry: 'নতুন জার্নাল এন্ট্রি',
    journalTitleLabel: 'শিরোনাম',
    journalReflectionLabel: 'চিন্তা',
    journalTagsLabel: 'ট্যাগ',
    journalUpdate: 'আপডেট',
    journalSave: 'সংরক্ষণ',
    journalDelete: 'এন্ট্রি মুছুন',
    journalNoEntries: 'আপনার দিন নিয়ে চিন্তা করুন, কবুল দোয়া রেকর্ড করুন,\nলক্ষ্য নির্ধারণ করুন, এবং আপনার আধ্যাত্মিক যাত্রা ট্র্যাক করুন',

    // Tasbih
    tasbihTitle: 'তাসবীহ কাউন্টার',
    tasbihResetAllTitle: 'সব কাউন্টার রিসেট করবেন?',
    tasbihResetAllMessage: 'এটি সমস্ত জিকিরের সংখ্যা ০-তে রিসেট করবে।',
    tasbihCancel: 'বাতিল',
    tasbihReset: 'রিসেট',
    tasbihCompleted: 'সম্পন্ন!',
    tasbihRemaining: 'বাকি {count}',
    tasbihTodaySummary: 'আজ: মোট {total} · {completed}/{all} সম্পন্ন',
    tasbihCounterTitle: 'তাসবীহ কাউন্টার',
    tasbihCounterCompleted: 'সম্পন্ন!',
    tasbihCounterReset: 'রিসেট',
    tasbihCounterTapHint: 'গণনা করতে ট্যাপ করুন',

    // Fasting
    fastingTitle: 'নফল রোজা',
    fastingDescription: 'আপনার নফল রোজা ট্র্যাক করুন: সোম/বৃহস্পতি, আইয়ামে বিজ (১৩-১৪-১৫)',
    fastingCalendar: 'ক্যালেন্ডার',
    fastingToday: 'আজ',
    fastingMonday: 'সোমবার',
    fastingThursday: 'বৃহস্পতিবার',
    fastingWhiteDays: 'আইয়ামে বিজ',
    fastingFastKept: 'রোজা রাখা',
    fastingMissed: 'ভঙ্গ',
    fastingMarkMissed: 'ভঙ্গ চিহ্নিত',
    fastingMarkKept: 'রাখা চিহ্নিত',
    fastingThisMonth: 'এই মাস',
    fastingStreak: 'ধারা',
    fastingThisYear: 'এই বছর',
    fastingLegendKept: 'রোজা রাখা',
    fastingLegendMissed: 'ভঙ্গ',
    fastingLegendRecommended: 'সুপারিশকৃত',

    // Charity
    charityTitle: 'সদকার ট্র্যাকার',
    charityHistory: 'ইতিহাস',
    charityAdd: 'যোগ করুন',
    charityNoRecords: 'এখনো কোনো সদকার রেকর্ড নেই',
    charityAddFirst: 'আপনার প্রথম দান যোগ করুন',
    charityAddDonation: 'দান যোগ করুন',
    charityAmount: 'পরিমাণ (\$)',
    charityCategory: 'বিভাগ',
    charityNoteOptional: 'নোট (ঐচ্ছিক)',
    charitySave: 'সংরক্ষণ',
    charityThisMonth: 'এই মাস',
    charityAllTime: 'সর্বমোট',
    charityAvgDay: 'গড়/দিন',
    charityDailyAverage: 'দৈনিক গড়',

    // Streaks
    streakTitle: 'অভ্যাসের ধারা',
    streakYourStreaks: 'আপনার ধারা',
    streakSalah: 'নামাজ',
    streakSunnahChecklist: 'সুন্নাহ চেকলিস্ট',
    streakQuranReading: 'কোরআন পড়া',
    streakDayStreak: 'দিনের ধারা',
    streakStayConsistent: 'অবিচল থাকুন!',
    streakInfo: 'প্রতিদিন কাজ সম্পন্ন করলে ধারা আপডেট হয়। ধারাবাহিকতা বজায় রাখুন!',

    // Qibla
    qiblaTitle: 'কিবলা কম্পাস',
    qiblaFindingLocation: 'আপনার অবস্থান খুঁজছে...',
    qiblaCalibratePrompt: 'কম্পাস ক্যালিব্রেট করতে ফোনটি\nআটকরে নাড়ান',
    qiblaAlignPrompt: 'লাল সুই কিবলার দিকে সারিবদ্ধ করুন',
    qiblaLocation: 'অবস্থান: {lat}, {lng}',
    qiblaBearing: 'কিবলা: {dir}',
    qiblaFacing: 'কিবলামুখী!',

    // Mosque
    mosqueTitle: 'কাছের মসজিদ',
    mosqueFinding: 'কাছের মসজিদ খুঁজছে...',
    mosqueTryAgain: 'পুনরায় চেষ্টা করুন',
    mosqueNoFound: 'কাছের কোনো মসজিদ পাওয়া যায়নি',
    mosqueDirections: 'দিকনির্দেশ',

    // Islamic Calendar
    islamicCalendarTitle: 'ইসলামিক ক্যালেন্ডার',
    islamicCalendarNoEvents: 'এই মাসে কোনো ইভেন্ট নেই',

    // Ads
    adSkip: 'স্কিপ',
    adLabel: 'বিজ্ঞাপন',
    adBannerLabel: 'বিজ্ঞাপন',
    adAppName: 'রমজান প্ল্যানার',

    // Settings
    settingsContactInfo: 'যোগাযোগ',
    settingsSignInRegister: 'সাইন ইন / অ্যাকাউন্ট তৈরি',
    settingsLanguageLabel: 'অ্যাপের ভাষা',
    settingsGuest: 'অতিথি',
    settingsNotSignedIn: 'সাইন ইন করা হয়নি',
    settingsNoContact: 'কোনো যোগাযোগ নেই',
    settingsUser: 'ব্যবহারকারী',

    // Hadith
    hadithCardTitle: 'আজকের হাদিস',
    hadithNumber: 'হাদিস #{number}',

    // Time
    timeJummah: 'জুম্মা',

    // Misc
    cancel: 'বাতিল',
    authRememberMe: 'আমাকে মনে রাখুন',
    save: 'সংরক্ষণ',
    reset: 'রিসেট',
    completed: 'সম্পন্ন',
    urgent: 'জরুরি',
    important: 'গুরুত্বপূর্ণ',
    broadcast: 'সবার জন্য',
    justNow: 'এইমাত্র',
    donation: 'দান',
    tbd: 'নির্ধারিত হয়নি',
    event: 'ইভেন্ট',
    timeAgoDays: '{count} দিন আগে',
    timeAgoHours: '{count} ঘণ্টা আগে',
    timeAgoMinutes: '{count} মিনিট আগে',

    // Book Store
    bookStoreTitle: 'বইয়ের দোকান',
    bookStoreNoBooks: 'কোনো বই পাওয়া যায়নি',
    bookStoreOrder: 'অর্ডার',
    bookStoreBookTitle: 'বই',
    bookStoreName: 'পুরো নাম',
    bookStorePhone: 'ফোন নম্বর',
    bookStoreAddress: 'ঠিকানা',
    bookStoreOrderType: 'অর্ডারের ধরন',
    bookStoreDelivery: 'ডেলিভারি',
    bookStorePickup: 'পিকআপ',
    bookStorePlaceOrder: 'অর্ডার করুন',
    bookStoreOrderSuccess: 'অর্ডার সফল হয়েছে!',
    bookStoreQuantity: 'পরিমাণ',

    // Countdown
    countdownTitle: 'কাউন্টডাউন',
    countdownDays: 'দিন',
    countdownHours: 'ঘণ্টা',
    countdownMinutes: 'মিনিট',
    countdownSeconds: 'সেকেন্ড',

    // Quran LMS
    lmsTitle: 'কুরআন লেকচার',
    lmsNoLectures: 'কোনো লেকচার পাওয়া যায়নি',
    lmsWatch: 'দেখুন',
    lmsCompleted: 'সম্পন্ন',
    lmsProgress: 'সম্পন্ন চিহ্নিত করুন',
    lmsInProgress: 'চলমান',

    // Calendar PDF
    calendarPdfTitle: 'রমজান ক্যালেন্ডার',
    calendarPdfError: 'ত্রুটি',
    calendarPdfShare: 'পিডিএফ শেয়ার করুন',
    calendarPdfCity: 'শহর',
    calendarPdfLanguage: 'ভাষা',
    calendarPdfTimeFormat: 'সময় বিন্যাস',
    calendarPdfGenerating: 'তৈরি হচ্ছে...',
    calendarPdfGenerate: 'পিডিএফ তৈরি করুন',
    calendarPdfMethod: 'হিসাব পদ্ধতি',

    // Services
    servicesTitle: 'সেবাসমূহ',
    servicesSubtitle: 'আপনার রমজানকে সমৃদ্ধ করতে আমাদের সেবা অন্বেষণ করুন',
    servicesLearnMore: 'আরও জানুন',
  };
}
