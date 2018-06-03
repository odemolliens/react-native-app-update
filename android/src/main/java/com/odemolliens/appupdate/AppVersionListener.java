package com.odemolliens.appupdate;

public interface AppVersionListener {
    void checkMigrationAppVersion(String previousversion, String currentversion);
}
