# ANDROID_KEY_BASE64: demo-keystore-base64.txt
# ANDROID_KEY_PASSWORD: password you set in the cli
# ANDROID_KEY_ALIAS: In this case it's "demo"

keytool -genkey -v -keystore ./demo-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 demo
base64 -i ./demo-keystore.jks -o ./demo-keystore-base64.txt

