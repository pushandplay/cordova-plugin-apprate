package org.pushandplay.cordova.apprate;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.PackageManager;

public class AppRate extends CordovaPlugin {
	@Override
	public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException
	{
		try {
			if (action.equals("getAppVersion")){
				PackageManager packageManager = this.cordova.getActivity().getPackageManager();
				callbackContext.success(packageManager.getPackageInfo(this.cordova.getActivity().getPackageName(), 0).versionName);
				return true;
			}
			return false;
		} catch (NameNotFoundException e) {
			callbackContext.success("N/A");
			return true;
		}
	}
}