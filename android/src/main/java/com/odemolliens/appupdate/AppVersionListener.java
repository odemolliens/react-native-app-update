package com.odemolliens.appupdate;

import java.util.Map;

public interface AppVersionListener {
    void checkMigrationAppVersion(Map<String, Integer> previousversion, Map<String, Integer> currentversion);
}
