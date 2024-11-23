-- ##Title web-修改板块字段名称排序
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-修改板块字段名称排序
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;板块字段名称guid，必填
-- ##input norder int[>=0] NOTNULL;板块类型的顺序，必填
-- ##input newNorder int[>=0] NOTNULL;板块类型顺序，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


set @categoryGuid = null,@bizType = null,@catTreeCode = null,@flag1 = null;
set @norderflag = ({newNorder} - {norder})
;

select category_guid, biz_type, cat_tree_code, if(norder = {norder}, 1, 0)
into
    @categoryGuid,@bizType,@catTreeCode,@flag1
from
    coz_model_plate_field
where guid = '{plateGuid}';

update coz_model_plate_field
set norder=norder-1
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where norder<={newNorder} and norder>={norder} and category_guid=@categoryGuid and biz_type=@bizType and cat_tree_code=@catTreeCode and @norderflag>=0 and guid<>'{plateFieldGuid}' and @flag1=1 and del_flag='0'
;

update coz_model_plate_field
set norder=norder+1
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where norder>={newNorder} and norder<={norder} and category_guid=@categoryGuid and biz_type=@bizType and cat_tree_code=@catTreeCode and @norderflag<=0 and guid<>'{plateFieldGuid}' and @flag1=1 and del_flag='0'
;

update coz_model_plate_field
set norder={newNorder}
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldGuid}' and @flag1=1 and del_flag='0';


update coz_category_deal_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where @bizType = 1 and @flag1=1  and  category_guid = @categoryGuid and publish_flag= '2';


update coz_category_supply_price
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
   , publish_time= null
where @bizType = 2 and @flag1=1  and category_guid = @categoryGuid and publish_flag= '2';