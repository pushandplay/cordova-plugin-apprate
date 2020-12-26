# Cordova-Plugin-Apprate
<a href="https://badge.fury.io/js/cordova-plugin-apprate" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/js/cordova-plugin-apprate.svg" alt="NPM Version"></a>
<a href='https://www.npmjs.org/package/cordova-plugin-apprate' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://img.shields.io/npm/dt/cordova-plugin-apprate.svg?label=NPM+Downloads' border='0' alt='NPM Downloads' /></a>

A plugin to provide rate this app functionality into your cordova application

**PR's are greatly appreciated** 

## Supported platforms

- iOS
- Android
- Windows
- Blackberry

## Installation Prerequisites

Choose your preferred browser plugin which will be used to open the store and install it:
- https://github.com/EddyVerbruggen/cordova-plugin-safariviewcontroller
- https://github.com/apache/cordova-plugin-inappbrowser

You must implement the `openUrl` method for your chosen plugin. Below is an example that works for both.

```javascript
AppRate.setPreferences({
  openUrl: function(url) {
    var safariAvailable = false;

    if (window.SafariViewController) {
      SafariViewController.isAvailable(function(available) {
        safariAvailable = available;
      });
    }

    if (!safariAvailable) {
       window.open(url, '_blank', 'location=yes');
    } else {
      SafariViewController.show(
        {
          url: url,
          barColor: "#0000ff", // on iOS 10+ you can change the background color as well
          controlTintColor: "#00ffff", // on iOS 10+ you can override the default tintColor
          tintColor: "#00ffff", // should be set to same value as controlTintColor and will be a fallback on older ios
        },

        // this success handler will be invoked for the lifecycle events 'opened', 'loaded' and 'closed'
        function(result) {
          console.log(result.event)
        },

        function(msg) {
          console.log("Error: " + msg);
        }
      );
    }
  }
});
```

## Installation

- From cordova plugins registry: `cordova plugin add cordova-plugin-apprate`
- From github repository: `cordova plugin add https://github.com/pushandplay/cordova-plugin-apprate.git`
- For phonegap build add the following to your config.xml: `<gap:plugin name="cordova-plugin-apprate" />`

## Integrating Google Play Core

To set up Google Play Core version, you can use PLAY_CORE_VERSION parameter (with `1.+` value by default). It is useful in order to avoid conflicts with another plugins which use any other different version of Google Play Core.

## Customization and usage

- Note: During development the submit button will be disabled and cannot be pressed. This is expected behavior per Apple when the app has not been downloaded from the app store. Details here: https://github.com/pushandplay/cordova-plugin-apprate/issues/182
- Note: Using the in-app review for Android/iOS will not prompt the user, and the native review prompt will be _requested_ and not guaranteed to be shown

## Options / Preferences
These options are available to set via the `setPreferences` method. 

