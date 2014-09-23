# AppRate Cordova/Phonegap plugin #

This plugin provide the rate this app functionality into your Cordova/Phonegap application<br>

Need help for translations: [https://crowdin.net/project/apprate-cordovaphonegap-plugin](https://crowdin.net/project/apprate-cordovaphonegap-plugin)

Issues list and features requests [here](https://github.com/pushandplay/cordova-plugin-apprate/issues?state=open)



<img src="https://dl.dropboxusercontent.com/u/26238/Cordova/Plugins/AppRate/preview_iPad.png" width="100%" alt="Preview iPad"/>

## Supported platforms ##

+	iOS
+	Android
+	Blackberry 10 (not tested)

## Requirements ##

Phonegap / Cordova 3.0.0 or later

## Installation ##

+	Install from github repository:

		cordova plugins add https://github.com/pushandplay/cordova-plugin-apprate.git
			
+	Install from apache cordova plugins registry:

		cordova plugins add org.pushandplay.cordova.apprate
		
+	For installation from phonegap build add the following to your config.xml: 

		<gap:plugin name="org.pushandplay.cordova.apprate" />

## Customization and usage ##

#### Simple call ####

		navigator.apprate.setup(myPrefObj);
		navigator.apprate.promptForRating();
		
#### Available setup properties:	####

		{
			useLanguage: {String}			default locale (default: "en")
			displayAppName: {String}		Your app name (default: Your native app name)
			usesUntilPrompt: {Integer}		Show promt message after launches (default: 3)
			customLocale: {Object}			Custom locale object (default: not set)
			appStoreAppURL:
				ios: {String}				App url in AppStore (default: not set)
				android: {String}			App url in GooglePlay (default: not set)
				blackberry: {String}		(default: not set)
		}

##	Examples ##
### Example 1 ####
Detect user locale automatically and show message after each 3 launches

		var cfg = {
			appStoreAppURL: {
				ios: 'itms-apps://itunes.apple.com/ru/app/id736199575?l=en&mt=8'
			}
		};
		
		navigator.apprate.setup(cfg);
		navigator.apprate.promptForRating();
		
#### Example 2 ####
Set custom locale strings and show message after each 5 launches

		var cfg = {
			useLanguage: "ru",
			usesUntilPrompt: 5,
			appStoreAppURL: {
				ios: 'itms-apps://itunes.apple.com/ru/app/id736199575?l=en&mt=8'
			}
		};
		
		navigator.apprate.setup(cfg);
		navigator.apprate.promptForRating();

#### Example 3 ####
Set custom locale object and show message after each 10 launches

		var cfg = {
			usesUntilPrompt: 10,
			displayAppName: "My Super App",
			customLocale: {
				title: "Rate %@",
				message: "If you enjoy using %@, would you mind taking a moment to rate it? It won’t take more than a minute. Thanks for your support!",
				buttonLabels: ["No, Thanks", "Remind Me Later", "Rate It Now",]
			},
			appStoreAppURL: {
				ios: 'itms-apps://itunes.apple.com/ru/app/id736199575?l=en&mt=8'
			}
		};
		
		navigator.apprate.setup(cfg);
		navigator.apprate.promptForRating();
		
## Already included translations ##
ar, bn, ca, cs, da, de, el, en, es, fa, fr, he, hi, id, il, ja, ko, nl, no, pa, pl, pt, ru, sk, sl, sv, th, tr, uk, ur, vi, zh-TW
	

## Licence ##

The Apache 2.0 License