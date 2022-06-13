openssl s_client -showcerts -verify 5 -servername "$1" -connect "$1":443 < /dev/null |
   awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/{ if(/BEGIN CERTIFICATE/){a++}; out="cert"a".temp.pem"; print >out}'
echo
C=0
for cert in *.temp.pem; do
  ((C=C+1))
  newname=$(openssl x509 -noout -subject -in $cert | \
    sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').pem
  newname=$(echo "$C-${newname}" | sed -e 's/[^A-Za-z0-9._-]/_/g')
  echo "${newname}"
  mv "${cert}" "${newname}"
done
