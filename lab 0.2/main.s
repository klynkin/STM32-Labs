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
	
	MOV32	R0, GPIOC_CRH				; адрес порта
	MOV		R1, #0x08					; 4-битная маска настроек для input pull-up/pull-down
	LDR		R2, [R0]					; считать порт
    BFI		R2, R1, #24, #4    			; скопировать биты маски в позицию PIN14
    STR		R2, [R0]					; загрузить результат в регистр настройки порта
	
	MOV32	R0, GPIOC_ODR				; адрес порта
	MOV		R1, #0x04					; 4-битная маска настроек для pull-up
	LDR		R2, [R0]					; считать порт
    BFI		R2, R1, #12, #4    			; скопировать биты маски в позицию PIN14
    STR		R2, [R0]					; загрузить результат в регистр настройки порта
	
	
	MOV32	R0, PERIPH_BB_BASE + \
			RCC_APB2ENR * 32 + \
			4 * 4						; вычисляем адрес для BitBanding 4-го бита регистра RCC_APB2ENR
										; BitAddress = BitBandBase + (RegAddr * 32) + BitNumber * 4
	MOV		R1, #1						; включаем тактирование порта C (в 5-й бит RCC_APB2ENR пишем '1`)
	STR 	R1, [R0]					; загружаем это значение
	
	MOV32	R0, GPIOC_CRH				; адрес порта
	MOV		R1, #0x03					; 4-битная маска настроек для Output mode 50mHz, Push-Pull ("0011")
	LDR		R2, [R0]					; считать порт
    BFI		R2, R1, #20, #4    			; скопировать биты маски в позицию PIN7
    STR		R2, [R0]					; загрузить результат в регистр настройки порта
	
	
	MOV		R7, #0
	MOV		R6,	#DELAY_VAL
	MOV		R8, #0
	MOV		R9, #0
	
loop									; Бесконечный цикл
	
	MOV32	R0, GPIOC_IDR				; адрес порта
	LDR		R2, [R0]					; считать порт
	MOV		R9, #0x0000A000				; 4-битная маска настроек для Output mode 50mHz, Push-Pull ("0011")
	;LSL		R2,	#17
	;LSR		R2,	#31
	;CMP		R2,0
	TST     R2, #0x4000
	IT		EQ
	BEQ		rising
	B		continue
		

rising	PROC
    MOV32	R0, GPIOC_ODR				; адрес порта выходных сигналов
	LDR		R1, [R0]	
	EOR		R1, 0x2000
	STR 	R1, [R0]					; загружаем в порт
	MOV32	R0,#DELAY_VAL
	B		loop
	ENDP
		
		
continue	
	MOV32	R0, #DELAY_VAL
	B		loop
	

delay		PROC						; Подпрограмма задержки
	PUSH	{R0}						; Загружаем в стек R0, т.к. его значение будем менять
										; псевдоинструкция Thumb (загрузить константу в регистр)
delay_loop
	CMP		R0, #0
	IT		NE
	SUBSNE	R0, #1						; SUB с установкой флагов результата
	IT 		NE
	BNE		delay_loop					; переход, если Z==0 (результат вычитания не равен нулю)
	POP		{R0}						; Выгружаем из стека R0
	BX		LR							; выход из подпрограммы (переход к адресу в регистре LR - вершина стека)
	ENDP

    END