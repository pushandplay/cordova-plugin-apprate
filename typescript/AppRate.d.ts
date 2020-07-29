/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */
declare module "cordova-plugin-apprate" {


  export class AppRate {
    static locales: Locales;
    static preferences: AppRatePreferences;

    static init(): AppRate;
    static promptForRating(immediately?: boolean): AppRate;
    static navigateToAppStore(): AppRate;
  }

  export class AppRatePreferences {
    useLanguage: string;
    displayAppName: string;
    promptAgainForEachNewVersion: boolean;
    usesUntilPrompt: number;
    inAppReview: boolean;
    simpleMode: boolean;
    callbacks: CallbackPreferences;
    storeAppURL: StoreAppURLPreferences;
    customLocale: CustomLocale;
    openUrl: (url: string) => void;
  }

  export class StoreAppURLPreferences {
    ios: string;
    android: string;
    blackberry: string;
    windows8: string;
    windows: string;
  }

  export class CallbackPreferences {
    onButtonClicked: (buttonIndex: number) => void;
    onRateDialogShow: (rateCallback: (buttonIndex: number) => void) => void;
    handleNegativeFeedback: () => void;
    done: () => void;
  }

  export class CustomLocale {
    title: string;
    message: string;
    cancelButtonLabel: string;
    laterButtonLabel: string;
    rateButtonLabel: string;
    yesButtonLabel: string;
    noButtonLabel: string;
    appRatePromptTitle: string;
    feedbackPromptTitle: string;
    appRatePromptMessage: string;
    feedbackPromptMessage: string;
  }

  export class Locales {
    addLocale(localeObject: Locale): Locale;
    getLocale(language: string, applicationTitle?: string): Locale;
    getLocalesNames(): Array<string>;
  }

  export class Locale {
    constructor(localeOptions: LocaleOptions);
  }

  export class LocaleOptions {
    language: string
    title: string;
    message: string;
    cancelButtonLabel: string;
    laterButtonLabel: string;
    rateButtonLabel: string;
    yesButtonLabel: string;
    noButtonLabel: string;
    appRatePromptTitle: string;
    feedbackPromptTitle: string;
    appRatePromptMessage: string;
    feedbackPromptMessage: string;
  }
}
