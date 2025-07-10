#!/usr/bin/bash

## threading module

## author : Bayu Rizki A.M
## create : 28/05/2025

#set -Eeo pipefail

declare -g __registry__=""

# handle error
HANDLE.ERR(){
	local msg="${1}"
	local lineno=${BASH_LINENO[0]}
	local ERROR="${2:-${BASH_COMMAND}}"
	Std.log: ERROR "\e[92mSyntax \e[94m> \e[91m${ERROR} \e[93m(\e[90m0xffffff\e[93m)" >&2
	Std.log: DEBUG "\e[96mmsg \e[92m~ \e[96m${msg} \e[91m<\e[93m=\e[91m> \e[96mLINE \e[91m[\e[93m$lineno\e[91m]" >&2
	exit $?
}

#trap "HANDLE.ERR \"\e[97mTerjadi Kesalahan Tidak DI ketahui\" ''" ERR

################################################################################
function core(){
	__init__(){
		local namespace="${1}"
		shopt -s expand_aliases # TODO: menjumlah kapasitas alias
		# definisikan
		eval "${namespace}.multicore:(){ core.__init__.multicore \$@; }"
	}

	core.__init__.multicore(){
# 		local Pylib=$(cat << EOF
# #!/usr/bin/env python3
# import os
# import sys
# import pexpect
# from concurrent.futures import ThreadPoolExecutor
# import json
# import shlex
# 
# def run_command(cmd):
#     try:
#         # Escape dengan aman
#         bash_cmd = f"/data/data/com.termux/files/usr/bin/bash -c {shlex.quote(cmd)}"
#         child = pexpect.spawn(bash_cmd, encoding='utf-8',timeout=300)
#         child.expect(pexpect.EOF)
#         return child.before.strip()
#     except Exception as e:
#         return f"[ERROR] {cmd} -> {str(e)}"
#     # os.system(f"{cmd}")
# 
# concurrency = __CONCURRENCY__
# commands = "__DATA__".split(";")
# 
# with ThreadPoolExecutor(max_workers=concurrency) as executor:
#     results = executor.map(run_command, commands)
#     for output in results:
#         print(output)
# EOF
# 		) # TODO: gunakan kemampuan threading dengan python FFI
		local Pylib=$(cat << 'EOF'
#!/usr/bin/env python3
import subprocess
from concurrent.futures import ThreadPoolExecutor
import shlex

def run_command(cmd):
    try:
        # Jalankan via bash -c agar bisa mengakses fungsi yang sudah diexport
        result = subprocess.run(
            ["/data/data/com.termux/files/usr/bin/bash", "-c", cmd],
            capture_output=True,
            text=True,
            timeout=300
        )
        if result.returncode == 0:
            return result.stdout.strip()
        else:
            return f"[ERROR] {cmd} -> {result.stderr.strip()}"
    except subprocess.TimeoutExpired:
        return f"[ERROR] {cmd} -> Timeout exceeded."
    except Exception as e:
        return f"[ERROR] {cmd} -> {str(e)}"

concurrency = __CONCURRENCY__
commands = "__DATA__".split(";")

with ThreadPoolExecutor(max_workers=concurrency) as executor:
    results = executor.map(run_command, commands)
    for output in results:
        print(output)
EOF
		)

		# __CONCURRENCY__ = payload concurrency
		# __DATA__        = payload perintah command
		# { this="argsparser";parsel.all "$1"; }
		# eval "${argsparser[@]}" || {
		# 	HANDLE.ERR "Argument Keluar konsep / tidak valid"
		# 	exit 0
		# } # cmd, worker
		local comd="${cmd}"
		local worker="${1}"

		{
			PyInput=$(io.write "${Pylib}"|sed "s+__DATA__+${comd}+g"|sed "s+__CONCURRENCY__+${worker}+g") # TODO: injeksi payload
			python -c "${PyInput}"
		} || {
			HANDLE.ERR "Argument Keluar konsep / tidak valid"
			exit 0
		}
		
	}

	__init__ "$1"
}

Namespace: [Std::shell:Register]
