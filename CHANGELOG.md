# Changelog

- Unreleased
  - Nothing yet
  
- 1.7.2
  - [PR #302](https://github.com/pushandplay/cordova-plugin-apprate/pull/301) - Fix bug in setPreferences
  - [PR #301](https://github.com/pushandplay/cordova-plugin-apprate/pull/301) - Typescript fixes
  - [PR #300](https://github.com/pushandplay/cordova-plugin-apprate/pull/300) - Fix iPad device recognition on iOS 13+
 
- 1.7.1
  - [PR #293](https://github.com/pushandplay/cordova-plugin-apprate/pull/293) - Fix handling of `customLocale` object in `setPreferences`
  - [PR #289](https://github.com/pushandplay/cordova-plugin-apprate/pull/289) - Bugfix to ensure `getAppVersion()` runs after localstorage has been initialized

- 1.7.0
  - [PR #286](https://github.com/pushandplay/cordova-plugin-apprate/pull/286) - Added new method `setPreferences` which does not override any default/existing settings. This is now the preferred way to set the plugins preferences.
  - [PR #286](https://github.com/pushandplay/cordova-plugin-apprate/pull/286) - Added option `showPromptForInAppReview`
  - [PR #286](https://github.com/pushandplay/cordova-plugin-apprate/pull/286) - Typescript definitions updated to latest syntax

- 1.6.1
  - [#287](https://github.com/pushandplay/cordova-plugin-apprate/issues/287) - Fix bug with `reviewType` setting

- 1.6.0
  - [PR #280](https://github.com/pushandplay/cordova-plugin-apprate/pull/280) - Removed iOS option `inAppReview` in favor of new option `reviewType`. Please update your app according to the updated documentation
  - [PR #280](https://github.com/pushandplay/cordova-plugin-apprate/pull/280) - Fixed race condition on `deviceready` events causing the module to not be fully initialized
  - [PR #281](https://github.com/pushandplay/cordova-plugin-apprate/pull/281) - feature: Android in-app review
 
- 1.5.0
  - [PR #253](https://github.com/pushandplay/cordova-plugin-apprate/pull/253) - Remove iOS rating counter in favor of native approach
  - [PR #252](https://github.com/pushandplay/cordova-plugin-apprate/pull/252) - Postpone initial AppRate.init() until `deviceready`
  - [PR #239](https://github.com/pushandplay/cordova-plugin-apprate/pull/239) - Remove inappbrowser dependency adding support to choose between inappbrowser and safariviewcontroller 
  - [PR #244](https://github.com/pushandplay/cordova-plugin-apprate/pull/244) - Use ES5 var instead of ES6 const for better browser compatibility
  - [PR #231](https://github.com/pushandplay/cordova-plugin-apprate/pull/231) - Displaying store view page before it loads for improved UX
  - [PR #228](https://github.com/pushandplay/cordova-plugin-apprate/pull/228) - Add native support for windows platform rating
  - [PR #220](https://github.com/pushandplay/cordova-plugin-apprate/pull/220) - Remove dependency on deprecated cordova-plugin-globalization in favor of browser `Intl` api
  - Various language fixes and improvements
  - [View All Merged PR's](https://github.com/pushandplay/cordova-plugin-apprate/compare/v1.4.0...master)

- 1.4.0
  - [Merged PR's](https://github.com/pushandplay/cordova-plugin-apprate/pulls?utf8=%E2%9C%93&q=is%3Apr+is%3Aclosed+merged%3A2017-06-24..2018-06-13)
  - [PR #211](https://github.com/pushandplay/cordova-plugin-apprate/pull/211) - Use NativeStorage for persistance across installs
  - Breaking Change - Instead of directly asking our users to Rate our app, we now handle this flow much better. The first popup will be "Do you like using appName?" If the user says 'Yes' then we ask the user if they would like take a moment and rate our app. If the user says 'NO', We ask the user another question: "Would you mind providing us feedback?" If the user says yes, then we can run a custom callback to handle this such as sending an email. To revert to previous behaviour you can use `simpleMode: true`
  - iOS 9+ now redirects directly to write review
  - iOS 10.3+ now supports In-App Reviews. One limitation to note is you can only prompt the user 3 times per year before it must fallback to the old open review in store. The preference option to disable this feature is called `inAppReview` and defaults to true, this option was previously named `openStoreInApp` and defaulted to false.

- 1.3.0
  - Added a general done callbacks called once we have completed the job, not showing or showing the popup
  - Fix %@ with customLocale
  - Fix bugs with callbacks
  - Fix deep links on ios 9+
  - Locales updates

- 1.2.1
  - Align the version in the package.json and the plugin.xml

- 1.2.0
  - Remove coffeescript to remove barrier of entry to contributions
  - Remove docs generation, just use the readme instead
  - Improve readme
  - Add Windows support from PR #120
  - Fix JSON parse for Android 2.x as per PR #73
  - Remove InAppBrowser dependency
  - Add/Improve Locales

- 1.1.12
  - Bump version to be higher than the previous `cordova-plugin-apprate` on the NPM registry
  - Clean up readme

- 1.1.9
  - Update id to `cordova-plugin-apprate` and update dependencies
  - Add finnish locale
