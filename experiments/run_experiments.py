import csv
import subprocess
import time
from tls_client.measure_handshake import measure

ALGOS = ["rsa", "ecdsa"]
DEPTHS = [0, 1, 2, 3]
PROTOCOLS = ["tls1_2", "tls1_3"]
REPS = 20

with open("data/results.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["algorithm", "depth", "protocol", "time_s", "bytes"])

    for algo in ALGOS:
        for depth in DEPTHS:
            subprocess.run(["bash", "certgen/generate_certs.sh", algo, str(depth)], check=True)
            for proto in PROTOCOLS:
                server = subprocess.Popen([
                    "bash", "tls_server/run_server.sh",
                    f"certs/{algo}_depth{depth}", "4433", proto
                ])
                time.sleep(1)
                for _ in range(REPS):
                    t, b = measure(f"certs/{algo}_depth{depth}/ca_bundle.pem", proto)
                    writer.writerow([algo, depth, proto, t, b])
                server.terminate()
                server.wait()
