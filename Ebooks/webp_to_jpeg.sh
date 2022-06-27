#!/bin/bash
for var in "$@"
do
    unzip "$var" -d temp_epub
    cd temp_epub
    sed -i 's/.webp/.png/g' OEBPS/content.opf
    sed -i 's/image.png/image\/png/g' OEBPS/content.opf
    # change every xhtml file webp to jpeg
    find OEBPS/xhtml -type f -exec sed -i "s/.webp/.png/g" {} \;
    
    #replace every webp with a png
    cd OEBPS/img
    for f in *
    do
        output=${f/webp/png}
        dwebp $f -o $output
        echo "convert $output -fuzz 10% -trim +repage $output"
        convert $output -fuzz 10% -trim +repage $output
    done
    sed -i "s/.webp/.png/g"
    #compress the images
    rm -rf *.webp
    trimage -d .
    cd ../../
    rm -rf "../$var"
    zip -r "../$var" *
    cd ..
    rm -rf temp_epub
    echo "$var"
done
