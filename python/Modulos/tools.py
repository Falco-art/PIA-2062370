import logging, os, json
from logging.handlers import RotatingFileHandler

def setup_logging(name='analyzer', logfile='logs/analyzer.log'):
    os.makedirs(os.path.dirname(logfile) or '.', exist_ok=True)
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)
    if not logger.handlers:
        handler = RotatingFileHandler(logfile, maxBytes=5*1024*1024, backupCount=3)
        fmt = logging.Formatter('%(asctime)s | %(name)s | %(levelname)s | %(message)s')
        handler.setFormatter(fmt)
        logger.addHandler(handler)
    return logger

def read_json(path):
    with open(path, 'r', encoding='utf8') as f:
        return json.load(f)

def write_json(path, data):
    os.makedirs(os.path.dirname(path) or '.', exist_ok=True)
    with open(path, 'w', encoding='utf8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
