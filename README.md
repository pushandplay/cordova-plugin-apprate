# AppRate Phonegap plugin #

Cross-platform AppRate plugin for Cordova / PhoneGap.<br>
Follows the [Cordova Plugin spec](http://docs.phonegap.com/en/3.0.0rc1/guide_plugins_plugin_spec.md.html#Plugin%20Specification), so that it works with [Plugman](https://github.com/apache/cordova-plugman).<br>
This plugin leverages Cordova/PhoneGap's [require/define functionality used for plugins](http://simonmacdonald.blogspot.ca/2012/08/so-you-wanna-write-phonegap-200-android.html).<br>

<img src="https://dl.dropboxusercontent.com/u/26238/Cordova/Plugins/AppRate/Photo%20Aug%2017%2C%201%2001%2047%20PM.jpg" alt="Preview""/>

## Supported platforms ##

+	iOS
+	Android
+	Blackberry 10 (not tested)

## Requirements ##

Phonegap / Cordova 3.0.0 or later

## Installation ##

+	Install Cordova / PhoneGap Notification plugin (only dialogs, for display confirm dialog) <code>sudo cordova plugins add https://git-wip-us.apache.org/repos/asf/cordova-plugin-dialogs.git</code>
+	Install Cordova / PhoneGap Globalization plugin (for localization support) <code>sudo cordova plugins add https://git-wip-us.apache.org/repos/asf/cordova-plugin-globalization.git</code>
+	If need iOS5 support - install InAppBrowser plugin <code>sudo cordova plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-inappbrowser.git</code>
+	Install AppRate plugin <code>sudo cordova plugins add https://github.com/pushandplay/cordova-plugin-apprate.git</code>

## Customization ##

+	Go to <code>plugins/org.pushandplay.cordova.apprate/www</code> folder in root of your project
+	Specify app ids in preferences.js or preferences.coffee (need compile to js)
+	Add your useLanguage to <code>locales.js</code> or <code>locales.coffee</code> (need compile to js)

## Usage ##

+	Set in plugin preferences variable "promptAtLaunch" to true and plugin run with your app staring and automatically check when user rated your app or no
+	Call manually with code <code>navigator.apprate.promptForRating();</code>

## Licence ##

The MIT License

Copyright (c) 2013 pushandplay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
