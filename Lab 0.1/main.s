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
			4 * 4						; вычисляем адрес для BitBanding 5-го бита регистра RCC_APB2ENR
										; BitAddress = BitBandBase + (RegAddr * 32) + BitNumber * 4
	MOV		R1, #1						; включаем тактирование порта D (в 5-й бит RCC_APB2ENR пишем '1`)
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
	
	CMP		R9,#0
	IT		EQ
	BEQ		rising
	
falling	PROC						
	
	SUBS 	R7,#1
	ITT		EQ
	MOVEQ	R9,#0
	MOVEQ	R7,#1
	SUB 	R8,R6,R7
	B 	continue
	ENDP

rising	PROC						
	
	ADD 	R7,#1
	SUBS 	R8,R6,R7
	IT		EQ
	MOVEQ	R9,#1
	B	continue
	ENDP

continue

    MOV32	R0, GPIOC_BSRR				; адрес порта выходных сигналов
	MOV 	R1, #(PIN13)				; устанавливаем вывод в '1'
	STR 	R1, [R0]					; загружаем в порт
	BL		delay						; задержка
	
	MOV		R1, #(PIN13 << 16)			; сбрасываем в '0'
	STR 	R1, [R0]					; загружаем в порт
	
	BL		delay2						; задержка

	B 		loop						; возвращаемся к началу цикла
	
	

delay		PROC						; Подпрограмма задержки
	PUSH	{R8}						; Загружаем в стек R0, т.к. его значение будем менять
										; псевдоинструкция Thumb (загрузить константу в регистр)
delay_loop
	CMP		R8,0
	IT		NE
	SUBSNE	R8, #1						; SUB с установкой флагов результата
	IT 		NE
	BNE		delay_loop					; переход, если Z==0 (результат вычитания не равен нулю)
	POP		{R8}						; Выгружаем из стека R0
	BX		LR							; выход из подпрограммы (переход к адресу в регистре LR - вершина стека)
	ENDP


delay2		PROC						; Подпрограмма задержки
	PUSH	{R7}						; Загружаем в стек R0, т.к. его значение будем менять
	;LDR		R7, =DELAY_VAL				; псевдоинструкция Thumb (загрузить константу в регистр)
delay_loop2
	SUBS	R7, #1						; SUB с установкой флагов результата
	IT 		NE
	BNE		delay_loop2					; переход, если Z==0 (результат вычитания не равен нулю)
	POP		{R7}						; Выгружаем из стека R0
	BX		LR							; выход из подпрограммы (переход к адресу в регистре LR - вершина стека)
	ENDP




    END