				PRESERVE8    ; instruct is aligned by 8 bytes 指令集8字节对齐
                THUMB        ; use Thumb instruction set    使用thumb指令集
					
				AREA    RESET, DATA, READONLY  ;DATA定义数据段，READONLY只读
				EXPORT  __Vectors  

CODE_START_ADDR   EQU     0x800B000

__Vectors       DCD     0x20000000+0x10000   ; CPU自动取改处的值设置为栈顶 Top of Stack
                DCD     Reset_Handler           ; Reset Handler
				
				AREA    |.text|, CODE, READONLY    ; CODE表示定义代码段，READONLY只读
; Reset handler
Reset_Handler    PROC                 ; 子程序开始标志
				 EXPORT  Reset_Handler             [WEAK]   ; 导出Reset_Handler全局可见以及弱定义
				 IMPORT  xmain         ; 导入main，类似C语言的extern main，声明main由外部定义
                 LDR     sp, = (0x20000000+0x10000)  ; 设置栈,只有设置了栈才能跳到C语言的世界执行
				 
				 ;LDR R3, = relocate_data
				 ;BX  R3
				 
				 ;LDR R3,= clear_bss
				 ;BX  R3
				 
				 LDR R0, = |Load$$RW_IRAM1$$RW$$Base| 
				 LDR R1, = |Image$$RW_IRAM1$$RW$$Base|
				 LDR R2, = |Image$$RW_IRAM1$$RW$$Length|
				 
				 BL c_relocate_data
				 
				 LDR R0, = |Image$$RW_IRAM1$$ZI$$Base| 
				 LDR R1, = |Image$$RW_IRAM1$$ZI$$Length| 
				 MOV R2 , #0
				 BL     c_clear_bss
				 
				 BL  xmain
                              
         
                 ENDP				; 子程序结束标志
;重定位数据段					 
relocate_data   PROC    
				;EXPORT  relocate_data 
				IMPORT c_relocate_data
				IMPORT |Image$$RW_IRAM1$$RW$$Base|     ; 数据段的加载起始地址(源)
                IMPORT |Image$$RW_IRAM1$$RW$$Length|  ; 数据段的长度(长度)		
				
				;IMPORT |Image$$ER_IROM1$$Length|
				;IMPORT |Image$$ER_IROM1$$Base|
				IMPORT |Load$$RW_IRAM1$$RW$$Base|     ; 加载于RW段的起始地址
					
				LDR R0, = |Load$$RW_IRAM1$$RW$$Base| 
				LDR R1, = |Image$$RW_IRAM1$$RW$$Base|
				LDR R2, = |Image$$RW_IRAM1$$RW$$Length|

				BL c_relocate_data
				
				;BX LR
			 
                ENDP	
; 清除bss段					 
clear_bss 		PROC	
				IMPORT |Image$$RW_IRAM1$$ZI$$Base|    ; ZI段的链接起始地址
                IMPORT |Image$$RW_IRAM1$$ZI$$Length|  ; ZI段的长度
				IMPORT c_clear_bss	
					
                LDR R0, = |Image$$RW_IRAM1$$ZI$$Base| 
				LDR R1, = |Image$$RW_IRAM1$$ZI$$Length| 
				MOV R2 , #0
				
				BL c_clear_bss
				
				;BX LR
				
				ENDP	
					 
				END     ;汇编文件结束
					
					