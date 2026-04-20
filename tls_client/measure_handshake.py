import subprocess
import time
import re

PATTERN = re.compile(r"SSL handshake has read (\\d+) bytes and written (\\d+) bytes")


def measure(cafile, protocol="tls1_3"):
    flag = "-tls1_3" if protocol == "tls1_3" else "-tls1_2"
    start = time.perf_counter()
    p = subprocess.run([
        "openssl", "s_client",
        "-connect", "localhost:4433",
        "-CAfile", cafile,
        flag,
        "-brief"
    ], capture_output=True, text=True)
    elapsed = time.perf_counter() - start

    match = PATTERN.search(p.stdout + p.stderr)
    if match:
        read_b, write_b = map(int, match.groups())
    else:
        read_b = write_b = -1

    return elapsed, read_b + write_b
