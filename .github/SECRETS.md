# GitHub Secrets Configuration

This document outlines all the secrets required for the CI/CD pipeline to build and sign applications for all platforms.

## 🔐 Required Secrets by Platform

### iOS Build Secrets

| Secret Name | Description | Required | How to Generate |
|-------------|-------------|----------|-----------------|
| `IOS_CERTIFICATE` | Base64 encoded .p12 certificate file | ✅ | 1. Go to [Apple Developer Account](https://developer.apple.com/account/resources/certificates/list)<br>2. Create "iOS Distribution" certificate<br>3. Download and export as .p12 from Keychain Access<br>4. Convert: `openssl base64 -in certificate.p12 -out certificate.txt` |
| `IOS_CERTIFICATE_PASSWORD` | Password for the .p12 file | ✅ | Password you set when exporting from Keychain Access |
| `IOS_PROVISIONING_PROFILE` | Base64 encoded .mobileprovision file | ✅ | 1. Go to [Provisioning Profiles](https://developer.apple.com/account/resources/profiles/list)<br>2. Create "App Store" provisioning profile<br>3. Download .mobileprovision file<br>4. Convert: `base64 -i profile.mobileprovision -o profile.txt` |
| `APPLE_TEAM_ID` | Apple Developer Team ID | ✅ | Found in [Apple Developer Account](https://developer.apple.com/account) (search "Team ID") |
| `IOS_BUNDLE_ID` | iOS app bundle identifier | ✅ | e.g., `com.yourcompany.yourapp` |
| `KEYCHAIN_PASSWORD` | Password for temporary keychain | ✅ | Any secure password for CI keychain |

#### Optional (for App Store Connect upload):
| Secret Name | Description | Required | How to Generate |
|-------------|-------------|----------|-----------------|
| `APP_STORE_CONNECT_API_KEY` | Base64 encoded .p8 API key file | ❌ | 1. Go to [App Store Connect API](https://appstoreconnect.apple.com/access/api)<br>2. Create API key and download .p8 file<br>3. Convert: `base64 -i AuthKey_XXXXXXXXXX.p8 -o api-key.txt` |
| `APP_STORE_CONNECT_API_KEY_ID` | API Key ID | ❌ | From App Store Connect API key creation |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID | ❌ | From App Store Connect API page |

### macOS Build Secrets

| Secret Name | Description | Required | How to Generate |
|-------------|-------------|----------|-----------------|
| `APPLE_CERTIFICATE` | Base64 encoded .p12 certificate file | ✅ | 1. Go to [Apple Developer Account](https://developer.apple.com/account/resources/certificates/list)<br>2. Create "Developer ID Application" certificate<br>3. Download and export as .p12 from Keychain Access<br>4. Convert: `openssl base64 -in certificate.p12 -out certificate.txt` |
| `APPLE_CERTIFICATE_PASSWORD` | Password for the .p12 file | ✅ | Password you set when exporting from Keychain Access |
| `KEYCHAIN_PASSWORD` | Password for temporary keychain | ✅ | Any secure password for CI keychain |
| `APPLE_ID` | Apple ID with Developer account | ✅ | Your Apple ID email |
| `APPLE_APP_SPECIFIC_PASSWORD` | App-specific password | ✅ | 1. Go to [Apple ID Account](https://account.apple.com/account/manage)<br>2. Generate App-specific password<br>3. See [Apple Support](https://support.apple.com/zh-cn/102654) |
| `APPLE_TEAM_ID` | Apple Developer Team ID | ✅ | Found in [Apple Developer Account](https://developer.apple.com/account) |

### Android Build Secrets (Optional - for signed APK/AAB)

| Secret Name | Description | Required | How to Generate |
|-------------|-------------|----------|-----------------|
| `ANDROID_KEYSTORE` | Base64 encoded .jks keystore file | ❌ | 1. Generate: `keytool -genkey -v -keystore release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release`<br>2. Convert: `base64 -i release-key.jks -o release-key.txt` |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password | ❌ | Password you set when generating keystore |
| `ANDROID_KEY_ALIAS` | Key alias | ❌ | Alias you set when generating keystore (e.g., "release") |
| `ANDROID_KEY_PASSWORD` | Key password | ❌ | Key password you set when generating keystore |

### Windows Build Secrets

No additional secrets required for Windows builds. The workflow will generate unsigned executables.

### Linux Build Secrets

No additional secrets required for Linux builds. The workflow will generate unsigned packages.

## 🛠️ Setting Up Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret with the exact name and value as specified above

## 📋 Environments

Some workflows use GitHub Environments for additional security:

- **production**: Used for macOS and iOS builds
  - Contains Apple signing secrets
  - Can be configured with protection rules

To set up environments:
1. Go to **Settings** → **Environments**
2. Create **production** environment
3. Add environment-specific secrets
4. Configure protection rules if needed

## 🔍 Verification

After setting up secrets, you can verify they work by:

1. Running the **CI/CD Pipeline** workflow
2. Checking individual platform build logs
3. Ensuring artifacts are generated successfully

## 🚨 Security Notes

- Never commit secrets to your repository
- Use environment-specific secrets for sensitive operations
- Regularly rotate certificates and passwords
- Monitor secret usage in workflow runs
- Consider using GitHub's dependency review for security

## 📚 Additional Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Tauri Distribution Guide](https://tauri.app/distribute/)
