import pexpect

child = pexpect.spawn("/data/data/com.termux/files/usr/bin/bash", ["-c", "echo p"])
child.expect(pexpect.EOF)
print(child.before.decode())
