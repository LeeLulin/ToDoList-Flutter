package cn.bmob.data_plugin.util;

import android.annotation.TargetApi;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;

import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;


/**
 * 请求工具类
 *
 * @author smile
 * Created by Administrator on 2016/5/5.
 */
public class InstallationUtils {
    /**
     * 获取设备id
     *
     * @param context
     * @return
     */
    public static String getInstallationId(Context context) {
        String fakeUid = getFakeUniqueID();
        String androidId = getAndroidId(context);
        String m_szLongID = fakeUid + androidId;
        try {
            // compute md5
            MessageDigest m = MessageDigest.getInstance("MD5");
            m.update(m_szLongID.getBytes(), 0, m_szLongID.length());
            // get md5 bytes
            byte p_md5Data[] = m.digest();
            // create a hex string
            String m_szUniqueID = new String();
            for (int i = 0; i < p_md5Data.length; i++) {
                int b = (0xFF & p_md5Data[i]);
                // if it is a single digit, make sure it have 0 in front (proper
                // padding)
                if (b <= 0xF) {
                    m_szUniqueID += "0";
                }
                // add number to string
                m_szUniqueID += Integer.toHexString(b);
            } // hex string to uppercase
            m_szUniqueID = m_szUniqueID.toUpperCase(Locale.CHINA);
            return m_szUniqueID;
        } catch (Exception e) {
            e.printStackTrace();
            return m_szLongID.toUpperCase(Locale.CHINA);
        }
    }

    /**
     * 获取设备唯一号
     * 我们一共有五种方式取得设备的唯一标识。它们中的一些可能会返回null，或者由于硬件缺失、权限问题等获取失败。
     * 但总能获得至少一个能用。所以，最好的方法就是通过拼接，或者拼接后的计算出的MD5值来产生一个结果。
     * 本方法中通过一定的算法，可产生32位的16进制数据来作为设备的唯一标示
     *
     * @return 设备唯一标示
     */
    public static String getCombinedDeviceID(Context context) {
        String imei = getImei(context);
        String fakeUid = getFakeUniqueID();
        String androidId = getAndroidId(context);
        String wifiAddress = getWLAN_MAC_Address(context);
        String bluetoothAddress = getBT_MAC_Address(context);
        String m_szLongID = imei + fakeUid + androidId + wifiAddress + bluetoothAddress;
        try {
            // compute md5
            MessageDigest m = MessageDigest.getInstance("MD5");
            m.update(m_szLongID.getBytes(), 0, m_szLongID.length());
            // get md5 bytes
            byte p_md5Data[] = m.digest();
            String m_szUniqueID = new String();
            // create a hex string
            for (int i = 0; i < p_md5Data.length; i++) {
                int b = (0xFF & p_md5Data[i]);
                // if it is a single digit, make sure it have 0 in front (proper
                // padding)
                if (b <= 0xF) {
                    m_szUniqueID += "0";
                }
                // add number to string
                m_szUniqueID += Integer.toHexString(b);
            } // hex string to uppercase
            m_szUniqueID = m_szUniqueID.toUpperCase(Locale.CHINA);
            return m_szUniqueID;
        } catch (Exception e) {
            e.printStackTrace();
            return m_szLongID.toLowerCase(Locale.CHINA);
        }
    }

    /**
     * 获取设备唯一号（方式1：IMEI仅仅只对Android手机有效）
     * 采用此种方法，需要在AndroidManifest.xml中加入一个许可：android.permission.READ_PHONE_STATE，
     * 并且用户应当允许安装此应用。作为手机来讲，IMEI是唯一的，它应该类似于 359881030314356
     * （除非你有一个没有量产的手机（水货）它可能有无效的IMEI，如：0000000000000
     *
     * @param context
     * @return
     */
    private static String getImei(Context context) {
        if (isContains(context, "android.permission.READ_PHONE_STATE")) {
            try {
                TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
                return telephonyManager.getDeviceId();
            } catch (Exception e) {
                return "";
            }
        } else {
            return "";
        }
    }

