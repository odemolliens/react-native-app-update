package com.sampleappupdate;

import android.app.Application;
import android.util.Log;

import com.facebook.react.ReactApplication;
import com.odemolliens.appupdate.AppVersionListener;
import com.odemolliens.appupdate.ODAppUpdatePackage;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class MainApplication extends Application implements ReactApplication {

    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
        @Override
        public boolean getUseDeveloperSupport() {
            return BuildConfig.DEBUG;
        }

        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                    new MainReactPackage(),
                    new ODAppUpdatePackage(new AppVersionListener() {
                        @Override
                        public void checkMigrationAppVersion(Map<String, Integer> storedVersion, Map<String, Integer> currentversion) {
                            int majorStoredVersion = storedVersion.get("major");
                            int minorStoredVersion = storedVersion.get("minor");
                            int versionStoredCode = storedVersion.get("version");
                            int majorCurrentVersion = currentversion.get("major");
                            int minorCurrentVersion = currentversion.get("minor");
                            int versionCurrentCode = currentversion.get("version");
                            Log.d("SampleAppUpdate", storedVersion + "\n" + currentversion);
                        }
                    })
            );
        }

        @Override
        protected String getJSMainModuleName() {
            return "index";
        }
    };

    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        SoLoader.init(this, /* native exopackage */ false);
    }
}
