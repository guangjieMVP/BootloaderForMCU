				PRESERVE8    ; instruct is aligned by 8 bytes 指令集8字节对齐
                THUMB        ; use Thumb instruction set    使用thumb指令集
					
				AREA    RESET, DATA, READONLY  ;DATA定义数据段，READONLY只读
				EXPORT  __Vectors

__Vectors       DCD     0                          ; CPU自动将该处的值设置给sp，Top of Stack
                DCD     Reset_Handler              ; Reset Handler 指令地址，CPU首先执行此句
				
				AREA    |.text|, CODE, READONLY    ; CODE表示定义代码段，READONLY只读
; Reset handler
Reset_Handler    PROC                 ; 子程序开始标志
				 EXPORT  Reset_Handler             [WEAK]   ; 导出Reset_Handler全局可见以及弱定义
				 IMPORT  main               ; 导入main，类似C语言的extern main，声明main由外部定义
					
                 LDR     sp, = (0x20000000+0x10000)  ; 手动设置栈,只有设置了栈才能跳到C语言的世界执行
			
                 BL     main                         ; 跳到C语言世界执行
         
                 ENDP				; 子程序结束标志
					 
boot_app    	PROC       ; 汇编标号即函数名或者说函数地址
				 EXPORT  boot_app    
					
				 ;STR R0, [R1]  ; 向中断向量寄存器写入程序链接地址0x800B000
				 
				 ;LDR sp, [R0]  ; 取0x800B000地址处的值写入sp即设置栈
				 
				 ;LDR R3, [R1]
				 
				 ;LDR R2, [R0, #4]  ;  0x800B000 + 4 = 0x800B004,取出0x800B004地址处的值赋值给R2
				 		 
				 ADD R2, R0, #9
				 
                 BX     R2    ; 跳去执行APP
         
                 ENDP
				
				 END     ;汇编文件结
					 