-- ##Title web-服务专员-添加标签
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-服务专员-添加标签
-- ##CallType[ExSql]

-- ##input name string[30] NOTNULL;档案模板guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


set @flag1=(select case when exists(select 1 from coz_serve2_bizdict where type='5' and name='{name}' and del_flag='0') then '0' else '1' end)
;
insert into coz_serve2_bizdict(guid, type, name,create_time,create_by,update_time,update_by)
select uuid(),5,'{name}',current_timestamp,'{curUserId}',current_timestamp,'{curUserId}' where @flag1='1';