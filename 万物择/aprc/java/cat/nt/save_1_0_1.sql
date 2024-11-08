-- ##Title 品类-保存字节内容信息_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 品类-保存字节内容信息_1_0_1
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;末级场景guid，必填
-- ##input secenGuid char[36] NOTNULL;末级场景guid，必填

-- ##input parentGuid string[36] NULL;上一段字节内容guid（前端判断，没有上一段字节内容,传末级场景guid），必填

-- ##input name string[100] NOTNULL;本段字节标题的字节内容
-- ##input allParentId string[2000] NULL;字节内容名称，必填
-- ##input level int[>=0] NOTNULL;字节内容名称，必填
-- ##input norder int[>=0] NOTNULL;字节内容顺序，必填

INSERT INTO coz_category_name_tree(guid,scene_tree_guid,parent_guid,all_parent_id,code,name,level,norder,remark,del_flag,create_by,create_time,update_by,update_time)
select 
'{guid}'
,'{secenGuid}'
,'{parentGuid}'
,'{allParentId}'
,'1'
,'{name}'
,{level}
,{norder}
,''
,'0'
,'-1'
,now()
,'-1'
,now() 
from
coz_cattype_fixed_data
where 
not exists(select 1 from coz_category_name_tree where name='{name}' and parent_guid='{parentGuid}' and del_flag='0')
limit 1