channel = require "cordova/channel"

AppRate = ->
	thisObj = @
	thisObj.app_id_ios = "123456789"
	thisObj.app_id_android = "com.company.YourAppID"
	thisObj.app_id_blackberry = "123456789"
	thisObj.rate_count_max = 3
	thisObj.rate_app_counter = parseInt window.localStorage.getItem("rate_app_counter") or 0
	thisObj.rate_app = parseInt window.localStorage.getItem("rate_app") or 1

	rate = (buttonIndex) ->
		# yes = 1, no = 2, later = 3
		switch buttonIndex
			when 1
				rate_stop()
				if /(iPhone|iPod|iPad)/i.test navigator.userAgent.toLowerCase()
					window.open "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=#{thisObj.app_id_ios}"
				else if /(Android)/i.test navigator.userAgent.toLowerCase()
					window.open "market://details?id=#{thisObj.app_id_android}"
				else if /(BlackBerry)/i.test navigator.userAgent.toLowerCase()
					window.open "http://appworld.blackberry.com/webstore/content/#{thisObj.app_id_blackberry}"
			when 2 then rate_reset()
			when 3 then rate_stop()

	rate_stop = ->
		window.localStorage.setItem "rate_app", 0
		window.localStorage.setItem "rate_app_counter", thisObj.rate_count_max

	rate_reset = ->
		window.localStorage.setItem "rate_app_counter", 0

	channel.onCordovaReady.subscribe ->
		if navigator.notification
			if thisObj.rate_app_counter is thisObj.rate_count_max and thisObj.rate_app isnt 0
				navigator.notification.confirm "Нам очень важно знать ваше мнение, пожалуйста оцените приложение. Это займет всего пару минут. \nСпасибо!", rate, "Оцените приложение",
					["Оценить сейчас", "Напомнить позже", "Нет спасибо"]
			else if thisObj.rate_app_counter < thisObj.rate_count_max
				thisObj.rate_app_counter++
				window.localStorage.setItem "rate_app_counter", thisObj.rate_app_counter

module.exports = new AppRate()