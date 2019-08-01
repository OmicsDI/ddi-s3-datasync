import os
import re
import sys
import xml.etree.ElementTree as ET

xml_file = sys.argv[1]
out_dir = sys.argv[2]
release_date = ''

context = ET.iterparse(xml_file, events=('start', ))
for event, elem in context:
    if elem.tag == 'protocols':
        release_date = elem.attrib['retrieved']
        break

context = ET.iterparse(xml_file, events=('end', ))
pattern = re.compile("^[a-zA-Z0-9-_]$")
for event, elem in context:
    if elem.tag == 'protocol':
        accession = elem.find('accession').text
        name = ''.join(e for e in accession if pattern.match(e)).lower() + "_protocol.xml"
        filename = os.path.join(out_dir, name)
        with open(filename, 'w') as f:
            f.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
            f.write("<protocols retrieved=\"%s\">" % release_date)
            f.write(ET.tostring(elem).decode("utf-8"))
            f.write("</protocols>")
            elem.clear()
