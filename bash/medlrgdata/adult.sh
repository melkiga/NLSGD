gsvm -u pairwise -P 2.0 -K 0.5 -i 5 -o 5 "../../../data/MedLrgData/adult" > "../../../Output/medlrgdata/adult2P05K.txt"
gsvm -u pairwise -P 1.0 -K 0.5 -i 5 -o 5 "../../../data/MedLrgData/adult" > "../../../Output/medlrgdata/adult1P05K.txt"
gsvm -u pairwise -P 2.0 -K 0.75 -i 5 -o 5 "../../../data/MedLrgData/adult" > "../../../Output/medlrgdata/adult2P075K.txt"
gsvm -u pairwise -P 1.0 -K 0.75 -i 5 -o 5 "../../../data/MedLrgData/adult" > "../../../Output/medlrgdata/adult1P075K.txt"
gsvm -u pairwise -P 2.0 -K 1.0 -i 5 -o 5 "../../../data/MedLrgData/adult" > "../../../Output/medlrgdata/adult2P1K.txt"
gsvm -u pairwise -P 1.0 -K 1.0 -i 5 -o 5 "../../../data/MedLrgData/adult" > "../../../Output/medlrgdata/adult1P1K.txt"