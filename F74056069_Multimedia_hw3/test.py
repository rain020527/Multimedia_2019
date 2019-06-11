a = 'abc'
b = ["ab cd", "a b cd"]
for s in a:
    for c in b:
        if s in c:
            print(s)
