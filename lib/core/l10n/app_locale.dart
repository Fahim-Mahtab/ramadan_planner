import 'package:flutter_localization/flutter_localization.dart';

class AppLocale {
  // ── Helper ────────────────────────────────────────────────────────────────
  static String format(String key) {
    final code =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
    if (code == 'en') {
      return eN[key] ?? key;
    }
    return bN[key] ?? key;
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
  static const communityAdmin = 'communityAdmin';
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
  static const communityApprove = 'communityApprove';
  static const communityReject = 'communityReject';
  static const communityReschedule = 'communityReschedule';
  static const communityNoApprovedEvents = 'communityNoApprovedEvents';
  static const communityDonationTransparency = 'communityDonationTransparency';
  static const communityDonationCollected = 'communityDonationCollected';
  static const communityDonationSpent = 'communityDonationSpent';
  static const communityDonationRemaining = 'communityDonationRemaining';
  static const communityAdminAnnouncements = 'communityAdminAnnouncements';
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
  static const settingsAdmin = 'settingsAdmin';
  static const settingsAdminNotices = 'settingsAdminNotices';
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

  // ── English strings ────────────────────────────────────────────────────────
  static const Map<String, dynamic> eN = {
    navHome: 'Home',
    navQuran: 'Quran',
    navTimes: 'Times',
    navDua: 'Dua',
    navSettings: 'Settings',
    navCommunity: 'Community',

    communityTitle: 'Mosque Community',
    communityFeed: 'Feed',
    communityCalendar: 'Calendar',
    communityQA: 'Q&A',
    communityAdmin: 'Admin',
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
    communityApprove: 'Approve',
    communityReject: 'Reject',
    communityReschedule: 'Reschedule',
    communityNoApprovedEvents: 'No approved events yet.',
    communityDonationTransparency: 'Donation Transparency',
    communityDonationCollected: 'Collected',
    communityDonationSpent: 'Spent',
    communityDonationRemaining: 'Remaining',
    communityAdminAnnouncements: 'Announcement Management',
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
    settingsAdmin: 'Admin Tools',
    settingsAdminNotices: 'App Publisher (Notices)',
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
  };

  // ── Bengali strings ────────────────────────────────────────────────────────
  static const Map<String, dynamic> bN = {
    navHome: 'হোম',
    navQuran: 'কুরআন',
    navTimes: 'নামাজ',
    navDua: 'দোয়া',
    navSettings: 'সেটিংস',
    navCommunity: 'কমিউনিটি',

    communityTitle: 'মসজিদ কমিউনিটি',
    communityFeed: 'ফিড',
    communityCalendar: 'ক্যালেন্ডার',
    communityQA: 'প্রশ্ন ও উত্তর',
    communityAdmin: 'অ্যাডমিন',
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
    communityApprove: 'অনুমোদন',
    communityReject: 'প্রত্যাখ্যান',
    communityReschedule: 'পুনঃনির্ধারণ',
    communityNoApprovedEvents: 'এখনও অনুমোদিত ইভেন্ট নেই।',
    communityDonationTransparency: 'দান স্বচ্ছতা',
    communityDonationCollected: 'সংগৃহীত',
    communityDonationSpent: 'ব্যয়',
    communityDonationRemaining: 'অবশিষ্ট',
    communityAdminAnnouncements: 'ঘোষণা ব্যবস্থাপনা',
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
    settingsAdmin: 'অ্যাডমিন টুলস',
    settingsAdminNotices: 'অ্যাপ পাবলিশার (নোটিস)',
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
    ayahTranslation: '"রমজান মাসই হলো সেই মাস, যাতে নাযিল করা হয়েছে কুরআন, যা মানুষের জন্য হেদায়েত।"',
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
  };
}
