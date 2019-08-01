import os
import sys
import xml.etree.cElementTree as ET

xml_file = sys.argv[1]
out_dir = sys.argv[2]
release_date = ''

context = ET.iterparse(xml_file, events=('start', ))
for event, elem in context:
    if elem.tag == 'experiments':
        release_date = elem.attrib['retrieved']
        elem.clear()
        break
del context

context = ET.iterparse(xml_file, events=('end', ))
for event, elem in context:
    if elem.tag == 'experiment':
        accession = elem.find('accession').text
        filename = os.path.join(out_dir, format(accession + "_experiment.xml"))
        with open(filename, 'w') as f:
            f.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
            f.write("<experiments retrieved=\"%s\">" % release_date)
            f.write(ET.tostring(elem).decode("utf-8") )
            f.write("</experiments>")
            elem.clear()
