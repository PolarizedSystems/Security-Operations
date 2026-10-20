#!/bin/bash
# generate-test-logins.sh
# Detection test (authorized, lab only). Run from soc-kali-001 against a lab target.
# Sends deliberate failed SMB logons so the defender can confirm Windows logs them
# as Event ID 4625 and can be found with the PowerShell hunting script.
for i in $(seq 15); do
    smbclient -L //192.168.20.2 -U "testuser%WrongPassword$i" 2>/dev/null
done
