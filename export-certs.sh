# For an import arg, provide the URL of the target host

openssl s_client -showcerts -verify 5 -connect "$1":443 < /dev/null |
   awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/{ if(/BEGIN CERTIFICATE/){a++}; out="cert"a".temp.pem"; print >out}'
echo
C=0
for cert in *.temp.pem; do
  ((C=C+1))
  newname=$(openssl x509 -noout -subject -in $cert | sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').pem
  echo "$C-${newname}"; mv "${cert}" "$C-${newname}"
done
