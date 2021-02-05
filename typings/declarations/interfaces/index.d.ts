declare module 'cordova-plugin-apprate' {
  type ReviewTypeAppStore = 'AppStoreReview';
  type ReviewTypeInApp = 'InAppReview';
  type ReviewTypeBrowser = 'InAppBrowser';
  type PromptType = 'AppRatingPrompt' | 'StoreRatingPrompt' | 'FeedbackPrompt';

  interface AppRatePreferences {
    useLanguage?: string;
    displayAppName?: string;
    promptAgainForEachNewVersion?: boolean;
    usesUntilPrompt?: number;
    reviewType?: {
      ios?: ReviewTypeAppStore | ReviewTypeInApp | ReviewTypeBrowser;
      android?: ReviewTypeInApp | ReviewTypeBrowser;
    };
    simpleMode?: boolean;
    showPromptForInAppReview?: boolean;
    callbacks?: CallbackPreferences;
    storeAppURL?: StoreAppURLPreferences;
    customLocale?: CustomLocale;
    openUrl?: (url: string) => void;
  }

  interface StoreAppURLPreferences {
    ios?: string;
    android?: string;
    blackberry?: string;
    windows8?: string;
    windows?: string;
  }

  interface CallbackPreferences {
    onButtonClicked?: (buttonIndex: number, buttonLabel: string, promptType: PromptType) => void;
    onRateDialogShow?: (rateCallback: (buttonIndex: number) => void) => void;
    handleNegativeFeedback?: () => void;
    done?: () => void;
  }

  interface CustomLocale {
    title?: string;
    message?: string;
    cancelButtonLabel?: string;
    laterButtonLabel?: string;
    rateButtonLabel?: string;
    yesButtonLabel?: string;
    noButtonLabel?: string;
    appRatePromptTitle?: string;
    feedbackPromptTitle?: string;
    appRatePromptMessage?: string;
    feedbackPromptMessage?: string;
  }

  interface Locales {
    addLocale(localeObject: LocaleOptions): LocaleOptions;

    getLocale(language: string, applicationTitle?: string, customLocale?: LocaleOptions): LocaleOptions;

    getLocalesNames(): Array<string>;
  }

  interface LocaleOptions extends CustomLocale {
    language: string;
  }
}
