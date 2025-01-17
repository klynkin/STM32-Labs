	PRESERVE8							; 8-битное выравнивание стека
	THUMB								; Режим Thumb (AUL) инструкций

	GET	config.s						; include-файлы
	GET	stm32f10x.s	

	AREA RESET, CODE, READONLY

	; Таблица векторов прерываний
	DCD STACK_TOP						; Указатель на вершину стека
	DCD Reset_Handler					; Вектор сброса

	ENTRY								; Точка входа в программу

Reset_Handler	PROC					; Вектор сброса
	EXPORT  Reset_Handler				; Делаем Reset_Handler видимым вне этого файла

main									; Основная подпрограмма
	MOV32	R0, PERIPH_BB_BASE + \
			RCC_APB2ENR * 32 + \
			4 * 4						; вычисляем адрес для BitBanding 4-го бита регистра RCC_APB2ENR
										; BitAddress = BitBandBase + (RegAddr * 32) + BitNumber * 4
	MOV		R1, #1						; включаем тактирование порта C (в 4-й бит RCC_APB2ENR пишем '1`)
	STR 	R1, [R0]					; загружаем это значение
	
	
	
	MOV32	R0, PERIPH_BB_BASE + \
			RCC_APB2ENR * 32 + \
			2 * 4						; вычисляем адрес для BitBanding 2-го бита регистра RCC_APB2ENR
										; BitAddress = BitBandBase + (RegAddr * 32) + BitNumber * 4
	MOV		R1, #1						; включаем тактирование порта A (в 2-й бит RCC_APB2ENR пишем '1`)
	STR 	R1, [R0]					; загружаем это значение
	

	;A6
	MOV32	R0, GPIOA_CRL				; адрес порта
	MOV32	R1, #0x03333333				; 4-битная маска настроек для Output mode 50mHz, Push-Pull ("0011")
	LDR		R2, [R0]					; считать порт
    BFI		R2, R1, #0, #28    			; скопировать биты маски в позицию PIN0-PIN6
    STR		R2, [R0]					; загрузить результат в регистр настройки порта
	
	MOV32	R0, GPIOC_CRL				; адрес порта
	MOV		R1, #0x04					; 4-битная маска настроек для input pull-up/pull-down
	LDR		R2, [R0]					; считать порт
    BFI		R2, R1, #4, #4    			; скопировать биты маски в позицию PIN1
    STR		R2, [R0]					; загрузить результат в регистр настройки порта
	
	
	MOV		R8,#0						;счетчик
	MOV		R9,#0
loop									; Бесконечный цикл

	MOV32	R0, GPIOC_IDR				; адрес порта
	LDR		R2, [R0]					; считать порт
	TST     R2, #0x00000002
	BL		delay
	MOV32	R0, GPIOC_IDR				; адрес порта
	LDR		R2, [R0]					; считать порт
	TST     R2, #0x00000002
	IT		NE
	BNE		loop						; возвращаемся к началу цикла
	
	MOV32	R0, GPIOA_ODR				; адрес порта выходных сигналов
	LDR 	R1, [R0]					; загружаем в порт
	AND		R1, #0x0000
	STR 	R1, [R0]					; загружаем в порт
	BL		analizing
	
	MOV32	R0, GPIOA_ODR				; адрес порта выходных сигналов
	LDR 	R1, [R0]					; загружаем в порт
	CMP R8,#1
	EOREQ	R1, #0x003F
	CMP R8,#2
	EOREQ	R1, #0x0006
	CMP R8, #3
	EOREQ	R1, #0x005B
	CMP R8, #4
	EOREQ	R1, #0x004F
	CMP R8, #5
	EOREQ	R1, #0x0066
	CMP R8, #6
	EOREQ	R1, #0x006D
	CMP R8, #7
	EOREQ	R1, #0x007D
	CMP R8, #8
	EOREQ	R1, #0x0007
	CMP R8, #9
	EOREQ	R1, #0x007F
	CMP R8, #10
	EOREQ	R1, #0x006F
	STR 	R1, [R0]	
	B loop
	ENDP


delay		PROC						; Подпрограмма задержки
	PUSH	{R0}						; Загружаем в стек R0, т.к. его значение будем менять
	LDR		R0, =DELAY_VAL				; псевдоинструкция Thumb (загрузить константу в регистр)
delay_loop
	SUBS	R0, #1						; SUB с установкой флагов результата
	IT 		NE
	BNE		delay_loop					; переход, если Z==0 (результат вычитания не равен нулю)
	POP		{R0}						; Выгружаем из стека R0
	BX		LR							; выход из подпрограммы (переход к адресу в регистре LR - вершина стека)
	ENDP
	
	
			
analizing PROC
	CMP R9,0
	IT	EQ
	BEQ	up
down	
	SUB	R8,#1	
	CMP	R8,#1
	MOVEQ	R9,0
	B continue
up	
	CMP	R8,#9
	MOVEQ	R9,1
	ADD	R8,#1	
continue
	BX LR
	ENDP
		
    END
