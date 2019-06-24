import sys

for line in sys.stdin:
    line1 = line.strip()
    linedot = line1
    if '.' in line1:
        linedot = line1.replace('.', '\\.')

    a = "install\\.packages\\(.*\"" + line1 + "\".*\\)"
    b = "library\\(.*[\\\"']*?" + linedot + "[\\\"']*?.*\\)"
    c = "require\\(.*[\\\"']*?" + linedot + "[\\\"']*?.*\\)"
    print(a + ';' + line.strip())
    print(b + ';' + line.strip())
    print(c + ';' + line.strip())
