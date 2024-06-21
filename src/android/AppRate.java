package org.pushandplay.cordova.apprate;

import android.app.Activity;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import com.google.android.gms.tasks.Task;
import com.google.android.play.core.review.ReviewInfo;
import com.google.android.play.core.review.ReviewManager;
import com.google.android.play.core.review.ReviewManagerFactory;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

public class AppRate extends CordovaPlugin {
  @Override
  public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
    try {
      if (action.equals("getAppVersion")) {
        callbackContext.success(this.cordova.getActivity().getPackageManager().getPackageInfo(this.cordova.getActivity().getPackageName(), 0).versionName);
        return true;
      }
      if (action.equals("getAppTitle")) {
        PackageManager packageManager = this.cordova.getActivity().getPackageManager();
        ApplicationInfo applicationInfo = packageManager.getApplicationInfo(this.cordova.getActivity().getApplicationContext().getApplicationInfo().packageName, 0);
        final String applicationName = (String) (applicationInfo != null ? packageManager.getApplicationLabel(applicationInfo) : "Unknown");
        callbackContext.success(applicationName);
        return true;
      }
      if (action.equals("launchReview")) {
        Activity activity = this.cordova.getActivity();
        ReviewManager manager = ReviewManagerFactory.create(activity);
        Task<ReviewInfo> request = manager.requestReviewFlow();
        request.addOnCompleteListener(task -> {
          if (task.isSuccessful()) {
            ReviewInfo reviewInfo = task.getResult();
            Task<Void> flow = manager.launchReviewFlow(activity, reviewInfo);
            flow.addOnCompleteListener(launchTask -> {
              if (launchTask.isSuccessful()) {
                callbackContext.success();
              } else {
                Exception error = launchTask.getException();
                callbackContext.error("Failed to launch review - " + error.getMessage());
              }
            });
          } else {
            Exception error = task.getException();
            callbackContext.error("Failed to launch review flow - " + error.getMessage());
          }
        });
        return true;
      }
      return false;
    } catch (NameNotFoundException e) {
      callbackContext.success("N/A");
      return true;
    }
  }
}
