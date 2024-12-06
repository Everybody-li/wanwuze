-- ##Title web后台-型号专员操作管理-固化内容信息管理-固化内容库管理-创建库名称
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 创建库名称--都是针对字段内容,增删改查表t1
-- ##Describe code字段值格式:c+5位数字,数字从20000开始逐步递增,例如第一个:c20001,第二个c20002, type =3,biz_type=7,display_type=1
-- ##Describe 表名：coz_model_fixed_data t1 
-- ##CallType[ExSql]

-- ##input name string[20] NOTNULL;库名称
-- ##input curUserId string[36] NOTNULL;当前登录用户id

insert into coz_model_fixed_data
(
guid
,code
,name
,type
,biz_type
,display_type
,remark
,del_flag
,create_by
,create_time
,update_by
,update_time
)
select
UUID() as guid
,concat('c2',right(concat('00000000','{url:[http://127.0.0.1:8011/Cache?Name=code&Key=c]/url}'),4)) as code
,'{name}' as name
,'3' as type
,'7' as biz_type
,'1' as display_type
,'' as remark
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
;

