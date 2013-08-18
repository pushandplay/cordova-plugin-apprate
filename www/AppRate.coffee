channel = require "cordova/channel"
preferences = require "./preferences"
locales = require "./locales"

AppRate = ->
	thisObj = @

	@rate_app = parseInt window.localStorage.getItem("rate_app") or 1
	@rate_app_counter = parseInt window.localStorage.getItem("rate_app_counter") or 0

	@openRateWindow = ->
		if /(iPhone|iPod|iPad)/i.test navigator.userAgent.toLowerCase()
			window.open "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=#{preferences.app_id.ios}"
		else if /(Android)/i.test navigator.userAgent.toLowerCase()
			window.open "market://details?id=#{preferences.appStoreID.android}", "_system"
		else if /(BlackBerry)/i.test navigator.userAgent.toLowerCase()
			window.open "http://appworld.blackberry.com/webstore/content/#{preferences.app_id.blackberry}"

	@rate = (buttonIndex) ->
		# yes = 1, no = 2, later = 3
		switch buttonIndex
			when 1
				thisObj.rate_stop()
				setTimeout thisObj.openRateWindow, 250
			when 2 then thisObj.rate_reset()
			when 3 then thisObj.rate_stop()

	@rate_stop = ->
		window.localStorage.setItem "rate_app", 0
		window.localStorage.removeItem "rate_app_counter"

	@rate_reset = ->
		window.localStorage.setItem "rate_app_counter", 0

	@rate_try = (locale) ->
		localeObj = locales[locale] or locales.en
		if thisObj.rate_app_counter is preferences.rate_count_max and thisObj.rate_app isnt 0
			navigator.notification.confirm localeObj.message, thisObj.rate, localeObj.title, localeObj.buttonLabels
		else if thisObj.rate_app_counter < preferences.rate_count_max
			thisObj.rate_app_counter++
			window.localStorage.setItem "rate_app_counter", thisObj.rate_app_counter

	channel.onCordovaReady.subscribe ->
		if navigator.notification and navigator.globalization
			navigator.globalization.getPreferredLanguage (language) ->
				thisObj.rate_try language.value.split(/_/)[0]
			, ->
				thisObj.rate_try "en"

module.exports = new AppRate()
