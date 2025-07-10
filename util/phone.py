from phonenumbers import carrier
import phonenumbers
import sys,os

vard = sys.argv[1]
CaPh = phonenumbers.parse(str(vard), "ID")
print(carrier.name_for_number(CaPh, "id"))
