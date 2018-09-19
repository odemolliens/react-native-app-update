
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

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import static android.content.Context.MODE_PRIVATE;

public class ODAppUpdateModule extends ReactContextBaseJavaModule {

    private final String S_SHARED_PREF_APP_VERSION = "S_SHARED_PREF_APP_VERSION";
    private final String S_SHARED_APP_VERSION_KEY = "S_SHARED_APP_VERSION_KEY";
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

        if (!this.initVersioning()) {
            resolve.reject("AppUpdate", "react-native-app-update: Couldn't init version!");
            return;
        }

        String currentStoredVersion = getStoredVersion();
        String currentVersion = getCurrentVersion();
        if (currentVersion == null) {
            resolve.reject("AppUpdate", "react-native-app-update: Couldn't get current version!");
            return;
        }

        int[] storedArray = stringToIntArray(currentStoredVersion);
        int[] currentArray = stringToIntArray(currentVersion);
        if (storedArray == null || currentArray == null) {
            resolve.reject("AppUpdate", "react-native-app-update: Version doesn't match required format!");
            return;
        }

        int majorStoredVersion = storedArray[0];
        int minorStoredVersion = storedArray[1];
        int versionStoredCode = storedArray[2];
        int majorCurrentVersion = currentArray[0];
        int minorCurrentVersion = currentArray[1];
        int versionCurrentCode = currentArray[2];

        // Create Maps for native android
        HashMap<String, Integer> nativeStoredMap = new HashMap<>();
        nativeStoredMap.put("major", majorStoredVersion);
        nativeStoredMap.put("minor", minorStoredVersion);
        nativeStoredMap.put("version", versionStoredCode);
        HashMap<String, Integer> nativeCurrentMap = new HashMap<>();
        nativeCurrentMap.put("major", majorCurrentVersion);
        nativeCurrentMap.put("minor", minorCurrentVersion);
        nativeCurrentMap.put("version", versionCurrentCode);

        //Execute native change
        this.mListener.checkMigrationAppVersion(nativeStoredMap, nativeCurrentMap);

        // Create Maps for JS
        WritableMap jsStoredMap = Arguments.createMap();
        for (Map.Entry<String, Integer> entry : nativeStoredMap.entrySet()) {
            jsStoredMap.putInt(entry.getKey(), entry.getValue());
        }
        WritableMap jsCurrentMap = Arguments.createMap();
        for (Map.Entry<String, Integer> entry : nativeCurrentMap.entrySet()) {
            jsCurrentMap.putInt(entry.getKey(), entry.getValue());
        }

        //Fw to RN
        WritableMap map = Arguments.createMap();

        map.putMap("currentStoredVersion", jsStoredMap);
        map.putMap("currentVersion", jsCurrentMap);
        resolve.resolve(map);

        //Update current version stored
        this.setStoredVersion(currentVersion);
    }


    public boolean initVersioning() {
        String version = this.getStoredVersion();
        if (version == null) {
            //Init
            String currentVersion = getCurrentVersion();
            if (currentVersion == null) {
                return false;
            }
            this.setStoredVersion(currentVersion);
        }
        return true;
    }

    private String getCurrentVersion() {
        try {
            PackageInfo packageInfo = reactContext.getPackageManager().getPackageInfo(reactContext.getPackageName(), 0);
            return packageInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    }

    private String getStoredVersion() {
        SharedPreferences prefs = this.reactContext.getSharedPreferences(S_SHARED_PREF_APP_VERSION, MODE_PRIVATE);
        return prefs.getString(S_SHARED_APP_VERSION_KEY, null);
    }

    private void setStoredVersion(String version) {
        this.reactContext.getSharedPreferences(S_SHARED_PREF_APP_VERSION, MODE_PRIVATE).edit().putString(S_SHARED_APP_VERSION_KEY, version).apply();
    }

    private int[] stringToIntArray(String version) {
        String[] stringArray = version.split(Pattern.quote("."));
        if (stringArray.length != 3) {
            return null;
        }
        int[] intArray = new int[stringArray.length];
        for (int i = 0; i < stringArray.length; i++) {
            intArray[i] = Integer.parseInt(stringArray[i]);
        }
        return intArray;
    }

    @Override
    public String getName() {
        return "ODAppUpdate";
    }
}