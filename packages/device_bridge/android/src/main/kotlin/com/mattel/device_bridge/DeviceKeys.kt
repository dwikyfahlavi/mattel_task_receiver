package com.mattel.device_bridge

import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyInfo
import android.security.keystore.KeyProperties
import android.util.Base64
import java.security.KeyFactory
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey
import java.security.Signature
import java.security.spec.ECGenParameterSpec

/**
 * The watch's device key pair (backend guide, part 2 step 1).
 *
 * EC P-256 in the Android Keystore. The private key never leaves the Keystore;
 * only the public key (X.509 SubjectPublicKeyInfo, base64 without line breaks)
 * is sent to the backend at enrollment. Created once, never on each launch.
 */
internal object DeviceKeys {
    private const val ALIAS = "technician-watch-key"
    private const val PROVIDER = "AndroidKeyStore"

    private fun keyStore(): KeyStore = KeyStore.getInstance(PROVIDER).apply { load(null) }

    fun exists(): Boolean = keyStore().containsAlias(ALIAS)

    /** Creates the key pair if the alias is missing. Returns the public key info. */
    fun ensure(): Map<String, Any> {
        if (!exists()) create()
        return describe()
    }

    /** Public key and hardware backing, or an empty map when there is no key. */
    fun describe(): Map<String, Any> {
        val ks = keyStore()
        val cert = ks.getCertificate(ALIAS) ?: return emptyMap()
        val publicKey = Base64.encodeToString(cert.publicKey.encoded, Base64.NO_WRAP)
        return mapOf(
            "publicKey" to publicKey,
            "hardwareBacked" to isHardwareBacked(),
        )
    }

    /** SHA256withECDSA over the UTF-8 bytes of [text], base64 without line breaks. */
    fun sign(text: String): String {
        val key = keyStore().getKey(ALIAS, null) as? PrivateKey
            ?: throw IllegalStateException("Device key is missing")
        val signature = Signature.getInstance("SHA256withECDSA").apply {
            initSign(key)
            update(text.toByteArray(Charsets.UTF_8))
        }.sign()
        return Base64.encodeToString(signature, Base64.NO_WRAP)
    }

    fun delete() {
        val ks = keyStore()
        if (ks.containsAlias(ALIAS)) ks.deleteEntry(ALIAS)
    }

    private fun create() {
        val generator = KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, PROVIDER)
        generator.initialize(
            KeyGenParameterSpec.Builder(ALIAS, KeyProperties.PURPOSE_SIGN)
                .setAlgorithmParameterSpec(ECGenParameterSpec("secp256r1"))
                .setDigests(KeyProperties.DIGEST_SHA256)
                .setUserAuthenticationRequired(false)
                .build(),
        )
        generator.generateKeyPair()
    }

    private fun isHardwareBacked(): Boolean = try {
        val key = keyStore().getKey(ALIAS, null) as PrivateKey
        val info = KeyFactory.getInstance(key.algorithm, PROVIDER)
            .getKeySpec(key, KeyInfo::class.java)
        if (Build.VERSION.SDK_INT >= 31) {
            info.securityLevel == KeyProperties.SECURITY_LEVEL_TRUSTED_ENVIRONMENT ||
                info.securityLevel == KeyProperties.SECURITY_LEVEL_STRONGBOX
        } else {
            @Suppress("DEPRECATION")
            info.isInsideSecureHardware
        }
    } catch (e: Exception) {
        false
    }
}
