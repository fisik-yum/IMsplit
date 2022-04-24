#!/bin/bash

#This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

usage() { echo "Usage: $0 [-w width ] [-s sections] [-i input file]" 1>&2; exit 1; }

while getopts ":w:s:i:" o; do
    case "${o}" in
        w)
            w=${OPTARG}
            ([[ $w =~ ^[+-]?[0-9]+$ ]]) || usage 
            ;;
        s)
            s=${OPTARG}
            ([[ $s =~ ^[+-]?[0-9]+$ ]]) || usage 
            ;;
        i)
            i=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${w}" ] || [ -z "${s}" ] || [ -z "${i}" ]; then
    usage
fi

echo "Inital file ${i}"
echo "Final Crop ${w}"
echo "Split into ${s} section(s)"
read -n 1 -s -r -p "Press any key to continue"

if [ -d "split" ]; then
    rm -rf split/
else
    rm split*
fi
mkdir split
convert -crop $(($s*$w))x$w $i sourceimg.png

if [ -f "sourceimg.png" ]; then
    mv sourceimg.png split && cd split 
    convert -crop $(($w))x$w sourceimg.png spl.png
    rm sourceimg.png
else
    mv sourceimg-0.png split
    rm sourceimg*.png && cd split
    convert -crop $(($w))x$w sourceimg-0.png spl.png
    rm sourceimg-0.png
fi
echo "Completed!"



