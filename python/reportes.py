import argparse, json, os
from Modulos.tools import setup_logging, write_json

python python/reportes.py --input resultados/analysis.json --html resultados/reporte.html --json resultados/reporte.json

logger = setup_logging('report_generator', 'logs/report_generator.log')

HTML_TEMPLATE = """
<html><head><meta charset="utf-8"><title>Reporte</title></head><body>
<h1>Reporte de Análisis</h1>
<p>IP count: {ip_count}</p>
<h2>Detalles</h2>
<ul>
{items}
</ul>
</body></html>
"""

def generate(analysis_json, out_html, out_json):
    with open(analysis_json, 'r', encoding='utf8') as f:
        data = json.load(f)
    ip_count = data.get('summary', {}).get('ip_count', 0)
    items = ""
    for ip, info in data.get('ips', {}).items():
        items += f"<li><b>{ip}</b>: {info.get('data', info)}</li>"
    html = HTML_TEMPLATE.format(ip_count=ip_count, items=items)
    os.makedirs(os.path.dirname(out_html) or '.', exist_ok=True)
    with open(out_html, 'w', encoding='utf8') as f:
        f.write(html)
    write_json(out_json, data)
    logger.info("Report generated: %s and %s", out_html, out_json)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--html', required=True)
    parser.add_argument('--json', required=True)
    args = parser.parse_args()
    generate(args.input, args.html, args.json)

if __name__ == '__main__':
    main()
