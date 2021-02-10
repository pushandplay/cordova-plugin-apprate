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
  */

var exec = require('cordova/exec');
var Locales = require('./locales');
var Storage = require('./storage')

var AppRate = (function() {

  function noop(){}

  var localeObj;
  var isNativePromptAvailable = false;

  function AppRate() {}

  AppRate.initialized = false;
  AppRate.ready = new Promise(function(resolve, reject) {
    AppRate.readyResolve = resolve;
    AppRate.readyReject = reject;
  });

  var LOCAL_STORAGE_COUNTER = 'counter';

  var IS_IOS = /(iPhone|iPod|iPad)/i.test(navigator.userAgent.toLowerCase()) || (/Macintosh/.test(navigator.userAgent) && window.matchMedia('(any-pointer:coarse)').matches);
  var IS_ANDROID = /Android/i.test(navigator.userAgent.toLowerCase());
  var FLAG_NATIVE_CODE_SUPPORTED = IS_IOS || IS_ANDROID;

  var PREF_STORE_URL_PREFIX_IOS9 = "itms-apps://itunes.apple.com/app/viewContentsUserReviews/id";
  var PREF_STORE_URL_POSTFIX_IOS9 = "?action=write-review";
  var PREF_STORE_URL_FORMAT_IOS8 = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8&id=";

  var counter = {
    applicationVersion: void 0,
    countdown: 0
  };

  var preferences = {
    useLanguage: null,
    displayAppName: '',
    simpleMode: false,
    showPromptForInAppReview: true,
    promptAgainForEachNewVersion: true,
    usesUntilPrompt: 3,
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
    openUrl: function(url) {
      cordova.InAppBrowser.open(url, '_system', 'location=no');
    }
  };

  function promptForAppRatingWindowButtonClickHandler(buttonIndex) {
    var base = preferences.callbacks, currentBtn = null;
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
    var base = preferences.callbacks, currentBtn = null;
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
    var base = preferences.callbacks, currentBtn = null;
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
        if (counter.countdown <= preferences.usesUntilPrompt) {
          counter.countdown++;
        }
        break;
      case 'reset':
        counter.countdown = 0;
        break;
      case 'stop':
        counter.countdown = preferences.usesUntilPrompt + 1;
    }
    Storage.set(LOCAL_STORAGE_COUNTER, counter);
    return counter;
  }

  function showDialog(immediately) {
    updateCounter();
    if (counter.countdown === preferences.usesUntilPrompt || immediately) {
      localeObj = Locales.getLocale(preferences.useLanguage, preferences.displayAppName, preferences.customLocale);

      if (!preferences.showPromptForInAppReview && isNativePromptAvailable && preferences.reviewType &&
          ((IS_IOS && preferences.reviewType.ios === 'InAppReview') || (IS_ANDROID && preferences.reviewType.android === 'InAppReview'))) {
        updateCounter('stop');
        AppRate.navigateToAppStore();
      } else if (preferences.simpleMode) {
        navigator.notification.confirm(localeObj.message, promptForStoreRatingWindowButtonClickHandler, localeObj.title, [localeObj.cancelButtonLabel, localeObj.laterButtonLabel, localeObj.rateButtonLabel]);
      } else {
        navigator.notification.confirm(localeObj.appRatePromptMessage, promptForAppRatingWindowButtonClickHandler, localeObj.appRatePromptTitle, [localeObj.noButtonLabel, localeObj.yesButtonLabel]);
      }

      var base = preferences.callbacks;
      if (typeof base.onRateDialogShow === "function") {
        base.onRateDialogShow(promptForStoreRatingWindowButtonClickHandler);
      }
    }
    return AppRate;
  }

  function getAppVersion() {
    return new Promise(function(resolve, reject) {
      if (FLAG_NATIVE_CODE_SUPPORTED) {
        exec(resolve, reject, 'AppRate', 'getAppVersion', []);
      } else {
        resolve(counter.applicationVersion);
      }
    });
  }

  function getAppTitle() {
    return new Promise(function(resolve, reject) {
      if (FLAG_NATIVE_CODE_SUPPORTED) {
        exec(resolve, reject, 'AppRate', 'getAppTitle', []);
      } else {
        resolve(preferences.displayAppName);
      }
    });
  }

  function checkIsNativePromptAvailable() {
    return new Promise(function(resolve, reject) {
      if (FLAG_NATIVE_CODE_SUPPORTED) {
        exec(resolve, reject, 'AppRate', 'isNativePromptAvailable', []);
      } else {
        resolve(false);
      }
    });
  }

  function setPreferences(pref, prefObj) {
    if(!prefObj) {
      prefObj = preferences;
    }
    if (pref && typeof pref === 'object') {
      for (var key in pref) {
        if (pref.hasOwnProperty(key) && prefObj.hasOwnProperty(key)) {
          if (typeof pref[key] === 'object' && key !== 'customLocale') {
            setPreferences(pref[key], prefObj[key]);
          } else {
            prefObj[key] = pref[key];
          }
        }
      }
    }
  }

  AppRate.init = function() {
    var appTitlePromise = getAppTitle()
      .then(function(displayAppName) {
        preferences.displayAppName = displayAppName;
      })
      .catch(noop);

    var checkIsNativePromptAvailablePromise = checkIsNativePromptAvailable()
      .then(function(isNativePromptAvailableResult) {
        isNativePromptAvailable = isNativePromptAvailableResult;
      })
      .catch(function() {
        isNativePromptAvailable = false;
      });

    var storagePromise = Storage.get(LOCAL_STORAGE_COUNTER)
      .then(function(storedCounter) {
        counter = storedCounter || counter;
        return getAppVersion();
      })
      .then(function(applicationVersion) {
        if (counter.applicationVersion !== applicationVersion) {
          counter.applicationVersion = applicationVersion;
          if (preferences.promptAgainForEachNewVersion) {
            updateCounter('reset');
          }
        }
      })
      .catch(noop);
    var initPromise = Promise.all([
      checkIsNativePromptAvailablePromise,
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
  };

  AppRate.locales = Locales;

  AppRate.setPreferences = function(pref) {
    setPreferences(pref);
  };

  AppRate.getPreferences = function() {
    return preferences;
  };

  AppRate.promptForRating = function(immediately) {
    AppRate.ready.then(function() {
      if (immediately == null) {
        immediately = true;
      }

      // see also: https://cordova.apache.org/news/2017/11/20/migrate-from-cordova-globalization-plugin.html
      if (preferences.useLanguage === null && window.Intl && typeof window.Intl === 'object') {
        preferences.useLanguage = window.navigator.language;
      }

      showDialog(immediately);
    });
  };

  AppRate.navigateToAppStore = function() {
    var iOSVersion;
    var iOSStoreUrl;

    if (IS_IOS) {
      if (!preferences.reviewType || !preferences.reviewType.ios || preferences.reviewType.ios === 'AppStoreReview') {
        exec(null, null, 'AppRate', 'launchiOSReview', [preferences.storeAppURL.ios, false]);
      } else if (preferences.reviewType.ios === 'InAppReview') {
        exec(null, null, 'AppRate', 'launchiOSReview', [preferences.storeAppURL.ios, true]);
      } else {
        iOSVersion = navigator.userAgent.match(/OS\s+([\d\_]+)/i)[0].replace(/_/g, '.').replace('OS ', '').split('.');
        iOSVersion = parseInt(iOSVersion[0]) + (parseInt(iOSVersion[1]) || 0) / 10;
        if (iOSVersion < 9) {
          iOSStoreUrl = PREF_STORE_URL_FORMAT_IOS8 + preferences.storeAppURL.ios;
        } else {
          iOSStoreUrl = PREF_STORE_URL_PREFIX_IOS9 + preferences.storeAppURL.ios + PREF_STORE_URL_POSTFIX_IOS9;
        }
        preferences.openUrl(iOSStoreUrl);
      }
    } else if (IS_ANDROID) {
      if (isNativePromptAvailable && preferences.reviewType && preferences.reviewType.android === 'InAppReview') {
        exec(null, null, 'AppRate', 'launchReview', []);
      } else {
        preferences.openUrl(preferences.storeAppURL.android);
      }
    } else if (/(Windows|Edge)/i.test(navigator.userAgent.toLowerCase())) {
      Windows.Services.Store.StoreRequestHelper.sendRequestAsync(Windows.Services.Store.StoreContext.getDefault(), 16, "");
    } else if (/(BlackBerry)/i.test(navigator.userAgent.toLowerCase())) {
      preferences.openUrl(preferences.storeAppURL.blackberry);
    } else if (/(IEMobile|Windows Phone)/i.test(navigator.userAgent.toLowerCase())) {
      preferences.openUrl(preferences.storeAppURL.windows8);
    }
  };

  return AppRate;

})();

document.addEventListener("deviceready", function() {
  AppRate.init();
}, false)

module.exports = AppRate;
