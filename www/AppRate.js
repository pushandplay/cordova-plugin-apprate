/*
  *
  * Licensed to the Apache Software Foundation (ASF) under one
  * or more contributor license agreements. See the NOTICE file
  * distributed with this work for additional information
  * regarding copyright ownership. The ASF licenses this file
  * to you under the Apache License, Version 2.0 (the
  * "License"); you may not use this file except in compliance
  * with the License. You may obtain a copy of the License at
  *
  * http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing,
  * software distributed under the License is distributed on an
  * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  * KIND, either express or implied. See the License for the
  * specific language governing permissions and limitations
  * under the License.
  *
  */;
var exec = require('cordova/exec');
var Locales = require('./locales');
var Storage = require('./storage')

var AppRate = (function() {

  function noop(){}

  var localeObj;

  function AppRate() {}

  AppRate.initialized = false;
  AppRate.ready = new Promise(function (resolve, reject) {
    AppRate.readyResolve = resolve;
    AppRate.readyReject = reject;
  });

  var LOCAL_STORAGE_COUNTER = 'counter';

  var IS_IOS = /(iPhone|iPod|iPad)/i.test(navigator.userAgent.toLowerCase());
  var IS_ANDROID = /Android/i.test(navigator.userAgent.toLowerCase());
  var FLAG_NATIVE_CODE_SUPPORTED = IS_IOS || IS_ANDROID;

  var PREF_STORE_URL_PREFIX_IOS9 = "itms-apps://itunes.apple.com/app/viewContentsUserReviews/id";
  var PREF_STORE_URL_POSTFIX_IOS9 = "?action=write-review";
  var PREF_STORE_URL_FORMAT_IOS8 = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8&id=";

  var counter = {
    applicationVersion: void 0,
    countdown: 0
  };

  function promptForAppRatingWindowButtonClickHandler(buttonIndex) {
    var base = AppRate.preferences.callbacks, currentBtn = null;
    switch (buttonIndex) {
      case 0:
        updateCounter('reset');
        break;
      case 1:
        currentBtn = localeObj.noButtonLabel;
        if(typeof base.handleNegativeFeedback === "function") {
          navigator.notification.confirm(localeObj.feedbackPromptMessage, promptForFeedbackWindowButtonClickHandler, localeObj.feedbackPromptTitle, [localeObj.noButtonLabel, localeObj.yesButtonLabel]);
        }
        break;
      case 2:
        currentBtn = localeObj.yesButtonLabel;
        navigator.notification.confirm(localeObj.message, promptForStoreRatingWindowButtonClickHandler, localeObj.title, [localeObj.cancelButtonLabel, localeObj.laterButtonLabel, localeObj.rateButtonLabel])
        break;
    }
    return typeof base.onButtonClicked === "function" ? base.onButtonClicked(buttonIndex, currentBtn, "AppRatingPrompt") : function(){ };
  }

  function promptForStoreRatingWindowButtonClickHandler(buttonIndex) {
    var base = AppRate.preferences.callbacks, currentBtn = null;
    switch (buttonIndex) {
      case 0:
        updateCounter('reset');
        break;
      case 1:
        currentBtn = localeObj.cancelButtonLabel;
        updateCounter('stop');
        break;
      case 2:
        currentBtn = localeObj.laterButtonLabel;
        updateCounter('reset');
        break;
      case 3:
        currentBtn = localeObj.rateButtonLabel;
        updateCounter('stop');
        AppRate.navigateToAppStore();
        break;
    }
    //This is called only in case the user clicked on a button
    typeof base.onButtonClicked === "function" ? base.onButtonClicked(buttonIndex, currentBtn, "StoreRatingPrompt") : function(){ };
    //This one is called anyway once the process is done
    return typeof base.done === "function" ? base.done() : function(){ };
  }

  function promptForFeedbackWindowButtonClickHandler(buttonIndex) {
    var base = AppRate.preferences.callbacks, currentBtn = null;
    switch (buttonIndex) {
      case 1:
        currentBtn = localeObj.noButtonLabel;
        updateCounter('stop');
        break;
      case 2:
        currentBtn = localeObj.yesButtonLabel;
        updateCounter('stop');
        base.handleNegativeFeedback();
        break;
    }
    return typeof base.onButtonClicked === "function" ? base.onButtonClicked(buttonIndex, currentBtn, "FeedbackPrompt") : function(){ };
  }

  function updateCounter(action) {
    if (action == null) {
      action = 'increment';
    }
    switch (action) {
      case 'increment':
        if (counter.countdown <= AppRate.preferences.usesUntilPrompt) {
          counter.countdown++;
        }
        break;
      case 'reset':
        counter.countdown = 0;
        break;
      case 'stop':
        counter.countdown = AppRate.preferences.usesUntilPrompt + 1;
    }
    Storage.set(LOCAL_STORAGE_COUNTER, counter);
    return counter;
  }

  function showDialog(immediately) {
    updateCounter();
    if (counter.countdown === AppRate.preferences.usesUntilPrompt || immediately) {
      localeObj = Locales.getLocale(AppRate.preferences.useLanguage, AppRate.preferences.displayAppName, AppRate.preferences.customLocale);

      if (AppRate.preferences.isNativePromptAvailable && AppRate.preferences.reviewType) {
        if ((IS_IOS && AppRate.preferences.reviewType.ios === 'InAppReview')
        || (IS_ANDROID && AppRate.preferences.reviewType.android === 'InAppReview')) {
          AppRate.navigateToAppStore();
        }
      } else if(AppRate.preferences.simpleMode) {
        navigator.notification.confirm(localeObj.message, promptForStoreRatingWindowButtonClickHandler, localeObj.title, [localeObj.cancelButtonLabel, localeObj.laterButtonLabel, localeObj.rateButtonLabel]);
      } else {
        navigator.notification.confirm(localeObj.appRatePromptMessage, promptForAppRatingWindowButtonClickHandler, localeObj.appRatePromptTitle, [localeObj.noButtonLabel, localeObj.yesButtonLabel]);
      }

      var base = AppRate.preferences.callbacks;
      if (typeof base.onRateDialogShow === "function") {
        base.onRateDialogShow(promptForStoreRatingWindowButtonClickHandler);
      }
    }
    return AppRate;
  }

  function getAppVersion() {
    return new Promise(function (resolve, reject){
      if (FLAG_NATIVE_CODE_SUPPORTED) {
        exec(resolve, reject, 'AppRate', 'getAppVersion', []);
      } else {
        resolve(counter.applicationVersion);
      }
    });
  }

  function getAppTitle() {
    return new Promise(function (resolve, reject){
      if (FLAG_NATIVE_CODE_SUPPORTED) {
        exec(resolve, reject, 'AppRate', 'getAppTitle', []);
      } else {
        resolve(AppRate.preferences.displayAppName);
      }
    });
  }

  function isNativePromptAvailable() {
    return new Promise(function (resolve, reject){
      if (FLAG_NATIVE_CODE_SUPPORTED) {
        exec(resolve, reject, 'AppRate', 'isNativePromptAvailable', []);
      } else {
        resolve(false);
      }
    });
  }

  AppRate.init = function() {
    var appVersionPromise = getAppVersion()
      .then(function(applicationVersion) {
        if (counter.applicationVersion !== applicationVersion) {
          counter.applicationVersion = applicationVersion;
          if (AppRate.preferences.promptAgainForEachNewVersion) {
            updateCounter('reset');
          }
        }
      })
      .catch(noop);

    var appTitlePromise = getAppTitle()
      .then(function(displayAppName) {
        AppRate.preferences.displayAppName = displayAppName;
      })
      .catch(noop);

    var isNativePromptAvailablePromise = isNativePromptAvailable()
      .then(function(isNativePromptAvailable) {
        AppRate.preferences.isNativePromptAvailable = isNativePromptAvailable;
      })
      .catch(function () {
        AppRate.preferences.isNativePromptAvailable = false;
      });

    var storagePromise = Storage.get(LOCAL_STORAGE_COUNTER).then(function (storedCounter) {
      counter = storedCounter || counter
    });
    var initPromise = Promise.all([
      isNativePromptAvailablePromise,
      appVersionPromise,
      appTitlePromise,
      storagePromise
    ]);
    if (AppRate.initialized) {
      AppRate.ready = initPromise;
    } else {
      AppRate.initialized = true;
      initPromise
        .then(AppRate.readyResolve)
        .catch(AppRate.readyReject);
    }
    return this;
  };

  AppRate.locales = Locales;

  AppRate.preferences = {
    useLanguage: null,
    displayAppName: '',
    simpleMode: false,
    promptAgainForEachNewVersion: true,
    usesUntilPrompt: 3,
    isNativePromptAvailable: false,
    reviewType: {
      ios: 'AppStoreReview',
      android: 'InAppBrowser'
    },
    callbacks: {
      onButtonClicked: null,
      onRateDialogShow: null,
      handleNegativeFeedback: null,
      done: null
    },
    storeAppURL: {
      ios: null,
      android: null,
      blackberry: null,
      windows8: null,
      windows: null
    },
    customLocale: null,
    openUrl: function (url) {
        cordova.InAppBrowser.open(url, '_system', 'location=no');
    }
  };

  AppRate.promptForRating = function(immediately) {
    AppRate.ready.then(function() {
      if (immediately == null) {
        immediately = true;
      }

      // see also: https://cordova.apache.org/news/2017/11/20/migrate-from-cordova-globalization-plugin.html
      if (AppRate.preferences.useLanguage === null && window.Intl && typeof window.Intl === 'object') {
        AppRate.preferences.useLanguage = window.navigator.language;
      }

      showDialog(immediately);
    });
    return this;
  };

  AppRate.navigateToAppStore = function() {
    var iOSVersion;
    var iOSStoreUrl;

    if (IS_IOS) {
      if (!this.preferences.reviewType || !this.preferences.reviewType.ios || this.preferences.reviewType.ios === 'AppStoreReview') {
        exec(null, null, 'AppRate', 'launchiOSReview', [this.preferences.storeAppURL.ios, false]);
      } else if (this.preferences.reviewType.ios === 'InAppReview') {
        exec(null, null, 'AppRate', 'launchiOSReview', [this.preferences.storeAppURL.ios, true]);
      } else {
        iOSVersion = navigator.userAgent.match(/OS\s+([\d\_]+)/i)[0].replace(/_/g, '.').replace('OS ', '').split('.');
        iOSVersion = parseInt(iOSVersion[0]) + (parseInt(iOSVersion[1]) || 0) / 10;
        if (iOSVersion < 9) {
          iOSStoreUrl = PREF_STORE_URL_FORMAT_IOS8 + this.preferences.storeAppURL.ios;
        } else {
          iOSStoreUrl = PREF_STORE_URL_PREFIX_IOS9 + this.preferences.storeAppURL.ios + PREF_STORE_URL_POSTFIX_IOS9;
        }
        AppRate.preferences.openUrl(iOSStoreUrl);
      }
    } else if (IS_ANDROID) {
      if (this.preferences.reviewType && this.preferences.reviewType.android === 'InAppReview') {
        exec(null, null, 'AppRate', 'launchReview', []);
      } else {
        AppRate.preferences.openUrl(this.preferences.storeAppURL.android);
      }
    } else if (/(Windows|Edge)/i.test(navigator.userAgent.toLowerCase())) {
      Windows.Services.Store.StoreRequestHelper.sendRequestAsync(Windows.Services.Store.StoreContext.getDefault(), 16, "");
    } else if (/(BlackBerry)/i.test(navigator.userAgent.toLowerCase())) {
      AppRate.preferences.openUrl(this.preferences.storeAppURL.blackberry);
    } else if (/(IEMobile|Windows Phone)/i.test(navigator.userAgent.toLowerCase())) {
      AppRate.preferences.openUrl(this.preferences.storeAppURL.windows8);
    }
    return this;
  };

  return AppRate;

})();

document.addEventListener("deviceready", function() {
  AppRate.init();
}, false)

module.exports = AppRate;
