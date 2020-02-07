import os
import time


class Builder ():

    def __init__ (self, vendorid, firmware, config,model):
        self.vendorid = vendorid
        self.firmware = firmware
        self.config = config
        self.model = model

    def image_generator (self):

        # os.system('mv media/config.xml /usr/src/app/')
        # os.system('/usr/src/app/Build_New_Image.sh "{2}" "{0}" "{1}"'.format(self.firmware, self.vendorid,self.model))
        # os.system('rm -rf /usr/src/app/config.xml')
        # os.system('mv /usr/src/app/New_Custom_Image/img-"{1}"-"{0}".tar media/'.format(self.firmware,self.model))
        # os.system('rm -rf /usr/src/app/New_Custom_Image/img-"{1}"-"{0}".tar'.format(self.firmware,self.model))
        os.system('mv media/config.xml ~/customize-pon-cpes/')
        os.system('~/customize-pon-cpes/Build_New_Image.sh "{2}" "{0}" "{1}"'.format(self.firmware, self.vendorid,self.model))
        os.system('rm -rf ~/customize-pon-cpes/config.xml')
        os.system('mv ~/customize-pon-cpes/New_Custom_Image/img-"{1}"-"{0}".tar media/'.format(self.firmware,self.model))
        os.system('rm -rf ~/customize-pon-cpes/New_Custom_Image/img-"{1}"-"{0}".tar'.format(self.firmware,self.model))



    def removefile (self):
        os.system('rm -rf  media/img-"{1}"-"{0}".tar'.format(self.firmware,self.model))
        os.system('rm -rf ~/customize-pon-cpes/config.xml')
        os.system('rm -rf media/config.xml')
 
    def checkmodel(self,model):
        with open('media/config.xml') as f:
            for line in f:
                if  "DEVICE_NAME" in line:
                    if model in line:
                        f.close()
                        return True
                    else:
                        f.close()
                        return False

