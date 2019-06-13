TITLE	RANDOMIZED SELECTION SORT 
; Demonstrates translated selection sort
; using and displaying a randomized array

INCLUDE Irvine32.inc
.data
entries DWORD 50 DUP(?)

.code
main PROC
	
	mov		esi,OFFSET entries	;
	mov		edx,TYPE entries	;
	call	FillArray			;
	Call	DisplayArray		;
	call	SelectionSort		;
	call	DisplayArray		;

exit
main ENDP

;---------------------------------------------------------------;
FillArray PROC													;
;					Description: Uses rng to decide length of	;
;								rand array and contents.		;
;								Requires TYPE of array in edx.	;
;								returns length of array in ecx.	;
;---------------------------------------------------------------;
	push	esi			; Store esi
	call	Randomize	; Seed rng
	mov		eax,41		; max range set to 40
	call	RandomRange	; Creates ran# 0-40
	add		eax,10		; Add 10 to make 10-50
	mov		ecx,eax		; Mov ran# to use as counter
	push	ecx			; Store ecx
	L1:	mov		eax,1000	; 0-999
		call	RandomRange	; random# 0-999 in eax
		add		eax,1		; ran# 1-1000
		mov		[esi],eax	; fill array element
		add		esi,edx		; Increment based on type
		Loop	L1			;
	pop		ecx			; Restore ecx
	pop		esi			; Restore esi
	ret
FillArray	ENDP

;---------------------------------------------------------------;
SelectionSort PROC												;
;					Description: Sorts an array from low to		;
;								high, requires length of array	;
;								in ecx and offset of array in	;
;								esi.							;
;---------------------------------------------------------------;
	pushad	; Store all registers
		
		shl		ecx,2	; (*4 for dword)
		mov		dl,-4	; 
		L1:	add		dl,4	; i++ (*4 for dword)
			cmp		dl,cl	; i >= array_size?
			jae		Next	; jump if i>=array_size
			mov		bl,dl	; lowest = i
			mov		dh,dl	; j = i

		L2:	add		dh,4			; j++ (*4 for dword)
			cmp		dh,cl			; j >= array_size
			jae		L3				; jump out if true
			push	ecx				; Store ecx
			movzx	ecx,dh			; esi = j
			movzx	edi,bl			; edi = lowest
			mov		eax,[esi+ecx]	; eax = array[j]
			cmp		eax,[esi+edi]	; array[j] >= array[lowest]?
			pop		ecx				; Restore ecx to array_size		
			jae		L2				; restart if true
			mov		bl,dh			; lowest = j
			jmp		L2				; Get rid of this

		L3:	push	ecx				; Store ecx
			movzx	ecx,dl			; esi = i
			movzx	edi,bl			; edi = lowest
			mov		eax,[esi+ecx]	; eax = array[i]
			push	eax				; store eax
			mov		eax,[esi+edi]	; eax = array[lowest]
			mov		[esi+ecx],eax	; array[i] = array[lowest]
			pop		eax				; eax = array[i]
			pop		ecx				; Restore ecx as array_size
			mov		[esi+edi],eax	; array[lowest] = array[i]
			jmp		L1				; Get rid of this

		Next:

	popad	;  Restore all registers
	ret
SelectionSort	ENDP

;---------------------------------------------------------------;
DisplayArray PROC												;
;					Description:	Displays all individual		;
;								elements of array with spaces	;
;								in between. Requires offset of	;
;								array in esi, TYPE of array in	;
;								edx.							;
;																;
;																;
;---------------------------------------------------------------;
	push	esi	; Store esi
	push	ecx	; Store ecx
	L1:	mov		eax,[esi]	; Move current element to be printed
		call	WriteDec	; print current element
		mov		al,' '		; Move space char to al
		call	WriteChar	; print current element
		add		esi,edx		; Increment based on type
		Loop L1				;
	call	Crlf; make output pretty
	call	Crlf; make output pretty
	pop		ecx	; Restore ecx
	pop		esi	; Restore esi

	ret
DisplayArray	ENDP
END main