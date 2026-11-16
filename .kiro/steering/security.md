# Security rules (spec 8, 17)

* Tokens live only in `SecureStore`/`TokenStore`. Drift holds no secrets or personal data.
* Push and socket carry events only; tokens come over HTTPS (login, watch exchange). Never put tokens in push
  payloads or QR codes; a snapshot is never accepted over push.
* The watch private key never leaves the Android Keystore; only the public key is sent at enrollment.
  Never log signatures, nonces, enrollment or pairing codes.
* The phone never sends a `user_id` for pairing; the server derives it from the bearer token.
* HTTPS only. Prod release builds require at least two `CERT_PINS`. Do not weaken
  `badCertificateCallback` or the network security config.
* `android:allowBackup="false"` and the data extraction rules stay in both manifests.
* Feature flags are not security controls; the backend must enforce permissions.
* Never commit `google-services.json`, `GoogleService-Info.plist`, `key.properties`, keystores or tokens.
