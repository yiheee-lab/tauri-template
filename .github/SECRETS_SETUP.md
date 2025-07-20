# GitHub Secrets Setup Guide

This guide explains how to set up the required GitHub repository secrets for signing and publishing your Tauri application across all platforms.

## 🔐 Required Secrets

### Android Signing

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `ANDROID_KEY_BASE64` | Base64 encoded Android keystore (.jks) file | ✅ Yes |
| `ANDROID_KEY_ALIAS` | Key alias from your keystore | ✅ Yes |
| `ANDROID_KEY_PASSWORD` | Password for the key alias | ✅ Yes |

### Apple/iOS Signing & Publishing

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `APPLE_CERTIFICATE` | Base64 encoded Apple Developer certificate (.p12) | ✅ Yes |
| `APPLE_CERTIFICATE_PASSWORD` | Password for the certificate | ✅ Yes |
| `APPLE_ID` | Your Apple ID email | ✅ Yes |
| `APPLE_APP_SPECIFIC_PASSWORD` | App-specific password for your Apple ID | ✅ Yes |
| `APPLE_TEAM_ID` | Your Apple Developer Team ID | ✅ Yes |
| `KEYCHAIN_PASSWORD` | Password for macOS keychain (can be any secure string) | ✅ Yes |

### iOS Specific

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `IOS_CERTIFICATE` | Base64 encoded iOS distribution certificate (.p12) | ✅ Yes |
| `IOS_CERTIFICATE_PASSWORD` | Password for the iOS certificate | ✅ Yes |
| `IOS_PROVISIONING_PROFILE` | Base64 encoded provisioning profile (.mobileprovision) | ✅ Yes |
| `IOS_BUNDLE_ID` | Your iOS app bundle identifier | ✅ Yes |

### App Store Connect API (Optional)

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `APP_STORE_CONNECT_API_KEY` | Base64 encoded App Store Connect API key (.p8) | ❌ Optional |
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API Key ID | ❌ Optional |
| `APP_STORE_CONNECT_ISSUER_ID` | App Store Connect Issuer ID | ❌ Optional |

### Windows Signing (Optional)

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `WINDOWS_CERTIFICATE` | Base64 encoded Windows code signing certificate | ❌ Optional |
| `WINDOWS_CERTIFICATE_PASSWORD` | Password for the Windows certificate | ❌ Optional |

## 📋 Setup Instructions

### 1. Android Keystore Setup

```bash
# Generate a new keystore (if you don't have one)
keytool -genkey -v -keystore release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-app-key

# Convert keystore to base64
base64 -i release-key.jks | pbcopy  # macOS
base64 -w 0 release-key.jks         # Linux
```

Add to GitHub secrets:
- `ANDROID_KEY_BASE64`: The base64 output
- `ANDROID_KEY_ALIAS`: `my-app-key` (or your chosen alias)
- `ANDROID_KEY_PASSWORD`: The password you set

### 2. Apple Developer Setup

#### Get your certificates:
1. Download your **Developer ID Application** certificate from Apple Developer portal
2. Export as `.p12` file with a password
3. Convert to base64:

```bash
base64 -i certificate.p12 | pbcopy  # macOS
base64 -w 0 certificate.p12         # Linux
```

#### Get your Team ID:
1. Go to [Apple Developer Account](https://developer.apple.com/account/)
2. Find your **Team ID** in the membership section

#### Create App-Specific Password:
1. Go to [Apple ID Account](https://appleid.apple.com/)
2. Sign in and go to **Security** section
3. Generate an **App-Specific Password**

Add to GitHub secrets:
- `APPLE_CERTIFICATE`: Base64 encoded certificate
- `APPLE_CERTIFICATE_PASSWORD`: Certificate password
- `APPLE_ID`: Your Apple ID email
- `APPLE_APP_SPECIFIC_PASSWORD`: The app-specific password
- `APPLE_TEAM_ID`: Your team ID
- `KEYCHAIN_PASSWORD`: Any secure password (e.g., `build-keychain-2024`)

### 3. iOS Specific Setup

#### Distribution Certificate:
1. Create/download **iOS Distribution** certificate from Apple Developer portal
2. Export as `.p12` with password
3. Convert to base64

#### Provisioning Profile:
1. Create **App Store** provisioning profile for your app
2. Download the `.mobileprovision` file
3. Convert to base64:

```bash
base64 -i profile.mobileprovision | pbcopy  # macOS
base64 -w 0 profile.mobileprovision         # Linux
```

Add to GitHub secrets:
- `IOS_CERTIFICATE`: Base64 encoded distribution certificate
- `IOS_CERTIFICATE_PASSWORD`: Certificate password
- `IOS_PROVISIONING_PROFILE`: Base64 encoded provisioning profile
- `IOS_BUNDLE_ID`: Your app's bundle identifier (e.g., `com.yourcompany.yourapp`)

### 4. App Store Connect API (Optional)

For automated App Store uploads:

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to **Users and Access** > **Keys**
3. Create a new API key with **Developer** role
4. Download the `.p8` file
5. Convert to base64:

```bash
base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy  # macOS
base64 -w 0 AuthKey_XXXXXXXXXX.p8         # Linux
```

Add to GitHub secrets:
- `APP_STORE_CONNECT_API_KEY`: Base64 encoded .p8 file
- `APP_STORE_CONNECT_API_KEY_ID`: The key ID (from filename)
- `APP_STORE_CONNECT_ISSUER_ID`: Your issuer ID (from App Store Connect)

## 🔧 Adding Secrets to GitHub

1. Go to your repository on GitHub
2. Navigate to **Settings** > **Secrets and variables** > **Actions**
3. Click **New repository secret**
4. Add each secret with the exact name from the tables above

## ✅ Verification

After adding all secrets, you can verify they're working by:

1. Pushing to the `main` branch
2. Checking the workflow logs for each platform
3. Looking for successful signing messages in the build outputs

## 🚨 Security Notes

- **Never commit certificates or keys to your repository**
- **Use strong passwords for all certificates**
- **Regularly rotate App-Specific Passwords**
- **Keep your certificates backed up securely**
- **Use separate certificates for development and distribution**

## 🔄 Updating Secrets

When certificates expire or need updating:

1. Generate/download new certificates
2. Convert to base64 using the same process
3. Update the corresponding GitHub secrets
4. Test with a new build

## 📞 Troubleshooting

### Common Issues:

1. **Base64 encoding**: Make sure there are no line breaks in your base64 strings
2. **Certificate passwords**: Verify passwords are correct
3. **Bundle IDs**: Ensure they match your provisioning profiles
4. **Team IDs**: Double-check the Team ID format
5. **Keystore aliases**: Verify the alias exists in your keystore

### Debug Commands:

```bash
# Check keystore contents
keytool -list -v -keystore release-key.jks

# Verify certificate
openssl pkcs12 -info -in certificate.p12

# Check provisioning profile
security cms -D -i profile.mobileprovision
```

For more detailed troubleshooting, check the individual workflow logs in the GitHub Actions tab.
