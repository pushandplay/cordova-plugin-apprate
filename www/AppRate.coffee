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
				thisObj.promptForRating()

	navigateToAppStore = ->
		if /(iPhone|iPod|iPad)/i.test navigator.userAgent.toLowerCase()
			window.open "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=#{preferences.appStoreID.ios}"
		else if /(Android)/i.test navigator.userAgent.toLowerCase()
			window.open "market://details?id=#{preferences.appStoreID.android}", "_system"
		else if /(BlackBerry)/i.test navigator.userAgent.toLowerCase()
			window.open "http://appworld.blackberry.com/webstore/content/#{preferences.appStoreID.blackberry}"

	promptForRatingWindowButtonClickHandler = (buttonIndex) ->
		# yes = 1, later = 2, no = 3
		switch buttonIndex
			when 1
				rate_stop()
				setTimeout navigateToAppStore, 1000
			when 2 then rate_reset()
			when 3 then rate_stop()

	rate_stop = ->
		window.localStorage.setItem "rate_app", 0
		window.localStorage.removeItem "usesUntilPromptCounter"

	rate_reset = ->
		window.localStorage.setItem "usesUntilPromptCounter", 0

	rate_try = ->
		localeObj = locales[preferences.useLanguage] or preferences.useLanguage
		if thisObj.usesUntilPromptCounter is preferences.usesUntilPrompt and thisObj.rate_app isnt 0
			navigator.notification.confirm localeObj.message, promptForRatingWindowButtonClickHandler, localeObj.title, localeObj.buttonLabels
		else if thisObj.usesUntilPromptCounter < preferences.usesUntilPrompt
			thisObj.usesUntilPromptCounter++
			window.localStorage.setItem "usesUntilPromptCounter", thisObj.usesUntilPromptCounter

	promptForRating: ->
		if navigator.notification and navigator.globalization
			navigator.globalization.getPreferredLanguage (language) ->
				preferences.useLanguage = language.value.split(/_/)[0]
				rate_try()
			, ->
				rate_try()


module.exports = new AppRate @
