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

locales = require "./locales"
channel = require "cordova/channel"

class AppRate
	thisObj = @

	@preferences:
		autoDetectLanguage: true
		useLanguage: "en"
		displayAppName: "AppRate plugin"
		promptAtLaunch: true
		promptAgainForEachNewVersion: true  # TODO: not implemented
		daysUntilPrompt: 1  # TODO: not implemented
		usesUntilPrompt: 3
		appStoreAppURL:
			ios: undefined
			android: undefined
			blackberry: undefined

	@rate_app = parseInt window.localStorage.getItem("rate_app") or 1
	@usesUntilPromptCounter = parseInt window.localStorage.getItem("usesUntilPromptCounter") or 0

	navigateToAppStore = ->
		if /(iPhone|iPod|iPad)/i.test navigator.userAgent.toLowerCase()
			window.open AppRate.preferences.appStoreAppURL.ios
		else if /(Android)/i.test navigator.userAgent.toLowerCase()
			window.open AppRate.preferences.appStoreAppURL.android, "_system"
		else if /(BlackBerry)/i.test navigator.userAgent.toLowerCase()
			window.open AppRate.preferences.appStoreAppURL.blackberry

	promptForRatingWindowButtonClickHandler = (buttonIndex) ->
		# no = 1, later = 2, yes = 3
		switch buttonIndex
			when 3
				rate_stop()
				setTimeout navigateToAppStore, 1000
			when 2 then rate_reset()
			when 1 then rate_stop()

	rate_stop = ->
		window.localStorage.setItem "rate_app", 0
		window.localStorage.removeItem "usesUntilPromptCounter"

	rate_reset = ->
		window.localStorage.setItem "usesUntilPromptCounter", 0

	rate_try = ->
		localeObj = getLocaleObject()
		if thisObj.usesUntilPromptCounter is AppRate.preferences.usesUntilPrompt and thisObj.rate_app isnt 0
			navigator.notification.confirm localeObj.message, promptForRatingWindowButtonClickHandler, localeObj.title, localeObj.buttonLabels
		else if thisObj.usesUntilPromptCounter < AppRate.preferences.usesUntilPrompt
			thisObj.usesUntilPromptCounter++
			window.localStorage.setItem "usesUntilPromptCounter", thisObj.usesUntilPromptCounter

	getLocaleObject = ->
		localeObj = AppRate.preferences.customLocale or locales[AppRate.preferences.useLanguage] or locales["en"]
		displayAppName = localeObj.displayAppName or AppRate.preferences.displayAppName
		for key, value of localeObj
			if typeof value == 'string' or value instanceof String
				localeObj[key] = value.replace(/%@/g, displayAppName)
		localeObj


	setup: (prefs) ->
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


module.exports = new AppRate @
