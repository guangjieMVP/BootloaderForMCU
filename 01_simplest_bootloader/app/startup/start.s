				PRESERVE8    ; instruct is aligned by 8 bytes 指令集8字节对齐
                THUMB        ; use Thumb instruction set    使用thumb指令集
					
				AREA    RESET, DATA, READONLY  ;DATA定义数据段，READONLY只读
				;EXPORT  __Vectors  

__Vectors       DCD     0x20000000+0x10000   ; CPU自动取改处的值设置为栈顶 Top of Stack
                DCD     Reset_Handler           ; Reset Handler
				
				AREA    |.text|, CODE, READONLY    ; CODE表示定义代码段，READONLY只读
; Reset handler
Reset_Handler    PROC                 ; 子程序开始标志
				 EXPORT  Reset_Handler             [WEAK]   ; 导出Reset_Handler全局可见以及弱定义
				 IMPORT  xmain         ; 导入main，类似C语言的extern main，声明main由外部定义
		
                 LDR     sp, = (0x20000000+0x10000)  ; 设置栈,只有设置了栈才能跳到C语言的世界执行
				 
				 ;BL 	relocate
				 ;BL     clear_bss
                 BL     xmain                         ; 跳到C语言世界执行
         
                 ENDP				; 子程序结束标志
					 
relocate    	PROC       ; 汇编标号即函数名或者说函数地址
				EXPORT  relocate 
				IMPORT |Load$$RW_IRAM1$$Base|     ; 数据段的加载起始地址(源)
                IMPORT |Image$$RW_IRAM1$$Base|    ; 数据段的链接起始地址(目的)
                IMPORT |Image$$RW_IRAM1$$Length|  ; 数据段的长度(长度)					
				IMPORT relocate_data
				
				 LDR R0, = |Load$$RW_IRAM1$$Base| 
				 LDR R1, = |Image$$RW_IRAM1$$Base|
				 LDR R2, = |Image$$RW_IRAM1$$Length| 
	
				 BL relocate_data        ; 重定位数据段
				 
                 ENDP	
					 
clear_bss 		PROC	
				IMPORT |Image$$RW_IRAM1$$ZI$$Base|    ; ZI段的链接起始地址
                IMPORT |Image$$RW_IRAM1$$ZI$$Length|  ; ZI段的长度
				IMPORT c_clear_bss	
					
                LDR R0, =|Image$$RW_IRAM1$$ZI$$Base| 
				LDR R1, = |Image$$RW_IRAM1$$ZI$$Length| 
				MOV R2 , #0
				
				BL c_clear_bss
				
				ENDP	
					 
				END     ;汇编文件结束