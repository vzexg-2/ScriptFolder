#PasswordCrack
import zipfile
import time
import sys
import os
from time import sleep

print ("[LoadTime: 1.2s]")
print ("[Log] TERM:File.Running")
sleep(1.3)
os.system('clear')
print ("Zip file must be in the same folder in where you run the bruteforce.py, also for the wordlist too.")
print ("")
print ("[Confirmation] File cannot be found, please re enter.")
zip = raw_input(">> ")
print ("")
print ("[Confirmation] WordlistType_lst cannot be found, please re enter again with wordlist format .lst")
passfile = raw_input(">> ")
print ("[Success] TypeFile:" + zip +"")
print ("[Success] lst:" + passfile +"")
zfile = zipfile.ZipFile(zip)
passfile = open(passfile, "r")
for password in passfile.readlines():
    password = password.strip("\n").strip("\r")
    try:
        zfile.extractall(pwd=password)
        print ("[+] Password Found! >> " + password + " << ")
        time.sleep(500000)
        sys.exit()
    except Exception, e:
        loop="""
        [LoadTime: 1.20471s] Cracking... 
        """
        print(loop)
        os.system('clear')
        print (" [!] Searching > " + password +'')
