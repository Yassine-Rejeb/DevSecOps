#! /usr/bin/bash

crumb=$(curl -u "M0D4S:11674cac13aef1fa8a70d00a8e3e152ce0" -s 'http://remote_jenkins:8080/crumbIssuer/api/json' | jq -r '.crumbRequestField + ":" + .crumb')

# Create user chxmxii
echo "chxmxii:chxmxii_pass"
curl -u "M0D4S:11674cac13aef1fa8a70d00a8e3e152ce0" -X POST -H "Content-Type:application/x-www-form-urlencoded" "http://remote_jenkins:8080/securityRealm/createAccountByAdmin" -H "$crumb" --data-urlencode "username=chxmxii" --data-urlencode "password1=chxmxii_pass" --data-urlencode "password2=chxmxii_pass" --data-urlencode "fullname=Mouhib Ch" --data-urlencode "email=chx@mail.me"

# Create user iheb
echo "iheb:iheb_pass"
curl -u "M0D4S:11674cac13aef1fa8a70d00a8e3e152ce0" -X POST -H "Content-Type:application/x-www-form-urlencoded" "http://remote_jenkins:8080/securityRealm/createAccountByAdmin" -H "$crumb" --data-urlencode "username=iheb" --data-urlencode "password1=iheb_pass" --data-urlencode "password2=iheb_pass" --data-urlencode "fullname=Iheb Mastouri" --data-urlencode "email=iheb@mail.me"

# Create user amine
curl -u "M0D4S:11674cac13aef1fa8a70d00a8e3e152ce0" -X POST -H "Content-Type:application/x-www-form-urlencoded" "http://remote_jenkins:8080/securityRealm/createAccountByAdmin" -H "$crumb" --data-urlencode "username=amine" --data-urlencode "password1=amine_pass" --data-urlencode "password2=amine_pass" --data-urlencode "fullname=Amine Klibi" --data-urlencode "email=amine@mail.me"

# Create user ahmed
curl -u "M0D4S:11674cac13aef1fa8a70d00a8e3e152ce0" -X POST -H "Content-Type:application/x-www-form-urlencoded" "http://remote_jenkins:8080/securityRealm/createAccountByAdmin" -H "$crumb" --data-urlencode "username=ahmed" --data-urlencode "password1=ahmed_pass" --data-urlencode "password2=ahmed_pass" --data-urlencode "fullname=Ahmed Brahim" --data-urlencode "email=ahmed@mail.me"
