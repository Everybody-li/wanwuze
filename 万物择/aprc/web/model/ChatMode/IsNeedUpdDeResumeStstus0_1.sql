-- ##Author lith
-- ##CreateTime 2024-11-21
-- ##Describe
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid
-- ##input IsNeedUpdDeResumeStstus0 enum[0,1] NOTNULL;是否需要更新需方个人信息入库为失效


select affect_status as IsNeedUpdDeResumeStstus0
from
    coz_category_chat_mode
where
      category_guid = '{categoryGuid}'
  and del_flag = '0'
limit 1;