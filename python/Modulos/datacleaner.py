def normalize_ip(ip):
    return ip.strip()

def dedupe_list(items):
    seen = set()
    out = []
    for i in items:
        if i not in seen:
            seen.add(i)
            out.append(i)
    return out
