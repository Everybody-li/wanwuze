-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe
-- ##Describe 表名:coz_category_supplier t1,coz_category_info t2
-- ##CallType[QueryData]

-- ##input phonenumber string[30] NULL;姓名或者电话号码，模糊查询
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output demandUserId char[36] ;购方(需方)用户id
-- ##output nickName string[30] 姓名;姓名
-- ##output nation string[30] 国家/区域;国家/区域
-- ##output phonenumber string[30] 手机号;手机号
-- ##output createTime string[16] 注册日期;注册日期


select 
t1.guid as demandUserId
,t1.user_name as nickName
,t1.nation
,t1.phonenumber
,left(t1.create_time,19) as createTime
from 
sys_app_user t1
where 
t1.del_flag='0' and (t1.nick_name like '%{phonenumber}%' or t1.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};