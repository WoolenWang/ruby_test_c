/**
# Author: Woolen.Wang
# Email: just_woolen＠qq.com
# File Name: foo.c
=========================================================================
Description: 
这个是测试注释生成单元测试的
Edit History: 
2014-01-07    File created.
=========================================================================
**/
#include "foo.h"
#include "stdio.h"
/**
* 这个函数就是测测两个谁大
* param a 数1
* param b 数2
*/
/**
*unit_test
*input 1,2 should return 2
*input 1,3 should return 3
*input 2,4 should return 4
*/
int max(int a, int b)
{
    return a>b?a:b;
}
