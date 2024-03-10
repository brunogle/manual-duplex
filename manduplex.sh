#!/bin/bash

pdf_input="$1"

printer="Samsung_M2020_Series"



if (( $(qpdf --show-npages "$pdf_input") % 2 == 0 )); then
    echo "The PDF has an even number of pages."


    qpdf --empty --rotate=+180 --pages $pdf_input z-1:odd  -- "${pdf_input}.even.pdf"
    qpdf --empty --pages $pdf_input 1-z:odd  -- "${pdf_input}.odd.pdf"


else
    echo "The PDF has an odd number of pages."

    echo "" | ps2pdf -sPAPERSIZE=a4 - blank.pdf

    qpdf --empty --rotate=+180 --pages blank.pdf $pdf_input z-1:odd  -- "${pdf_input}.even.pdf"
    qpdf --empty --pages $pdf_input 1-z:odd  -- "${pdf_input}.odd.pdf"

    rm blank.pdf
fi


num_odd_pages=$(qpdf --show-npages "${pdf_input}.odd.pdf")
num_even_pages=$(qpdf --show-npages "${pdf_input}.even.pdf")

echo "Printing odd pages (${num_odd_pages})"
lp -d ${printer} "${pdf_input}.odd.pdf"

read -p "Place pages back on tray and press ENTER..."

echo "Printing even pages (${num_even_pages})"
lp -d ${printer} "${pdf_input}.even.pdf"

rm "${pdf_input}.odd.pdf"
rm "${pdf_input}.even.pdf"