| Option | Type | Default | Description |
| :------ | :---- | :------- | :----------- |
| useLanguage | String | null | custom BCP 47 language tag |
| displayAppName | String | '' | custom application title |
| promptAgainForEachNewVersion | Boolean | true | show dialog again when application version will be updated |
| usesUntilPrompt | Integer | 3 | count of runs of application before dialog will be displayed |
| reviewType.ios | [Enum](#reviewtypeios-enum) | AppStoreReview | the type of review display to show the user on iOS |
| reviewType.android | [Enum](#reviewtypeandroid-enum) | InAppBrowser | the type of review display to show the user on Android |
| simpleMode | Boolean | false | enabling simplemode would display the rate dialog directly without the negative feedback filtering flow |
| showPromptForInAppReview | boolean | true | disabling would skip displaying a rate dialog if in app review is set and available  |
| callbacks.onButtonClicked | Function | null | call back function. called when user clicked on rate-dialog buttons |
| callbacks.onRateDialogShow | Function | null | call back function. called when rate-dialog showing |
| storeAppURL.ios | String | null | application id in AppStore |
| storeAppURL.android | String | null | application URL in GooglePlay |
| storeAppURL.windows | String | null | application URL in Windows Store |
| storeAppURL.blackberry | String | null | application URL in AppWorld |
| storeAppURL.windows8 | String | null | application URL in WindowsStore |
| customLocale | Object | null | custom locale object |

#### reviewType.ios [Enum]
- `InAppReview` - Write review directly in your application (iOS 10.3+), limited to 3 prompts per year. Will fallback to 'AppStoreReview' for other iOS versions
- `AppStoreReview` - Open the store within the app. Use this option as an alternative to inAppReview to avoid the rate action from [doing nothing](https://developer.apple.com/documentation/storekit/skstorereviewcontroller/2851536-requestreview)
- `InAppBrowser` - Open the store using the `openUrl` preference (defaults to InAppBrowser). Be advised that WKWebView might not open the app store links

#### reviewType.android [Enum]
- `InAppReview` - Write review directly in your application. Will fallback to `InAppBrowser` if not available
- `InAppBrowser` - Open the store using the `openUrl` preference (defaults to InAppBrowser)

### In App Reviews

The `InAppReview` review type will attempt to launch a native in-app review dialog (as opposed to opening the app store).
   
The native dialog is designed to maintain the privacy of the users and to prevent applications from harassing them with too many review requests. 
As such, the dialog might or might not appear, and we will not be able to know whether it appeared, or whether the user reviewed the app or not.  

Since we can't know if the dialog will be shown, and in order to comply to the requirements of Apple/Android, 
no custom prompt will be shown to the user before attempting to open the in-app review dialog.

Native in-app review can only be possible under certain conditions. If those conditions are not met, a fallback method will be used see information per platform.

Note: The `InAppReview` will only work on released versions. To test it our please refer to [this article](https://developer.android.com/guide/playcore/in-app-review/test)

## Examples

Makes sure all your calls to the plugin happen after the cordova `onDeviceReady` event has fired.

### Simple Setup and Call

Note: windows does not need an URL as this is done by the native code.

```javascript
AppRate.setPreferences({
  storeAppURL: {
      ios: '<my_app_id>',
      android: 'market://details?id=<package_name>',
      blackberry: 'appworld://content/[App Id]/',
      windows8: 'ms-windows-store:Review?name=<the Package Family Name of the application>'
  }
});

AppRate.promptForRating();
```

### Don't Call Rate Dialog Immediately

```javascript
AppRate.promptForRating(false);
```
If false is not present it will ignore `usesUntilPrompt`, `promptAgainForEachNewVersion`, and the button logic, it will prompt every time.

### Override Dialog Button Callback

```javascript
AppRate.setPreferences({
  callbacks: {
    onButtonClicked: function(buttonIndex) {
      console.log("onButtonClicked -> " + buttonIndex);
    }
  }
});
```

### Set Custom Language

```javascript
AppRate.setPreferences({
  useLanguage: 'ru'
});
```

### Set Custom Locale Object
Note: `%@` patterns in `title` and `message` will be automatically replaced with `preferences.displayAppName`

```javascript
AppRate.setPreferences({
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
    }
});
```

### Full Setup Using SafariViewController

```javascript
AppRate.setPreferences({
  displayAppName: 'My custom app title',
  usesUntilPrompt: 5,
  promptAgainForEachNewVersion: false,
  reviewType: {
    ios: 'AppStoreReview',
    android: 'InAppBrowser'
  },
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
      window.open('mailto:feedback@example.com', '_system');
    },
    onRateDialogShow: function(callback){
      callback(1) // cause immediate click on 'Rate Now' button
    },
    onButtonClicked: function(buttonIndex){
      console.log("onButtonClicked -> " + buttonIndex);
    }
  },
  openUrl: function(url) {
    var safariAvailable = false;

    if (window.SafariViewController) {
      SafariViewController.isAvailable(function(available) {
        safariAvailable = available;
      });
    }

    if (!safariAvailable) {
       window.open(url, '_blank', 'location=yes');
    } else {
      SafariViewController.show(
        {
          url: url,
          barColor: "#0000ff", // on iOS 10+ you can change the background color as well
          controlTintColor: "#00ffff", // on iOS 10+ you can override the default tintColor
          tintColor: "#00ffff", // should be set to same value as controlTintColor and will be a fallback on older ios
        },

        // this success handler will be invoked for the lifecycle events 'opened', 'loaded' and 'closed'
        function(result) {
          console.log(result.event)
        },

        function(msg) {
          console.log("Error: " + msg);
        }
      );
    }
  }
});

AppRate.promptForRating();
```

### Full Setup Using InAppBrowser

```javascript
AppRate.setPreferences({
  displayAppName: 'My custom app title',
  usesUntilPrompt: 5,
  promptAgainForEachNewVersion: false,
  reviewType: {
    ios: 'AppStoreReview',
    android: 'InAppBrowser'
  },
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
      window.open('mailto:feedback@example.com', '_system');
    },
    onRateDialogShow: function(callback){
      callback(1) // cause immediate click on 'Rate Now' button
    },
    onButtonClicked: function(buttonIndex){
      console.log("onButtonClicked -> " + buttonIndex);
    }
  }
});

AppRate.promptForRating();
```

### Access To Locales

```javascript
// Getting list of names for available locales
AppRate.locales.getLocalesNames();

// Getting locale object by name
AppRate.locales.getLocale('en');
```

### List of Translations
- [./www/locales.js](./www/locales.js)

# Credits

Currently maintained by [@westonganger](https://github.com/westonganger)

Created by [@pushandplay](https://github.com/pushandplay)
