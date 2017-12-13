package com.easyman.plugin;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * This class echoes a string called from JavaScript.
 */
public class JailBreakCheck extends CordovaPlugin {

    public static final String ACTION_CHECK_IS_ROOT = "isJailBreak";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        // isJailBreak
        if (action.equals(ACTION_CHECK_IS_ROOT)) {
            this.isJailBreak(callbackContext);
            return true;
        }

        return false;
    }

    private void isJailBreak(CallbackContext callbackContext) {
        if (isDeviceRooted() || this.isRoot()) {
            callbackContext.success("true");
        } else {
            callbackContext.success("false");
        }
    }

    /**
    * 判断手机是否root
    * android手机开启了root权限，主要是根据root之后，获取了手机的最高权限，底层linux系统就会生成一个以su结尾的文件，su代表super超级权限
    **/
    public boolean isRoot() {
        String binPath = "/system/bin/su";
        String xBinPath = "/system/xbin/su";

        if (new File(binPath).exists() && isCanExecute(binPath)) {
            return true;
        }
        if (new File(xBinPath).exists() && isCanExecute(xBinPath)) {
            return true;
        }

        return false;
    }

    private boolean isCanExecute(String filePath) {
        java.lang.Process process = null;
        try {
            process = Runtime.getRuntime().exec("ls -l " + filePath);
            BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String str = in.readLine();
            if (str != null && str.length() >= 4) {
                char flag = str.charAt(3);
                if (flag == 's' || flag == 'x')
                    return true;
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (process != null) {
                process.destroy();
            }
        }
        return false;
    }

    /**
     * 第二种方式
     * @return
     */
    public boolean isDeviceRooted() {
        if (checkRootMethod1()){return true;}
        if (checkRootMethod2()){return true;}
        if (checkRootMethod3()){return true;}
        return false;
    }

    public boolean checkRootMethod1(){
        String buildTags = android.os.Build.TAGS;

        if (buildTags != null && buildTags.contains("test-keys")) {
            return true;
        }
        return false;
    }

    public boolean checkRootMethod2(){
        try {
            File file = new File("/system/app/Superuser.apk");
            if (file.exists()) {
                return true;
            }
        } catch (Exception e) { }

        return false;
    }

    public boolean checkRootMethod3() {
        if (new ExecShell().executeCommand(ExecShell.SHELL_CMD.check_su_binary) != null){
            return true;
        }else{
            return false;
        }
    }
}
