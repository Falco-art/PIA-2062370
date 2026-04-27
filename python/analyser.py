import argparse, os, json
from Modulos.tools import setup_logging, read_json, write_json
from Modulos.datacleaner import dedupe_list
from Modulos.grafica import abuseipdb_lookup

logger = setup_logging('analyzer', 'logs/analyzer.log')

def analyze(input_path, output_path):
    logger.info("Starting analysis for %s", input_path)
    data = read_json(input_path)
    # Example: collect IPs from recon outputs
    ips = []
    for item in data.get('recon', []):
        ips.extend(item.get('ips', []))
    ips = dedupe_list([i.strip() for i in ips])
    results = {'summary': {}, 'ips': {}}
    for ip in ips:
        logger.info("Querying threat intel for %s", ip)
        intel = abuseipdb_lookup(ip)
        results['ips'][ip] = intel
    results['summary']['ip_count'] = len(ips)
    write_json(output_path, results)
    logger.info("Analysis saved to %s", output_path)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()
    if not os.path.exists(args.input):
        logger.error("Input not found: %s", args.input)
        raise SystemExit(2)
    analyze(args.input, args.output)

if __name__ == '__main__':
    main()
