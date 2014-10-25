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

locales = require './locales'
exec = require 'cordova/exec'

# @concern AppRate
class AppRate
  LOCAL_STORAGE_APP_VERSION = 'appVersion'
  LOCAL_STORAGE_COUNTER = 'counter'
  LOCALE_DEFAULT = 'en'
  FLAG_NATIVE_CODE_SUPPORTED = /(iPhone|iPod|iPad|Android)/i.test navigator.userAgent.toLowerCase()

  counter =
    appVersion: undefined
    countdown: 0

  navigateToAppStore = ->
    if /(iPhone|iPod|iPad)/i.test navigator.userAgent.toLowerCase()
      window.open @preferences.storeAppURL.ios, '_system'
    else if /(Android)/i.test navigator.userAgent.toLowerCase()
      window.open @preferences.storeAppURL.android, '_system'
    else if /(BlackBerry)/i.test navigator.userAgent.toLowerCase()
      window.open @preferences.storeAppURL.blackberry
    @

  getLocaleObject = =>
    localeObj = @preferences.customLocale or locales[@preferences.useLanguage] or locales[LOCALE_DEFAULT]
    displayAppName = localeObj.displayAppName or @preferences.displayAppName
    for key, value of localeObj
      if typeof value is 'string' or value instanceof String
        localeObj[key] = value.replace(/%@/g, displayAppName)
    localeObj

  promptForRatingWindowButtonClickHandler = (buttonIndex) =>
    switch buttonIndex
      when 2
        updateCounter 'reset'
      when 1, 3
        updateCounter 'stop'

    @onButtonClicked buttonIndex

  ###
  @nodoc
  constructor: ->
    @getAppVersion (success) =>
      AppRate.preferences.curentVersion = success
      if /(iPhone|iPod|iPad)/i.test navigator.userAgent.toLowerCase() and (window.localStorage.getItem "appVersion") isnt success
        AppRate.preferences.curentVersion = success

        rate_stop()
        rate_reset()

        window.localStorage.setItem 'appVersion', success
        window.localStorage.removeItem 'rate_app'

      AppRate.rate_app = parseInt window.localStorage.getItem("rate_app") or 1
      AppRate.usesUntilPromptCounter = parseInt window.localStorage.getItem("usesUntilPromptCounter") or 0

    @getAppTitle (success) ->
      AppRate.preferences.displayAppName = success
    @

  navigateToAppStore = ->
    if /(iPhone|iPod|iPad)/i.test navigator.userAgent.toLowerCase()
      window.open AppRate.preferences.appStoreAppURL.ios, '_system'
    else if /(Android)/i.test navigator.userAgent.toLowerCase()
      window.open AppRate.preferences.appStoreAppURL.android, '_system'
    else if /(BlackBerry)/i.test navigator.userAgent.toLowerCase()
      window.open AppRate.preferences.appStoreAppURL.blackberry
    @

  promptForRatingWindowButtonClickHandler = (buttonIndex) ->
    # no = 1, later = 2, yes = 3
    switch buttonIndex
      when 3
        rate_stop()
        setTimeout navigateToAppStore, 100
      when 2 then rate_reset()
      when 1 then rate_stop()
    @

  rate_stop = ->
    window.localStorage.setItem "rate_app", 0
    window.localStorage.removeItem "usesUntilPromptCounter"
    @

  rate_reset = ->
    window.localStorage.setItem "usesUntilPromptCounter", 0
    @

  rate_try = ->
    localeObj = getLocaleObject()
    if thisObj.usesUntilPromptCounter is AppRate.preferences.usesUntilPrompt and thisObj.rate_app isnt 0
      navigator.notification.confirm localeObj.message, promptForRatingWindowButtonClickHandler, localeObj.title, [localeObj.cancelButtonLabel, localeObj.laterButtonLabel, localeObj.rateButtonLabel]
    else if thisObj.usesUntilPromptCounter < AppRate.preferences.usesUntilPrompt
      thisObj.usesUntilPromptCounter++
      window.localStorage.setItem "usesUntilPromptCounter", thisObj.usesUntilPromptCounter
    @

  getLocaleObject = ->
    localeObj = AppRate.preferences.customLocale or locales[AppRate.preferences.useLanguage] or locales["en"]
    displayAppName = localeObj.displayAppName or AppRate.preferences.displayAppName
    for key, value of localeObj
      if typeof value == 'string' or value instanceof String
        localeObj[key] = value.replace(/%@/g, displayAppName)
    localeObj


  setup: (prefs) ->
    AppRate.preferences.debug = true if prefs.debug isnt undefined
    if prefs.useLanguage isnt undefined
      AppRate.preferences.autoDetectLanguage = false
      AppRate.preferences.useLanguage = prefs.useLanguage
    AppRate.preferences.customLocale = prefs.customLocale if prefs.customLocale isnt undefined
    AppRate.preferences.usesUntilPrompt = prefs.usesUntilPrompt if prefs.usesUntilPrompt isnt undefined
    AppRate.preferences.displayAppName = prefs.displayAppName if prefs.displayAppName isnt undefined
    if prefs.appStoreAppURL
      AppRate.preferences.appStoreAppURL.ios = prefs.appStoreAppURL.ios if prefs.appStoreAppURL.ios isnt undefined
      AppRate.preferences.appStoreAppURL.android = prefs.appStoreAppURL.android if prefs.appStoreAppURL.android isnt undefined
      AppRate.preferences.appStoreAppURL.blackberry = prefs.appStoreAppURL.blackberry if prefs.appStoreAppURL.blackberry isnt undefined
    @

  promptForRating: ->
    if navigator.notification and navigator.globalization
      if AppRate.preferences.autoDetectLanguage
        navigator.globalization.getPreferredLanguage (language) ->
          AppRate.preferences.useLanguage = language.value.split(/_/)[0]
          rate_try()
        , ->
          rate_try()
      else
        rate_try()
    @

  ###

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

  showDialog = =>
    if counter.countdown <= @preferences.usesUntilPrompt
      localeObj = getLocaleObject()
      navigator.notification.confirm localeObj.message, promptForRatingWindowButtonClickHandler, localeObj.title, [localeObj.cancelButtonLabel, localeObj.laterButtonLabel, localeObj.rateButtonLabel]
    @

  #	Get, set or delete localStorage item
  #
  # @param itemName {String}
  #	@param temValue {Misc}
  #	@param action {Boolean}
  #		true:		set item
  #		false:	get	item
  #		null:		delete item
  localStorageParam = (itemName, itemValue = null, action = false) ->
    action = true if itemValue isnt null
    switch action
      when true then localStorage.setItem itemName, itemValue
      when false then return localStorage.getItem itemName
      when null then localStorage.removeItem itemName


  # Preferences object
  #
  # @param {String} useLanguage
  # @param {String} displayAppName
  # @param {String} currentVersion
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
    currentVersion: null
    promptAgainForEachNewVersion: true  # TODO: not implemented
    usesUntilPrompt: 3
    storeAppURL:
      ios: undefined
      android: undefined
      blackberry: undefined
    customLocale:
      title: "Rate %@",
      message: "If you enjoy using %@, would you mind taking a moment to rate it? It won’t take more than a minute. Thanks for your support!",
      cancelButtonLabel: "No, Thanks",
      laterButtonLabel: "Remind Me Later",
      rateButtonLabel: "Rate It Now"



  # @return [Object<AppRate>]
  @init: ->
    counter = JSON.parse(localStorageParam LOCAL_STORAGE_COUNTER) or counter
    @getAppVersion (currentVersion) =>
      if @preferences.currentVersion isnt currentVersion
        @preferences.currentVersion = currentVersion
        localStorageParam LOCAL_STORAGE_APP_VERSION, currentVersion
      @

    @getAppTitle (displayAppName) =>
      @preferences.displayAppName = displayAppName
      @

    @

  #	@method Check plugin preferences and display or not display rate popup
  #
  # @return [Object<AppRate>]
  #
  # @example
  #   AppRate.promptForRating();
  @promptForRating: ->
    @preferences.currentVersion = localStorageParam LOCAL_STORAGE_APP_VERSION
    updateCounter()

    if @preferences.useLanguage is null
      navigator.globalization.getPreferredLanguage (language) =>
        @preferences.useLanguage = language.value.split(/-/)[0]
        showDialog()
    else
      showDialog()

    @

  #	Get the application version from native code
  #
  #	@param successCallback {Function}
  #	@param errorCallback {Function}
  # @return [Object<AppRate>]
  #
  # @example Try getting application version
  #   var successCallback = function(applicationVersion){
  #     console.log("Application version: " + applicationVersion);
  #   };
  #   var errorCallback = function(errorMessage){
  #     console.log("Can not get app version, error:" + errorMessage);
  #   };
  #   AppRate.getAppVersion(successCallback, errorCallback);
  @getAppVersion: (successCallback, errorCallback) ->
    if FLAG_NATIVE_CODE_SUPPORTED
      exec successCallback, errorCallback, 'AppRate', 'getAppVersion', []
    else
      successCallback localStorageParam LOCAL_STORAGE_APP_VERSION
    @

  #	Get the application title from native code
  #
  #	@param successCallback {Function}
  #	@param errorCallback {Function}
  # @return [Object<AppRate>]
  #
  # @example Try getting application title
  #   var successCallback = function(applicationTitle){
  #     console.log("Application title: " + applicationTitle);
  #   };
  #   var errorCallback = function(errorMessage){
  #     console.log("Can not get app title, error:" + errorMessage);
  #   };
  #   AppRate.getAppTitle(successCallback, errorCallback);
  @getAppTitle: (successCallback, errorCallback) ->
    if FLAG_NATIVE_CODE_SUPPORTED
      exec successCallback, errorCallback, 'AppRate', 'getAppTitle', []
    else
      successCallback @preferences.displayAppName
    @

  # ###EVENTS###

  # @event onButtonClicked User click on popup buttons callback
  #
  # @param buttonIndex {Integer} (1:	cancelButton, 2: laterButton, 3: rateButton)
  # @return [Object<AppRate>]
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
