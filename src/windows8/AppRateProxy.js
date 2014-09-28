AppRateProxy = {
	getAppVersion: function (successCallback, failCallback, args) {
		var version = Windows.ApplicationModel.Package.current.id.version;
		successCallback([version.major, version.minor, version.build, version.revision].join('.'));
	},
	getAppTitle: function (successCallback, failCallback, args) {
		var title = Windows.ApplicationModel.Package.current.id.title;
		successCallback(title);
	}
};

require("cordova/windows8/commandProxy").add("AppRate", AppRateProxy);