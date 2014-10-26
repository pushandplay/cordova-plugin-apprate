`/*
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
 */`

Locales = require './locales'
exec = require 'cordova/exec'

# AppRate plugin base class
#
# @example Simple setup and call
#   AppRate.preferences.storeAppURL.ios = '<my_app_id>';
#   AppRate.preferences.storeAppURL.android = 'market://details?id=<package_name>';
#   AppRate.promptForRating();
#
# @example Override dialog button callback
#   AppRate.preferences.storeAppURL.ios = '<my_app_id>';
#   AppRate.preferences.storeAppURL.android = 'market://details?id=<package_name>';
#   AppRate.onButtonClicked = function(buttonIndex) {
#     console.log("onButtonClicked -> " + buttonIndex);
#   };
#   AppRate.promptForRating();
#
# @example Set custom language
#   AppRate.preferences.useLanguage = 'ru';
#   AppRate.preferences.storeAppURL.ios = '<my_app_id>';
#   AppRate.preferences.storeAppURL.android = 'market://details?id=<package_name>';
#   AppRate.promptForRating();
#
# @example Set custom Locale object
#   var customLocale = {};
#   customLocale.title = "Rate %@";
#   customLocale.message = "If you enjoy using %@, would you mind taking a moment to rate it? It won’t take more than a minute. Thanks for your support!";
#   customLocale.cancelButtonLabel = "No, Thanks";
#   customLocale.laterButtonLabel = "Remind Me Later";
#   customLocale.rateButtonLabel = "Rate It Now";
#
#   AppRate.preferences.storeAppURL.ios = '<my_app_id>';
#   AppRate.preferences.storeAppURL.android = 'market://details?id=<package_name>';
#   AppRate.preferences.customLocale = customLocale;
#   AppRate.promptForRating();
#
# @example Full setup
#   var customLocale = {};
#   customLocale.title = "Rate %@";
#   customLocale.message = "If you enjoy using %@, would you mind taking a moment to rate it? It won’t take more than a minute. Thanks for your support!";
#   customLocale.cancelButtonLabel = "No, Thanks";
#   customLocale.laterButtonLabel = "Remind Me Later";
#   customLocale.rateButtonLabel = "Rate It Now";
#
#   AppRate.preferences.storeAppURL.ios = '<my_app_id>';
#   AppRate.preferences.storeAppURL.android = 'market://details?id=<package_name>';
#   AppRate.preferences.customLocale = customLocale;
#   AppRate.preferences.displayAppName = 'My custom app title';
#   AppRate.preferences.usesUntilPrompt = 5;
#   AppRate.preferences.promptAgainForEachNewVersion = false;
#   AppRate.promptForRating();
#
# @note All %@ patterns in customLocale object will be automatically replaced to your application title
#
class AppRate
  LOCAL_STORAGE_COUNTER = 'counter'
  LOCALE_DEFAULT = 'en'
  FLAG_NATIVE_CODE_SUPPORTED = /(iPhone|iPod|iPad|Android)/i.test navigator.userAgent.toLowerCase()

  # @property {Object}
  counter =
    applicationVersion: undefined
    countdown: 0

  # Open application page in store
  #
  # @return {AppRate} counter
  navigateToAppStore = =>
    if /(iPhone|iPod|iPad)/i.test navigator.userAgent.toLowerCase()
      exec null, null, 'AppRate', 'launchAppStore', [@preferences.storeAppURL.ios]
    else if /(Android)/i.test navigator.userAgent.toLowerCase()
      window.open @preferences.storeAppURL.android, '_system'
    else if /(BlackBerry)/i.test navigator.userAgent.toLowerCase()
      window.open @preferences.storeAppURL.blackberry, '_system'
    else if /(IEMobile)/i.test navigator.userAgent.toLowerCase()
      window.open @preferences.storeAppURL.windows8, '_system'
    @

  # Confirm popup button click handler
  # @param {Integer} buttonIndex
  # @return {AppRate} counter
  promptForRatingWindowButtonClickHandler = (buttonIndex) =>
    switch buttonIndex
      when 1
        updateCounter 'stop'
      when 2
        updateCounter 'reset'
      when 3
        updateCounter 'stop'
        navigateToAppStore()

    @onButtonClicked buttonIndex

  # Update countdown counter
  #
  # @param {String} action increment | reset | stop
  # @return {Object} counter
  updateCounter = (action = 'increment') =>
    switch action
      when 'increment'
        counter.countdown++ if counter.countdown <= @preferences.usesUntilPrompt
      when 'reset'
        counter.countdown = 0
      when 'stop'
        counter.countdown = @preferences.usesUntilPrompt + 1

    localStorageParam LOCAL_STORAGE_COUNTER, JSON.stringify(counter)
    counter

  # Show confirm dialog
  # @return [AppRate]
  showDialog = =>
    if counter.countdown is @preferences.usesUntilPrompt
      localeObj = @preferences.customLocale or Locales.getLocale(@preferences.useLanguage,
          @preferences.displayAppName) or Locales.getLocale(LOCALE_DEFAULT, @preferences.displayAppName)
      navigator.notification.confirm localeObj.message, promptForRatingWindowButtonClickHandler, localeObj.title, [localeObj.cancelButtonLabel,
                                                                                                                   localeObj.laterButtonLabel,
                                                                                                                   localeObj.rateButtonLabel]
    @

  #	Get, set or delete localStorage item
  #
  # @param {String} itemName
  #	@param {String, Object, Integer} itemValue
  #	@param {Boolean} action true | false | null
  # @return [AppRate, Object, null]
  localStorageParam = (itemName, itemValue = null, action = false) ->
    action = true if itemValue isnt null
    switch action
      when true then localStorage.setItem itemName, itemValue
      when false then return localStorage.getItem itemName
      when null then localStorage.removeItem itemName
    @

  #	Get the application version from native code
  #
  #	@param successCallback {Function}
  #	@param errorCallback {Function}
  # @return [AppRate]
  getAppVersion = (successCallback, errorCallback) =>
    if FLAG_NATIVE_CODE_SUPPORTED
      exec successCallback, errorCallback, 'AppRate', 'getAppVersion', []
    else
      successCallback counter.applicationVersion
    @

  #	Get the application title from native code
  #
  #	@param successCallback {Function}
  #	@param errorCallback {Function}
  # @return [AppRate]
  getAppTitle = (successCallback, errorCallback) =>
    if FLAG_NATIVE_CODE_SUPPORTED
      exec successCallback, errorCallback, 'AppRate', 'getAppTitle', []
    else
      successCallback @preferences.displayAppName
    @

  # Initialize
  # @return [AppRate]
  @init: ->
    counter = JSON.parse(localStorageParam LOCAL_STORAGE_COUNTER) or counter
    getAppVersion (applicationVersion) =>
      if counter.applicationVersion isnt applicationVersion
        counter.applicationVersion = applicationVersion
        updateCounter('reset') if @preferences.promptAgainForEachNewVersion
      @

    getAppTitle (displayAppName) =>
      @preferences.displayAppName = displayAppName
      @

    @

  # Preferences object
  #
  # @param {Object} Plugin preferences
  # @param {String} useLanguage
  # @param {String} displayAppName
  # @param {Boolean} promptAgainForEachNewVersion
  # @param {Integer} usesUntilPrompt
  # @param {Object} storeAppURL
  #   @param {String} ios
  #   @param {String} android
  #   @param {String} blackberry
  # @param {Object} customLocale
  #   @param {String} title
  #   @param {String} message
  #   @param {String} cancelButtonLabel
  #   @param {String} laterButtonLabel
  #   @param {String} rateButtonLabel
  @preferences:
    useLanguage: null
    displayAppName: ''
    promptAgainForEachNewVersion: true
    usesUntilPrompt: 3
    storeAppURL:
      ios: undefined
      android: undefined
      blackberry: undefined
      windows8: undefined
    customLocale: null

  #	Check plugin preferences and display or not display rate popup
  #
  # @return [AppRate]
  #
  # @example
  #   AppRate.promptForRating();
  @promptForRating: ->
    if @preferences.useLanguage is null
      navigator.globalization.getPreferredLanguage (language) =>
        @preferences.useLanguage = language.value.split(/-/)[0]
        showDialog()
    else
      showDialog()

    updateCounter()
    @

  # User click on popup buttons callback
  #
  # @param buttonIndex {Integer} (1:	cancelButton, 2: laterButton, 3: rateButton)
  # @return [AppRate]
  #
  # @example Add popup buttons callback listener
  #   AppRate.onButtonClicked = function (buttonIndex) {
  #     console.log("button index: " + buttonIndex);
  #   }
  @onButtonClicked: (buttonIndex) ->
    console.log "onButtonClicked->#{buttonIndex}"
    @

AppRate.init()

module.exports = AppRate
