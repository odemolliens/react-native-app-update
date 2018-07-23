
package com.odemolliens.appupdate;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.util.Log;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.WritableMap;

import static android.content.Context.MODE_PRIVATE;

public class ODAppUpdateModule extends ReactContextBaseJavaModule {

    private final String S_SHARED_PREF_APP_VERSION = "S_SHARED_PREF_APP_VERSION";
    private final String S_SHARED_APP_VERSION_KEY = "S_SHARED_APP_VERSION_KEY";
    private final String NAME_NOT_FOUND = "NAME_NOT_FOUND";
    private final ReactApplicationContext reactContext;
    private final AppVersionListener mListener;

    public ODAppUpdateModule(ReactApplicationContext reactContext, AppVersionListener listener) {
        super(reactContext);
        this.reactContext = reactContext;
        this.mListener = listener;
    }

    @ReactMethod
    public void appVersion(final Promise resolve) {
        //FIXME: not a static method !

        if (this.mListener == null) {
            resolve.reject("AppUpdate", "react-native-app-update: Delegate is not implemented!");
            return;
        }

        if (!this.initVersioning(this.reactContext)) {
            resolve.reject("AppUpdate", "react-native-app-update: Couldn't init version!");
        }

        String currentStoredVersion = getStoredVersion();
        String currentVersion = getCurrentVersion();

        if (!currentStoredVersion.equals(currentVersion)) {
            //Execute native change
            this.mListener.checkMigrationAppVersion(currentStoredVersion, currentVersion);

            //Fw to RN
            WritableMap map = Arguments.createMap();
            map.putString("currentStoredVersion", currentStoredVersion);
            map.putString("currentVersion", currentVersion);
            resolve.resolve(map);

            //Update current version stored
            this.setStoredVersion(currentVersion);
        } else {
            resolve.reject(currentVersion, "react-native-app-update: same version !");
        }

    }


    public boolean initVersioning(ReactApplicationContext context) {
        String version = this.getStoredVersion();
        if (version == null) {
            //Init
            String currentVersion = getCurrentVersion();
            if (currentVersion == NAME_NOT_FOUND) {
                return false;
            }
            this.setStoredVersion(currentVersion);
        }
        return true;
    }

    private String getCurrentVersionName() {
        try {
            PackageInfo packageInfo = reactContext.getPackageManager().getPackageInfo(reactContext.getPackageName(), 0);
            return packageInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return NAME_NOT_FOUND;
        }
    }

    private int getCurrentVersionCode() {
        try {
            PackageInfo packageInfo = reactContext.getPackageManager().getPackageInfo(reactContext.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return -1;
        }
    }

    private String getCurrentVersion() {
        String currentVersionName = getCurrentVersionName();
        int currentVersionCode = getCurrentVersionCode();
        if (currentVersionName == NAME_NOT_FOUND || currentVersionCode == -1) {
            return NAME_NOT_FOUND;
        }
        return currentVersionName + "." + currentVersionCode;
    }

    private String getStoredVersion() {
        SharedPreferences prefs = this.reactContext.getSharedPreferences(S_SHARED_PREF_APP_VERSION, MODE_PRIVATE);
        return prefs.getString(S_SHARED_APP_VERSION_KEY, null);
    }

    private void setStoredVersion(String version) {
        this.reactContext.getSharedPreferences(S_SHARED_PREF_APP_VERSION, MODE_PRIVATE).edit().putString(S_SHARED_APP_VERSION_KEY, version).apply();
    }

    @Override
    public String getName() {
        return "ODAppUpdate";
    }
}