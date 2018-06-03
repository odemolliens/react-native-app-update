package com.sampleappupdate;

import android.app.Application;

import com.facebook.react.ReactApplication;
import com.odemolliens.appupdate.AppVersionListener;
import com.odemolliens.appupdate.ODAppUpdatePackage;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;

import java.util.Arrays;
import java.util.List;

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
                        public void checkMigrationAppVersion(String previousversion, String currentversion) {
                            if (previousversion.equals("1.0.1") && currentversion.equals("1.0.2")) {
                                //Clean native stuff
                            }
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