    /**
     * 获取设备唯一号（方式2：获取到的是伪设备号, 这个在任何Android手机中都有效）
     * 有一些特殊的情况，一些如平板电脑的设置没有通话功能，或者你不愿加入READ_PHONE_STATE许可。
     * 而你仍然想获得唯一序列号之类的东西。这时你可以通过取出ROM版本、制造商、CPU型号、以及其他硬件信息来实现这一点。
     * 这样计算出来的ID不是唯一的（因为如果两个手机应用了同样的硬件以及Rom 镜像）。
     * 但应当明白的是，出现类似情况的可能性基本可以忽略。要实现这一点，你可以使用Build类:
     *
     * @return
     */
    @TargetApi(Build.VERSION_CODES.DONUT)
    private static String getFakeUniqueID() {
        // 大多数的Build成员都是字符串形式的，我们只取他们的长度信息。我们取到13个数字，并在前面加上“35”。这样这个ID看起来就和15位IMEI一样了。
        return "35"
                + // we make this look like a valid IMEI
                Build.BOARD.length() % 10 + Build.BRAND.length() % 10
                + Build.CPU_ABI.length() % 10 + Build.DEVICE.length() % 10
                + Build.DISPLAY.length() % 10 + Build.HOST.length() % 10
                + Build.ID.length() % 10 + Build.MANUFACTURER.length() % 10
                + Build.MODEL.length() % 10 + Build.PRODUCT.length() % 10
                + Build.TAGS.length() % 10 + Build.TYPE.length() % 10
                + Build.USER.length() % 10; // 13 digits

    }

    /**
     * 获取设备唯一号（方式3：The Android ID 无需任何许可）
     * 通常被认为不可信，因为它有时为null。开发文档中说明了：这个ID会改变如果进行了出厂设置。
     * 并且，如果某个Andorid手机被Root过的话，这个ID也可以被任意改变。
     *
     * @return
     */
    private static String getAndroidId(Context context) {
        try {
            return Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        } catch (Exception e) {
            return "";
        }
    }

    /**
     * 获取设备唯一号（方式4：The WLAN MAC Address string）1
     * 是另一个唯一ID。但是你需要为你的工程加入android.permission.ACCESS_WIFI_STATE
     * 权限，否则这个地址会为null。
     *
     * @return
     */
    private static String getWLAN_MAC_Address(Context context) {
        if (isContains(context, "android.permission.ACCESS_WIFI_STATE")) {
            try {
                WifiManager wm = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
                return wm.getConnectionInfo().getMacAddress();
            } catch (Throwable e) {
                return "";
            }
        } else {
            return "";
        }
    }

    /**
     * 获取设备唯一号（方式5：The BT MAC Address string）
     * 只在有蓝牙的设备上运行。并且要加入android.permission.BLUETOOTH 权限. 蓝牙没有必要打开，也能读取。
     *
     * @return
     */
    private static String getBT_MAC_Address(Context context) {
        if (isContains(context, "android.permission.BLUETOOTH")) {
            try {
                BluetoothAdapter m_BluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
                return m_BluetoothAdapter.getAddress();
            } catch (Throwable e) {
                return "";
            }
        } else {
            return "";
        }
    }

    /**
     * 检查应用程序是否包含某权限
     *
     * @param context
     * @param permission 要检查的权限
     * @return 返回是否包含（true为应用程序添加了此权限，false相反）
     */
    private static boolean isContains(Context context, String permission) {
        PackageManager pm = context.getPackageManager();
        PackageInfo pInfo;
        String[] permissions = null;
        try {
            pInfo = pm.getPackageInfo(context.getPackageName(),
                    PackageManager.GET_PERMISSIONS);
            permissions = pInfo.requestedPermissions;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        List<String> list = new ArrayList<>();
        if (permissions != null && permissions.length > 0) {
            int size = permissions.length;
            for (int i = 0; i < size; i++) {
                list.add(permissions[i]);
            }
        }
        if (list != null && list.contains(permission)) {
            return true;
        } else {
            return false;
        }
    }

}
