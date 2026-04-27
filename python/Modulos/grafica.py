import os, requests, time

def abuseipdb_lookup(ip):
    key = os.getenv('ABUSEIPDB_KEY')
    if not key:
        return {'error': 'no_api_key'}
    url = 'https://api.abuseipdb.com/api/v2/check'
    headers = {'Key': key, 'Accept': 'application/json'}
    params = {'ipAddress': ip, 'maxAgeInDays': 90}
    for attempt in range(3):
        r = requests.get(url, headers=headers, params=params, timeout=10)
        if r.status_code == 200:
            return r.json()
        time.sleep(2 ** attempt)
    return {'error': f'status_{r.status_code}'}
