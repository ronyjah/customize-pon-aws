from django.shortcuts import render
from django.shortcuts import redirect
from django.core.files.storage import FileSystemStorage
from .forms import UploadFileForm
from django.http import HttpResponse
from django.http import HttpResponseRedirect
import datetime
import time
from .builder import *
from django.contrib import messages
from pprint import pprint
def inicio(request):
    return render(request, 'blog/inicio.html', {})

def loading(request):
    return render(request, 'upload/loading.html', {})

   

def upload(request):
    #print(request.environ.get('HTTP_USER_AGENT')) #funciona
    if request.method == 'POST':
        #pprint(vars(request))
        # return HttpResponse("<script>alert(Hello! I am an alert box!)</script>")
        #print(request.environ.get('HTTP_USER_AGENT')) #funciona
        #print (True if request.FILES == "" else False)
        firmware_name = request.POST.get('firmware', None)
        if firmware_name == "" : return render(request, 'blog/upload.html')
        doc = request.POST.get('document')
        if (doc == ""): return render(request, 'blog/upload.html')
        vendorid_name = request.POST.get('vendorid', None)
        vendor = vendorid_name.upper()
        model = request.POST.get('modelo', None)
        uploaded_file = request.FILES['document']
        fs = FileSystemStorage()
        name = fs.save(uploaded_file.name,uploaded_file)
        bb = Builder(vendor,firmware_name,uploaded_file,model)
        if bb.checkmodel(model) == False: 
            bb.removefile()
            messages.info(request, 'Modelo do produto não confere com o arquivo config.xml!')
            return render(request, 'blog/upload.html')
        bb.image_generator()
        response = HttpResponse(open('media/img-{1}-{0}.tar'.format(bb.firmware,bb.model), 'rb').read())
        response['Content-Type'] = 'text/plain'
        response['Content-Disposition'] = 'attachment; filename=img-"{1}"-"{0}".tar'.format(bb.firmware, bb.model)
        bb.removefile()
        return response
    return render(request, 'blog/upload.html')



