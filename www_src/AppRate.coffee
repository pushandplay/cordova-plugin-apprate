preferences = require "./preferences"
locales = require "./locales"
channel = require "cordova/channel"

class AppRate
	thisObj = @

	@rate_app = parseInt window.localStorage.getItem("rate_app") or 1
	@usesUntilPromptCounter = parseInt window.localStorage.getItem("usesUntilPromptCounter") or 0

	constructor: ->
		if preferences.promptAtLaunch is true
			channel.onCordovaReady.subscribe ->
				AppRate::promptForRating()

	navigateToAppStore = ->
		if /(iPhone|iPod|iPad)/i.test navigator.userAgent.toLowerCase()
			if window.device and parseInt(window.device.version) >= 7
				reviewURL = "itms-apps://itunes.apple.com/#{preferences.useLanguage or 'en'}/app/id#{preferences.appStoreID.ios}"
			else
				reviewURL = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=#{preferences.appStoreID.ios}&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
			window.open reviewURL
		else if /(Android)/i.test navigator.userAgent.toLowerCase()
			window.open "market://details?id=#{preferences.appStoreID.android}", "_system"
		else if /(BlackBerry)/i.test navigator.userAgent.toLowerCase()
			window.open "http://appworld.blackberry.com/webstore/content/#{preferences.appStoreID.blackberry}"

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
		if thisObj.usesUntilPromptCounter is preferences.usesUntilPrompt and thisObj.rate_app isnt 0
			navigator.notification.confirm localeObj.message, promptForRatingWindowButtonClickHandler, localeObj.title, localeObj.buttonLabels
		else if thisObj.usesUntilPromptCounter < preferences.usesUntilPrompt
			thisObj.usesUntilPromptCounter++
			window.localStorage.setItem "usesUntilPromptCounter", thisObj.usesUntilPromptCounter

	getLocaleObject = ->
		localeObj = locales[preferences.useLanguage] or locales["en"]
		displayAppName = localeObj.displayAppName or preferences.displayAppName
		for key, value of localeObj
			if typeof value == 'string' or value instanceof String
				localeObj[key] = value.replace(/%@/g, displayAppName)
		localeObj


	promptForRating: ->
		if navigator.notification and navigator.globalization
			navigator.globalization.getPreferredLanguage (language) ->
				preferences.useLanguage = language.value.split(/_/)[0]
				rate_try()
			, ->
				rate_try()


module.exports = new AppRate @
