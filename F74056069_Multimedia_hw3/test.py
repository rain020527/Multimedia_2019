a = 'a bc'
b = ["ab cd", "a b cd", "a bd"]
for bb in b:
    if all(aa in bb for aa in a.replace(" ", "")):
        print(True)