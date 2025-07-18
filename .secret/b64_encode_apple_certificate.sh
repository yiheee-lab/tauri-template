# Change any .p12 in the same folder to base64 txt
for file in *.p12 *p8 *.mobileprovision ; do
  if [[ -f "$file" ]]; then
    base_name="${file%.p12}"
    openssl base64 -in "$file" -out "${base_name}.txt"
    echo "Converted $file to ${base_name}.txt"
  fi
done
