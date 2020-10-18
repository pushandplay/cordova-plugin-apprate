/// <reference path="./interfaces/index.d.ts" />

declare module 'cordova-plugin-apprate' {

  export default class AppRate {

    /**
     * Available Locales
     */
    static locales: Locales;

    /**
     * Initialize the AppRate Plugin - automatically called on DeviceReady()
     **/
    static init(): void;

    static setPreferences(preferences: AppRatePreferences): void;

    static getPreferences(): AppRatePreferences;

    static promptForRating(immediately?: boolean): void;

    static navigateToAppStore(): void;

  }

}
