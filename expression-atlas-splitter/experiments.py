import os
import sys
import xml.etree.cElementTree as ET

xml_file = sys.argv[1]
out_dir = sys.argv[2]

if not os.path.exists(out_dir):
    os.makedirs(out_dir)

meta_data = {'entry_count': 0, 'release_date': '', 'name': '', 'description': ''}

context = ET.iterparse(xml_file, events=('start', ))
n_updated = 0
for event, elem in context:
    for key in meta_data:
        if elem.tag == key:
            meta_data[key] = elem.text
            n_updated += 1
            elem.clear()
    if n_updated == len(meta_data.keys()):
        break
del context

context = ET.iterparse(xml_file, events=('end', ))
for event, elem in context:
    if elem.tag == 'entry':
        accession = elem.attrib['id']
        filename = os.path.join(out_dir, accession.lower() + "_experiment.xml")
        with open(filename, 'w') as f:
            out = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
<database>\n\
<name>%s</name>\n\
<description>%s</description>\n\
<release />\n\
<release_date>%s</release_date>\n\
<entry_count>%s</entry_count>\n\
    <entries>\n\
    %s\
    </entries>\n\
</database>" % (meta_data['name'], meta_data['description'], meta_data['release_date'], meta_data['entry_count'],
                ET.tostring(elem).decode("utf-8"))
            f.write(out)
            elem.clear()
