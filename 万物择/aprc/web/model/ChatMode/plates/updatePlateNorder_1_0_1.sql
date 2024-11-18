-- ##Title web-修改板块名称排序
-- 使用方:WebAPP
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-修改板块名称排序
-- ##CallType[ExSql]

-- ##input plateGuid char[36] NOTNULL;板块名称guid，必填
-- ##input norder int[>=0] NOTNULL;板块类型的顺序，必填
-- ##input newNorder int[>=0] NOTNULL;板块类型顺序，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @categoryGuid = null,@catTreeCode = null,@flag1 = null;
set @norderflag = ({newNorder} - {norder})
;

select category_guid, cat_tree_code, if(norder = {norder}, 1, 0)
into
    @categoryGuid,@catTreeCode,@flag1
from
    coz_model_chat_plate
where guid = '{plateGuid}';

update coz_model_chat_plate
set
    norder=norder - 1
  , publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
where
      norder <= {newNorder}
  and norder >= {norder}
  and category_guid = @categoryGuid
  and cat_tree_code = @catTreeCode
  and @norderflag >= 0
  and guid <> '{plateGuid}'
  and @flag1 = 1
  and del_flag = '0'
;
update coz_model_chat_plate
set
    norder=norder + 1
  , publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
where
      norder >= {newNorder}
  and norder <= {norder}
  and category_guid = @categoryGuid
  and cat_tree_code = @catTreeCode
  and @norderflag <= 0
  and guid <> '{plateGuid}'
  and @flag1 = 1
  and del_flag = '0'
;
update coz_model_chat_plate
set
    norder={newNorder}
  , publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
where guid = '{plateGuid}' and @flag1 = 1;


update coz_category_chat_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
    , publish_time= null
where  @flag1 = 1
and category_guid = @categoryGuid;

