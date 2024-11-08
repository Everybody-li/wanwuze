-- ##Title web-获取行政区域层级列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-获取行政区域层级列表
-- ##CallType[QueryData]

-- ##input bizCode string[30] NOTNULL;父级code，必填
-- ##input parentCode string[11] NOTNULL;父节点code，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @maxlevel = (select case
                            when ('{bizCode}' = 'c00008') then 0
                            when ('{bizCode}' = 'c00009') then 1
                            when ('{bizCode}' = 'c00010') then 2
                            when ('{bizCode}' = 'c00011' or '{bizCode}' = 'c00022' or '{bizCode}' = 'c00023') then 3
                            when ('{bizCode}' = 'c00012') then 4
                            when ('{bizCode}' = 'c00021') then 5
                            else 0 end)
;


         select case
                    when end_nodes_count > 0 then '1'
                    else '0' end                                                                            as hasSon
              , code
              , level
              , parent_code                                                                                 as parentCode
              , path_name                                                                                   as pathName
              , all_parent_code                                                                              as allParentId
              , name
         from sys_city_code_hasglobal t
         where t.parent_code = '{parentCode}' and '{bizCode}'='c00022'
order by id;

