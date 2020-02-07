import time
import os

def buildGenerator(n,nvendor,nfirmware):
    print ('nome do arquivo')
    print (n)
    print ('nome do firmware')
    print (nfirmware)
    print ('nome do nvendor')
    print (nvendor)
    os.system('ls')
    os.system('cp media/config.xml /home/ronaldo/tutorial/customize-pon-cpes')
    os.system('/home/ronaldo/tutorial/customize-pon-cpes/Build_New_Image.sh ONT121W "{0}" "{1}"'.format(nfirmware, nvendor))
    time.sleep (7)
    os.system('cp /home/ronaldo/tutorial/customize-pon-cpes/New_Custom_Image/img-ONT121W-tested.tar media/')
    file = open('/home/ronaldo/tutorial/customize-pon-cpes/New_Custom_Image/img-ONT121W-tested.tar','r')
    return file
    
    



    