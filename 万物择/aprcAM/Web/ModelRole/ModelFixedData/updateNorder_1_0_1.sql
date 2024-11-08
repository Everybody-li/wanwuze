-- ##Title web后台-型号专员操作管理-固化内容信息管理-固化内容库管理-编辑库内容-变更内容节点顺序
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web后台-型号专员操作管理-固化内容信息管理-固化内容库管理-编辑库内容-变更内容节点顺序
-- ##CallType[ExSql]

-- ##input fixedDataValueGuid char[36] NOTNULL;字节内容guid，必填
-- ##input oldNorder int[>=0] NOTNULL;节点顺序，必填
-- ##input newNorder int[>=0] NOTNULL;节点顺序，必填
-- ##input curUserId string[36] NOTNULL;当前登录用户id

set @parentguid=(select parent_guid from coz_model_fixed_data_value where guid ='{fixedDataValueGuid}' and del_flag='0')
;
set @flag1=case when((select norder from coz_model_fixed_data_value where guid='{fixedDataValueGuid}')={oldNorder}) then 1 else 0 end
;
set @norderflag=({newNorder}-{oldNorder})
;
update coz_model_fixed_data_value
set norder=norder-1
where norder<={newNorder} and norder>={oldNorder} and parent_guid=@parentguid and @norderflag>=0 and guid<>'{fixedDataValueGuid}' and @flag1=1 and del_flag='0'
;
update coz_model_fixed_data_value
set norder=norder+1
where norder>={newNorder} and norder<={oldNorder} and parent_guid=@parentguid and @norderflag<=0 and guid<>'{fixedDataValueGuid}' and @flag1=1 and del_flag='0'
;
update coz_model_fixed_data_value
set norder={newNorder}
where guid='{fixedDataValueGuid}' and @flag1=1