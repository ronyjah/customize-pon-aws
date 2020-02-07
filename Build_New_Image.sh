#!/bin/sh
#
# CUSTOMIZE PON CPES
#

print_help()
{
    echo ""
    echo " PON CPEs Default Config Generator"
    echo ""
    echo " ./Build_New_Image.sh [<Product> <New Image Name File> <PON Vendor ID>]"
    echo ""
    echo " Examples:"
    echo "           ./Build_New_Image.sh ONU110B Nome-do-Provedor ITBS"
    echo "           ./Build_New_Image.sh ONT121W Nome-do-Provedor ITBS"
    echo "           ./Build_New_Image.sh ONT142NW Nome-do-Provedor ITBS"
    echo ""
}

decompress_rootfs()
{
    if [ -e "$WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root" ]; then
        rm -rf $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root
    fi

    if [ ! -e "$WORKDIR/Product_Images/$PRODUCT_MODEL/image-orig" ]; then
        mkdir $WORKDIR/Product_Images/$PRODUCT_MODEL/image-orig
    fi

    if [ ! -e "$WORKDIR/Product_Images/$PRODUCT_MODEL/image-new" ]; then
        mkdir $WORKDIR/Product_Images/$PRODUCT_MODEL/image-new
    fi

    tar -xf $WORKDIR/Product_Images/$PRODUCT_MODEL/img.tar -C $WORKDIR/Product_Images/$PRODUCT_MODEL/image-orig/

    cp -a $WORKDIR/Product_Images/$PRODUCT_MODEL/image-orig/* $WORKDIR/Product_Images/$PRODUCT_MODEL/image-new/

    cd $WORKDIR/Product_Images/$PRODUCT_MODEL/; $WORKDIR/Tools/unsquashfs4 image-orig/rootfs; cd $WORKDIR
    if [ $? -ne 0 ]
    then
        echo "Failed decompress img"
        exit 1
    fi

}

update_config_default()
{
    cp $WORKDIR/config.xml $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root/etc/config_default.xml
    if [ $? -ne 0 ]
    then
        echo "Failed config.xml"
        exit 1
    fi
}

update_pon_vendor_id()
{
    #perl -pi -e 's#<Value Name="PON_VENDOR_ID" Value="ITBS"/>#<Value Name="PON_VENDOR_ID" Value="'$PON_VENDOR_ID'"/>#' \
    #$WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root/etc/config_default_hs.xml
    echo 'V_ID=`mib get PON_VENDOR_ID`' >> $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root/etc/init.d/rc35
    echo "if [ "'"$V_ID"'" != $PON_VENDOR_ID ]; then" >> $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root/etc/init.d/rc35
    echo "  flash set PON_VENDOR_ID $PON_VENDOR_ID" >> $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root/etc/init.d/rc35
    echo '  G_SN=`flash get GPON_SN | sed '"'s/^.\{12\}//g'"'`' >> $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root/etc/init.d/rc35
    echo "  flash set GPON_SN $PON_VENDOR_ID"'$G_SN'"" >> $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root/etc/init.d/rc35
    echo "  reboot" >> $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root/etc/init.d/rc35
    echo 'fi' >> $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root/etc/init.d/rc35
}

compress_new_rootfs()
{
    if [ "$PRODUCT_MODEL" = "ONT121AC" ]; then
        $WORKDIR/Tools/mksquashfs $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root \
            $WORKDIR/Product_Images/$PRODUCT_MODEL/image-new/rootfs -comp xz -noappend
    else
        $WORKDIR/Tools/mksquashfs $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root \
            $WORKDIR/Product_Images/$PRODUCT_MODEL/image-new/rootfs -comp lzma -noappend
    fi
}

generate_new_tar_img()
{
    if [ ! -e "$WORKDIR/New_Custom_Image"  ]; then
        mkdir $WORKDIR/New_Custom_Image
    fi

    cd $WORKDIR/Product_Images/$PRODUCT_MODEL/image-new
    
    if [ "$PRODUCT_MODEL" = "ONT121AC" ]; then
        md5sum rootfs uImage fwu_ver hw_ver fwu.sh > md5.txt; chmod 755 md5.txt;
        tar -cf $WORKDIR/New_Custom_Image/img-$PRODUCT_MODEL-$IMG_NAME.tar hw_ver fwu_ver md5.txt fwu.sh uImage rootfs  
    else
        md5sum comnect_${CHIP_ID}_fwu.sh rootfs uImage fwu_ver > md5.txt; chmod 755 md5.txt;
        tar -cf $WORKDIR/New_Custom_Image/img-$PRODUCT_MODEL-$IMG_NAME.tar comnect*.sh fwu_ver md5.txt rootfs uImage
    fi
    if [ $? -ne 0 ]
    then
        echo "Failed mount img"
        exit 1
    fi
    chmod 777 $WORKDIR/New_Custom_Image/img-$PRODUCT_MODEL-$IMG_NAME.tar
}

build_clean()
{
    # clean squash
    rm -rf $WORKDIR/Product_Images/$PRODUCT_MODEL/squashfs-root
    rm -rf $WORKDIR/Product_Images/$PRODUCT_MODEL/image-new
    rm -rf $WORKDIR/Product_Images/$PRODUCT_MODEL/image-orig
    rm $WORKDIR/config.xml
}


WORKDIR=`pwd`

case $1 in
    "-h")
        print_help
        exit 1
    ;;
    "")
        print_help
        exit 1
    ;;
    "ONU110B")
        CHIP_ID="9601"
        PRODUCT_MODEL=$1
    ;;
    "ONT121W")
        CHIP_ID="9602C"
        PRODUCT_MODEL=$1
    ;;
    "ONT142NW")
        CHIP_ID="9607"
        PRODUCT_MODEL=$1
    ;;
    "ONT121AC")
        CHIP_ID="9607C"
        PRODUCT_MODEL=$1
    ;;   
    *)
        echo "Failed Invalid Option"
        exit 1
    ;;
esac

# ISP Name
IMG_NAME=$2

# OMCI VENDOR ID
if [ "$3" = "" ]; then
    PON_VENDOR_ID="ITBS"
else
    PON_VENDOR_ID=$3
fi

decompress_rootfs;

update_config_default;

update_pon_vendor_id;

compress_new_rootfs;

generate_new_tar_img;

build_clean;

echo "Success"
