				PRESERVE8    ; instruct is aligned by 8 bytes 指令集8字节对齐
                THUMB        ; use Thumb instruction set    使用thumb指令集
					
				AREA    RESET, DATA, READONLY  ;DATA定义数据段，READONLY只读
				EXPORT  __Vectors

VECTOR_REG_ADD  EQU    0xE000ED08   

__Vectors       DCD     0                          ; CPU自动将该处的值设置给sp，Top of Stack
                DCD     Reset_Handler              ; Reset Handler 指令地址，CPU首先执行此句
				
				AREA    |.text|, CODE, READONLY    ; CODE表示定义代码段，READONLY只读
; Reset handler
Reset_Handler    PROC                 ; 子程序开始标志
				 EXPORT  Reset_Handler             [WEAK]   ; 
				 IMPORT  main               ; 
					
                 LDR     sp, = (0x20000000+0x10000)  ; 
			
                 BL     main                         ; 跳到C语言世界执行
         
                 ENDP				;
					 
boot_app    	PROC       ; 
				 EXPORT  boot_app    
				 
				 LDR R1, = VECTOR_REG_ADD
				 STR R0, [R1]  ; 向中断向量寄存器写入程序链接地址0x800B000
				 
				 LDR sp, [R0]  ; 取0x800B000地址处的值写入sp即设置栈
				 
				 ;LDR R3, [R1]
				 
				 LDR R2, [R0, #4]  ;  0x20000000 + 4 = 0x20000004,取出0x20000004地址处的值赋值给R2
				 		 
				 ;ADD R2, R0, #9
				 
                 BX     R2    ; 跳去执行APP
         
                 ENDP
				
				 END     ;汇编文件结
					 