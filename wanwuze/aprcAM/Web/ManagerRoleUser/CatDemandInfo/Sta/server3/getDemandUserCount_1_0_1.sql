-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-列表上方-购方用户括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 统计t1的行数
-- ##Describe 表名:sys_app_user t1
-- ##CallType[QueryData]

-- ##input phonenumber String[100] NULL;姓名或电话号码(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] ;购方用户数量


select 
count(1) as totalNum 
from 
sys_app_user t1
where 
t1.del_flag='0' and (t1.nick_name like '%{phonenumber}%' or t1.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')