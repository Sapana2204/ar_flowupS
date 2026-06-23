package com.example.my_new_project

import android.content.Context
import android.os.Build
import android.telephony.CellInfoCdma
import android.telephony.CellInfoGsm
import android.telephony.CellInfoLte
import android.telephony.CellInfoNr
import android.telephony.CellInfoWcdma
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.my_new_project/telephony"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getTelephonyData" -> {
                    try {
                        result.success(getTelephonyData())
                    } catch (e: Exception) {
                        result.error("TELEPHONY_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getTelephonyData(): Map<String, Any> {
        val telephonyManager =
                getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        val carrier =
                telephonyManager.networkOperatorName?.takeIf { it.isNotBlank() } ?: "unknown"

        val networkType = telephonyManager.dataNetworkType
        val mobileGeneration = getNetworkGeneration(networkType)

        var signalStrengthDbm = "unknown"

        try {
            val cellInfos = telephonyManager.allCellInfo
            if (!cellInfos.isNullOrEmpty()) {
                for (cellInfo in cellInfos) {
                    if (cellInfo.isRegistered) {
                        signalStrengthDbm = when (cellInfo) {
                            is CellInfoGsm -> "${cellInfo.cellSignalStrength.dbm} dBm"
                            is CellInfoCdma -> "${cellInfo.cellSignalStrength.dbm} dBm"
                            is CellInfoLte -> "${cellInfo.cellSignalStrength.dbm} dBm"
                            is CellInfoWcdma -> "${cellInfo.cellSignalStrength.dbm} dBm"
                            is CellInfoNr -> {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                    "${cellInfo.cellSignalStrength.dbm} dBm"
                                } else {
                                    "unknown"
                                }
                            }
                            else -> "unknown"
                        }
                        break
                    }
                }
            }
        } catch (e: Exception) {
            signalStrengthDbm = "unknown"
        }

        return mapOf(
                "carrier" to carrier,
                "mobile_network_generation" to mobileGeneration,
                "signal_strength" to signalStrengthDbm
        )
    }

    private fun getNetworkGeneration(networkType: Int): String {
        return when (networkType) {
            TelephonyManager.NETWORK_TYPE_GPRS,
            TelephonyManager.NETWORK_TYPE_EDGE,
            TelephonyManager.NETWORK_TYPE_CDMA,
            TelephonyManager.NETWORK_TYPE_1xRTT,
            TelephonyManager.NETWORK_TYPE_IDEN -> "2G"

            TelephonyManager.NETWORK_TYPE_UMTS,
            TelephonyManager.NETWORK_TYPE_EVDO_0,
            TelephonyManager.NETWORK_TYPE_EVDO_A,
            TelephonyManager.NETWORK_TYPE_HSDPA,
            TelephonyManager.NETWORK_TYPE_HSUPA,
            TelephonyManager.NETWORK_TYPE_HSPA,
            TelephonyManager.NETWORK_TYPE_EVDO_B,
            TelephonyManager.NETWORK_TYPE_EHRPD,
            TelephonyManager.NETWORK_TYPE_HSPAP -> "3G"

            TelephonyManager.NETWORK_TYPE_LTE -> "4G"

            TelephonyManager.NETWORK_TYPE_NR -> "5G"

            else -> "unknown"
        }
    }
}