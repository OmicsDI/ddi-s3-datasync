import json
import os
import re
import sys
import xml.etree.cElementTree as ET

xml_file = sys.argv[1]
out_dir = sys.argv[2]

if not os.path.exists(out_dir):
    os.makedirs(out_dir)

context = ET.iterparse(xml_file, events=('end', ))
dbkeys = []
pattern = re.compile("^[a-zA-Z0-9-_]$")
result = {}
for event, elem in context:
    if elem.tag == 'ref':
        if elem.attrib['dbname'] == 'atlas':
            dbkeys.append(elem.attrib['dbkey'].lower())
    if elem.tag == 'entry':
        _id = elem.attrib['id']
        for dbkey in dbkeys:
            if dbkey in result:
                result[dbkey].append(_id)
            else:
                result[dbkey] = [_id]
        dbkeys.clear()
        elem.clear()
for dbkey in result:
    filename = ''.join(e for e in dbkey if pattern.match(e)).lower() + ".json"
    with open(os.path.join(out_dir, filename), 'w') as f:
        json.dump(result[dbkey], f)
