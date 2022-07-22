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
                 IMPORT relocate_app
				 IMPORT  |Load$$ER_IROM1$$Base| ; 加载域的代码起始地址
				 IMPORT  |Image$$ER_IROM1$$Base|
				 IMPORT	 |Image$$ER_IROM1$$Length|
					 
				 LDR     sp, = (0x20000000+0x10000)  ; 设置栈
				 	 
				 LDR R0, = |Load$$ER_IROM1$$Base| 
				 LDR R1, = |Image$$ER_IROM1$$Base|
				 LDR R2, = |Image$$ER_IROM1$$Length|
				 
				 BL relocate_app
				  
				 LDR pc, = xmain    ; 代码已经重定位,绝对跳转到RAM中的xmain，用BL xmain也可以
                              
                 ENDP				; 子程序结束标志					 
					
				 END     ;汇编文件结束
					
					