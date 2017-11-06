# Rename all *.txt to *.text
for f in *.cu; do 
cp -- "$f" "${f%.cu}.cpp"
done
