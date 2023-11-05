import sys
import yaml

args = sys.argv

if len(args) < 3 :
    print("Usage: python yaml2tcl.py <INPUT> <OUTPUT>")
    sys.exit(1)

ofile = open(args[2], 'w')

# directories
ofile.write('set ipdir ${tcldir}/${TOP}/${TOP}.srcs/sources_1/ip\n')
ofile.write('\n')

with open(args[1]) as file:
    obj = yaml.safe_load(file)
    for k in obj:
        ip = obj[k]
        name = ip['name']
        vendor = ip['vendor']
        version = ip['version']
        conf = ip['conf']

        # tcl write
        xci_path = '${ipdir}/' + name + '/' + name + '.xci'
        ofile.write('if {[get_ips ' + name + '] == {} } {\n')
        ofile.write('  if {[file exists ' + xci_path + ']} {\n' )
        ofile.write('    read_ip ' + xci_path + '\n')
        ofile.write('  } else {\n')
        ofile.write('    create_ip -name ' + k + ' -vendor ' + vendor + ' -version ' + str(version) + ' -module_name ' + name + '\n')
        ofile.write('    set_property -dict [list \\\n')
        for c in ip['conf']:
            ofile.write('      ' + c + ' ' + str(conf[c]) + ' \\\n')
        ofile.write('    ] [get_ips ' + name + ']\n')
        ofile.write('    generate_target all [get_files ' + xci_path + ']\n')
        ofile.write('  }\n')
        ofile.write('}\n')

ofile.close()
