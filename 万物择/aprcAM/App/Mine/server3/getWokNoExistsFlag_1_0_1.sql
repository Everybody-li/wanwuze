-- ##Title app-我的-操作指导-查询工作人员的工作编号是否存在
-- ##Author 卢文彪
-- ##CreateTime 2023-09-07
-- ##Describe 判断是否存在ex_key=工作编号,ex_value=入参workNo的数据,不存在则返回提示:工作编号不正确，请核对后再输入提交
-- ##Describe 表名： sys_user_extra
-- ##CallType[QueryData]

-- ##input workNo char[6] NOTNULL;工作(对接)专员的工作编号
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output existsFlag enum[0,1] 1;工作编号是否存在:0-否,1-是
-- ##output msg string[300] 提示语;工作编号不正确，请核对后再输入提交


set @Flag1=(select case when exists(select 1 from sys_user_extra a inner join sys_user b on a.user_guid=b.user_id where a.ex_value='{workNo}' and a.ex_key='1' and b.del_flag='0' and b.status='0') then '1' else '0' end)
;
select 
case when (@Flag1='1') then '1' else '0' end as existsFlag
,case when (@Flag1='1') then '' else '工作编号不正确，请核对后再输入提交' end as msg
;