# GitHub Actions Workflows

This directory contains a unified CI/CD pipeline for building and releasing Tauri applications across all platforms.

## 🏗️ Workflow Architecture

### Main Workflows

| Workflow | Purpose | Trigger | Description |
|----------|---------|---------|-------------|
| **main.yml** | CI/CD Pipeline | Push to main, PR, Manual | Builds all platforms in parallel |
| **release.yml** | Release Creation | Tag push, Manual | Creates unified release with proper naming |

### Platform-Specific Build Workflows

| Workflow | Platform | Artifacts | Signing |
|----------|----------|-----------|---------|
| **build-windows.yml** | Windows | `.msi`, `.exe` | ❌ Unsigned |
| **build-macos.yml** | macOS | `.dmg`, `.app.tar.gz` | ✅ Code signing + Notarization |
| **build-linux.yml** | Linux | `.deb`, `.rpm`, `.AppImage` | ❌ Unsigned |
| **build-android.yml** | Android | `.apk`, `.aab` | ✅ Optional signing |
| **build-ios.yml** | iOS | `.ipa` | ✅ Code signing + Provisioning |

## 📁 Artifact Naming Convention

All artifacts follow the unified naming convention:
```
{name}-{version}-{platform}-{architecture}.{extension}
```

### Examples:
- `tauri-template-1.0.0-win-x64.msi`
- `tauri-template-1.0.0-mac-arm64.dmg`
- `tauri-template-1.0.0-linux-x64.deb`
- `tauri-template-1.0.0-android-arm64.apk`
- `tauri-template-1.0.0-ios-arm64.ipa`

## 🚀 Usage

### Development Workflow (CI/CD Pipeline)

Triggered automatically on:
- Push to `main` branch
- Pull requests to `main` branch
- Manual dispatch

```bash
# Workflow runs automatically, or trigger manually:
gh workflow run "CI/CD Pipeline"
```

### Release Workflow

Triggered by:
- Creating a git tag: `git tag v1.0.0 && git push origin v1.0.0`
- Manual dispatch with version input

```bash
# Create and push a tag
git tag v1.0.0
git push origin v1.0.0

# Or trigger manually
gh workflow run "Release" -f version=1.0.0
```

## 🔐 Required Secrets

See [SECRETS.md](../SECRETS.md) for detailed setup instructions.

### Quick Reference:

#### iOS (Required for iOS builds):
- `IOS_CERTIFICATE`
- `IOS_CERTIFICATE_PASSWORD`
- `IOS_PROVISIONING_PROFILE`
- `APPLE_TEAM_ID`
- `IOS_BUNDLE_ID`
- `KEYCHAIN_PASSWORD`

#### macOS (Required for macOS builds):
- `APPLE_CERTIFICATE`
- `APPLE_CERTIFICATE_PASSWORD`
- `KEYCHAIN_PASSWORD`
- `APPLE_ID`
- `APPLE_APP_SPECIFIC_PASSWORD`
- `APPLE_TEAM_ID`

#### Android (Optional for signed builds):
- `ANDROID_KEYSTORE`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

## 📊 Build Matrix

### Supported Platforms & Architectures:

| Platform | Architecture | Target Triple | Runner |
|----------|-------------|---------------|---------|
| Windows | x64 | `x86_64-pc-windows-msvc` | `windows-latest` |
| macOS | x64 | `x86_64-apple-darwin` | `macos-latest` |
| macOS | arm64 | `aarch64-apple-darwin` | `macos-latest` |
| Linux | x64 | `x86_64-unknown-linux-gnu` | `ubuntu-22.04` |
| Android | arm64 | `aarch64-linux-android` | `ubuntu-latest` |
| iOS | arm64 | `aarch64-apple-ios` | `macos-latest` |

## 🔧 Workflow Features

### Performance Optimizations:
- ✅ Rust dependency caching
- ✅ Node.js dependency caching
- ✅ Gradle caching (Android)
- ✅ Android SDK caching
- ✅ Parallel builds across platforms

### Security Features:
- ✅ Code signing for Apple platforms
- ✅ Android app signing (optional)
- ✅ Secure secret management
- ✅ Environment-based protection

### Quality Assurance:
- ✅ Build status reporting
- ✅ Artifact validation
- ✅ Detailed build summaries
- ✅ Error handling and cleanup

## 📋 Build Status

The main workflow provides a comprehensive build summary showing:
- ✅/❌ Build status for each platform
- 📦 Artifact generation status
- 🔗 Links to download artifacts
- 📊 Build duration and resource usage

## 🛠️ Customization

### Adding New Platforms:
1. Create a new `build-{platform}.yml` workflow
2. Follow the existing pattern with proper outputs
3. Add to the main workflow's needs array
4. Update the build summary

### Modifying Build Configuration:
- Edit platform-specific workflows
- Update build commands and targets
- Modify artifact paths and naming
- Adjust caching strategies

### Environment Configuration:
- Use GitHub Environments for sensitive operations
- Configure protection rules for production deployments
- Set up approval workflows for releases

## 🐛 Troubleshooting

### Common Issues:

1. **Missing Secrets**: Check [SECRETS.md](../SECRETS.md) for required secrets
2. **Build Failures**: Check individual workflow logs for detailed errors
3. **Artifact Issues**: Verify file paths and naming conventions
4. **Signing Problems**: Ensure certificates and profiles are valid

### Debug Steps:
1. Check workflow run logs
2. Verify secret configuration
3. Test locally with same commands
4. Review platform-specific requirements

## 📚 Resources

- [Tauri Documentation](https://tauri.app/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Android Developer Documentation](https://developer.android.com/docs)
