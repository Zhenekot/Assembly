masm
model small

.stack 256
.data
text db 'When the carriage drove into the courtyard, the gentleman was greeted by the inns servant, as they are called in Russian inns, lively and fidgety to such an extent$'
	 db 'that it was even impossible to see what kind of face he had. He ran out quickly, with a napkin in his hand, all long and in a long demicoton coat with a back almost on the back of his head, '
	 db 'shook his hair and quickly led the gentleman up the entire wooden gallery to show the peace God had sent him. Peace was of a certain kind, for the hotel was also of a certain kind, that is, just '
	 db 'like there are hotels in provincial cities, where for two rubles a day, travelers receive a quiet room with cockroaches peeking out like prunes from all corners, and a door to the next room, always '
	 db 'filled with a chest of drawers, where a neighbor settles down, a silent and calm person, but extremely curious, interested in knowing about all the details of the passing. The exterior facade of the hotel '
	 db 'corresponded to its interior: it was very long, two floors high; the lower one was not tanned and remained in dark red bricks, even more darkened by the dashing weather changes and dirty in themselves; the '
	 db 'upper one was painted with eternal yellow paint; there were benches with clamps, ropes and steering wheels at the bottom. In one of these coal shops, or, better, in the window, there was a man with a samovar '
	 db 'made of red copper and a face as red as a samovar, so that from a distance one would think that there were two samovars on the window, if one samovar was not with a jet-black beard. '
	 db 'While the visiting gentleman was examining his room, his belongings were brought in: first of all, a suitcase made of white leather, somewhat worn, showing that it was not the first time on the road. '
	 db 'The suitcase was carried in by the coachman Selifan, a short man in a sheepskin coat, and the footman Petrushka, a young man of about thirty, in a spacious second-hand coat, as can be seen from the master s shoulder, '
	 db 'a little harsh looking fellow, with very large lips and nose. After the suitcase was brought in a small mahogany casket with pieces of Karelian birch, shoe pads and fried chicken wrapped in blue paper.$ '

.code

main: 
	mov ax, @data
	mov ds, ax

	
	
	
	
	
	mov ah, 7
	int 21h
	mov ax, 4c00h
	int 21h
end main