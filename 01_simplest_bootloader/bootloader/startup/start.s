				PRESERVE8    ; instruct is aligned by 8 bytes 指令集8字节对齐
                THUMB        ; use Thumb instruction set    使用thumb指令集
					
				AREA    RESET, DATA, READONLY  ;DATA定义数据段，READONLY只读
				EXPORT  __Vectors

__Vectors       DCD     0                          ; CPU自动将该处的值设置给sp，Top of Stack
                DCD     Reset_Handler              ; Reset Handler
				
				AREA    |.text|, CODE, READONLY    ; CODE表示定义代码段，READONLY只读
; Reset handler
Reset_Handler    PROC                 ; 子程序开始标志
				 EXPORT  Reset_Handler             [WEAK]   ; 导出Reset_Handler全局可见以及弱定义
				 IMPORT  main               ; 导入main，类似C语言的extern main，声明main由外部定义
		
                 LDR     sp, = (0x20000000+0x10000)  ; 手动设置栈,只有设置了栈才能跳到C语言的世界执行
                 BL     main                         ; 跳到C语言世界执行
         
                 ENDP				; 子程序结束标志
				
				 END     ;汇编文件结束