# AppRate Cordova/Phonegap plugin #

This plugin provide the rate this app functionality into your Cordova/Phonegap application<br>

Issues list and features requests [here](https://github.com/pushandplay/cordova-plugin-apprate/issues?state=open)

[Donate with PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=MS8RQAS2NVVQW&lc=RU&item_name=github%2ecom&item_number=cordova%2dplugin%2dapprate&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)

<img src="https://dl.dropboxusercontent.com/u/26238/Cordova/Plugins/AppRate/preview_iPad.png" width="100%" alt="Preview iPad"/>

## Supported platforms ##

+	iOS
+	Android
+	Blackberry (experimental)
+	Windows8 (experimental)

## Requirements ##

Phonegap / Cordova 3.0.0 or later

## Installation ##

+	From github repository:

		cordova plugins add https://github.com/pushandplay/cordova-plugin-apprate.git
			
+	From apache cordova plugins registry:

		cordova plugins add org.pushandplay.cordova.apprate
		
+	From phonegap build add the following to your config.xml:

		<gap:plugin name="org.pushandplay.cordova.apprate" />

## Customization and usage ##

#### Note ####
All %@ patterns in customLocale object will be automatically replaced to your application title

#### Available preferences options ####

	useLanguage {String} null - custom BCP 47 language tag
	displayAppName {String} '' - custom application title
	promptAgainForEachNewVersion {Boolean} true - show dialog again when application version will be updated
	usesUntilPrompt {Integer} 3 - count of runs of application before dialog will be displayed
	storeAppURL.ios {String} null - application id in AppStore
	storeAppURL.android {String} null - application URL in GooglePlay
	storeAppURL.blackberry {String} null - application URL in AppWorld
	storeAppURL.windows8 {String} null - application URL in WindowsStore
	customLocale {Object} null - custom locale object

##	Examples ##

#### Simple setup and call ####

    AppRate.preferences.storeAppURL.ios = '<my_app_id>';
    AppRate.preferences.storeAppURL.android = 'market://details?id=<package_name>';
    AppRate.preferences.storeAppURL.blackberry = 'appworld://content/[App Id]/';
    AppRate.preferences.storeAppURL.windows8 = 'ms-windows-store:Review?name=<the Package Family Name of the application>';
    AppRate.promptForRating();

#### Override dialog button callback ####

	AppRate.preferences.storeAppURL.ios = '<my_app_id>';
	AppRate.preferences.storeAppURL.android = 'market://details?id=<package_name>';
	AppRate.onButtonClicked = function(buttonIndex) {
		console.log("onButtonClicked -> " + buttonIndex);
	};
	AppRate.promptForRating();
		
#### Set custom language ####

	AppRate.preferences.useLanguage = 'ru';
	AppRate.preferences.storeAppURL.ios = '<my_app_id>';
	AppRate.preferences.storeAppURL.android = 'market://details?id=<package_name>';
	AppRate.promptForRating();

#### Set custom Locale object ####

	var customLocale = {};
	customLocale.title = "Rate %@";
	customLocale.message = "If you enjoy using %@, would you mind taking a moment to rate it? It won’t take more than a minute. Thanks for your support!";
	customLocale.cancelButtonLabel = "No, Thanks";
	customLocale.laterButtonLabel = "Remind Me Later";
	customLocale.rateButtonLabel = "Rate It Now";

	AppRate.preferences.storeAppURL.ios = '<my_app_id>';
	AppRate.preferences.storeAppURL.android = 'market://details?id=<package_name>';
	AppRate.preferences.customLocale = customLocale;
	AppRate.promptForRating();

#### Full setup ####

	var customLocale = {};
	customLocale.title = "Rate %@";
	customLocale.message = "If you enjoy using %@, would you mind taking a moment to rate it? It won’t take more than a minute. Thanks for your support!";
	customLocale.cancelButtonLabel = "No, Thanks";
	customLocale.laterButtonLabel = "Remind Me Later";
	customLocale.rateButtonLabel = "Rate It Now";

	AppRate.preferences.storeAppURL.ios = '<my_app_id>';
	AppRate.preferences.storeAppURL.android = 'market://details?id=<package_name>';
	AppRate.preferences.customLocale = customLocale;
	AppRate.preferences.displayAppName = 'My custom app title';
	AppRate.preferences.usesUntilPrompt = 5;
	AppRate.preferences.promptAgainForEachNewVersion = false;
	AppRate.promptForRating();
		
## Already included translations ##
ar, bn, ca, cs, da, de, el, en, es, fa, fr, he, hi, id, il, ja, ko, nl, no, pa, pl, pt, ru, sk, sl, sv, th, tr, uk, ur, vi, zh-TW

You can add a new translation here: [https://crowdin.net/project/apprate-cordovaphonegap-plugin](https://crowdin.net/project/apprate-cordovaphonegap-plugin)
	

## Licence ##

The Apache 2.0 License
