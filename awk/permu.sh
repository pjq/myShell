#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月06日 星期日 15时06分19秒
# File Name: permu.sh
# Description: 
#########################################################################
#!/bin/bash
   #!/bin/sh
      awk '
         BEGIN {
	    print "请输入排列的元素,各元素间请用空白隔开"
	       getline
	          permutation($0, "")
		     printf("\n 共 %d 种排列方式\n", counter)
		        }
			   function permutation( main_lst, buffer,     new_main_lst, nf, i, j )
			      {
				                   $0 = main_lst # 把 main_lst 指定给$0 之后 awk 将自动进行字段分割.
						                nf = NF # 故可用 NF 表示 main_lst 上存在的元素个数.
								             # BASE CASE : 当 main_lst 只有一个元素时.
									                  if( nf == 1){
												                        print buffer main_lst #buffer 的内容再加上 main_lst 就是完成
															   一次排列的结果
															                         counter++
																		                       return
																				                    }
																						                 # General Case : 每次从 main_lst 中取出一个元素放到 buffer 中
																								              # 再用 main_lst 中剩下的元素 (new_main_lst) 往下进行排列
																									                   else for( i=1; i<=nf ;i++)
																												                {
																															                      $0 = main_lst # $0 为全局变量已被破坏, 故重新把 main_lst 赋
																																	         给$0,令 awk 再做一次字段分割
																																		                       new_main_lst = ""
																																				                             for(j=1; j<=nf; j++) # 连接 new_main_lst
																																								                           if( j != i ) new_main_lst = new_main_lst " " $j
																																												                         permutation( new_main_lst, buffer " " $i )
																																															              }
																																																         }
																																																	    ' $*

