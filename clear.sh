rm *.lst
rm *.o
find . -type f -executable -not -iname "*.*" -exec rm '{}' \;
clear

# find . -type f -executable -exec rm '{}' \;
# ls | grep -v "\." | xargs rm # The grep -v says "only allow filenames that don't contain a dot", 
                             # and the xargs rm says "then pass the list of filenames to rm".