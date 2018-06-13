# Cordova-Plugin-Apprate

A plugin to provide rate this app functionality into your cordova application

**PR's are greatly appreciated** 

## Supported platforms

- iOS
- Android
- Windows
- Blackberry

## Installation

- From cordova plugins registry: `cordova plugin add cordova-plugin-apprate`
- From github repository: `cordova plugin add https://github.com/pushandplay/cordova-plugin-apprate.git`
- For phonegap build add the following to your config.xml: `<gap:plugin name="cordova-plugin-apprate" />`

## Customization and usage

## Options / Preferences
These options are available on the `AppRate.preferences` object. 

| Option | Type | Default | Description |
| :------ | :---- | :------- | :----------- |
| useLanguage | String | null | custom BCP 47 language tag |
| displayAppName | String | '' | custom application title |
| promptAgainForEachNewVersion | Boolean | true | show dialog again when application version will be updated |
| usesUntilPrompt | Integer | 3 | count of runs of application before dialog will be displayed |
| inAppReview | Boolean | true | iOS Only. Write review directly in your application (iOS 10.3+), limit of 3 prompts per year. Fallback to opening the store within the app for other iOS versions. Use false to use in app browser. |
| simpleMode | Boolean | false | enabling simplemode would display the rate dialog directly without the negative feedback filtering flow|
| callbacks.onButtonClicked | Function | null | call back function. called when user clicked on rate-dialog buttons |
| callbacks.onRateDialogShow | Function | null | call back function. called when rate-dialog showing |
| storeAppURL.ios | String | null | application id in AppStore |
| storeAppURL.android | String | null | application URL in GooglePlay |
| storeAppURL.windows | String | null | application URL in Windows Store |
| storeAppURL.blackberry | String | null | application URL in AppWorld |
| storeAppURL.windows8 | String | null | application URL in WindowsStore |
| customLocale | Object | null | custom locale object |

## Examples

Makes sure all your calls to the plugin happen after the cordova `onDeviceReady` event has fired.

### Simple setup and call

```javascript
AppRate.preferences.storeAppURL = {
  ios: '<my_app_id>',
  android: 'market://details?id=<package_name>',
  windows: 'ms-windows-store://pdp/?ProductId=<the apps Store ID>',
  blackberry: 'appworld://content/[App Id]/',
  windows8: 'ms-windows-store:Review?name=<the Package Family Name of the application>'
};

AppRate.promptForRating();
```

### Don't Call rate dialog immediately

```javascript
AppRate.promptForRating(false);
```
If false is not present it will ignore usesUntilPrompt, promptAgainForEachNewVersion, and button logic, it will prompt every time.

### Override dialog button callback

```javascript
AppRate.preferences.callbacks.onButtonClicked = function(buttonIndex) {
  console.log("onButtonClicked -> " + buttonIndex);
};
```

### Set custom language

```javascript
AppRate.preferences.useLanguage = 'ru';
```

### Set custom Locale object
Note: `%@` patterns in `title` and `message` will be automatically replaced with `AppRate.preferences.displayAppName`

```javascript
AppRate.preferences.customLocale = {
  title: "Would you mind rating %@?",
  message: "It won’t take more than a minute and helps to promote our app. Thanks for your support!",
  cancelButtonLabel: "No, Thanks",
  laterButtonLabel: "Remind Me Later",
  rateButtonLabel: "Rate It Now",
  yesButtonLabel: "Yes!",
  noButtonLabel: "Not really",
  appRatePromptTitle: 'Do you like using %@',
  feedbackPromptTitle: 'Mind giving us some feedback?',
};
```

### Full setup

```javascript
AppRate.preferences = {
  displayAppName: 'My custom app title',
  usesUntilPrompt: 5,
  promptAgainForEachNewVersion: false,
  inAppReview: true,
  storeAppURL: {
    ios: '<my_app_id>',
    android: 'market://details?id=<package_name>',
    windows: 'ms-windows-store://pdp/?ProductId=<the apps Store ID>',
    blackberry: 'appworld://content/[App Id]/',
    windows8: 'ms-windows-store:Review?name=<the Package Family Name of the application>'
  },
  customLocale: {
    title: "Would you mind rating %@?",
    message: "It won’t take more than a minute and helps to promote our app. Thanks for your support!",
    cancelButtonLabel: "No, Thanks",
    laterButtonLabel: "Remind Me Later",
    rateButtonLabel: "Rate It Now",
    yesButtonLabel: "Yes!",
    noButtonLabel: "Not really",
    appRatePromptTitle: 'Do you like using %@',
    feedbackPromptTitle: 'Mind giving us some feedback?',
  },
  callbacks: {
    handleNegativeFeedback: function(){
      window.open('mailto:feedback@example.com','_system');
    },
    onRateDialogShow: function(callback){
      callback(1) // cause immediate click on 'Rate Now' button
    },
    onButtonClicked: function(buttonIndex){
      console.log("onButtonClicked -> " + buttonIndex);
    }
  }
};

AppRate.promptForRating();
```

### Access to locales

```javascript
// Getting list of names for available locales
AppRate.locales.getLocalesNames();

// Getting locale object by name
AppRate.locales.getLocale('en');
```

### List of translations
https://github.com/pushandplay/cordova-plugin-apprate/blob/master/www/locales.js

# Credits

Currently maintained by [@westonganger](https://github.com/westonganger)

Created by [@pushandplay](https://github.com/pushandplay) - [Donate with PayPal](https://www.paypal.me/pushandplay/10)
