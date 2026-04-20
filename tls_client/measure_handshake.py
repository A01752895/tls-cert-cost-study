import subprocess
import time

def measure():
    start = time.perf_counter()
    subprocess.run(["openssl", "s_client", "-connect", "localhost:4433"], stdout=subprocess.DEVNULL)
    return time.perf_counter() - start
