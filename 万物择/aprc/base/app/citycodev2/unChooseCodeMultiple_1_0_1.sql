-- ##Title app-多选-去勾
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-多选-去勾
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizGuid char[36] NOTNULL;业务guid(取招聘信息guid)，必填
-- ##input bizCode string[30] NOTNULL;业务guid(取招聘信息guid)，必填
-- ##input nodeCode string[30] NOTNULL;节点code，必填
-- ##input nodeHasSon string[1] NOTNULL;节点是否有儿子(0-否，1-是)，必填
-- ##input nodeParentCode string[30] NOTNULL;父节点code，必填
-- ##input nodeAllParentCode string[200] NOTNULL;组系父节点code，必填

delete from coz_biz_city_code_temp where biz_guid='{bizGuid}' and ncode='{nodeCode}'
;

