-- ##Title web-获取行政区域层级列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-获取行政区域层级列表
-- ##CallType[QueryData]

-- ##input code string[30] NOTNULL;父级code，必填
-- ##input bizCode string[30] NOTNULL;父级code，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizGuid char[36] NOTNULL;业务guid，必填

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
           when ((baseChildrenCount = bizChildrenCount and bizChildrenCount > 0))
               then '2'
           when ((baseChildrenCount > bizChildrenCount and bizChildrenCount > 0))
               then '1'
           when (bizChildrenCount = 0)
               then
               '0'
           else
               '0'
    end as selectedFlag
     , t.*
from (
         select case
                    when (id = 1) then '1'
                    when (@maxlevel > level and all_parent_code like '%,CN,%') then '1'
                    else '0' end                                                                            as hasSon
              , IF((end_nodes_count = 0), 1, end_nodes_count)                                               as baseChildrenCount
              , ifnull((select sum(case when (end_nodes_count = 0) then 1 else end_nodes_count end)
                        from sys_city_code_hasglobal
                        where id in (select id
                                     from coz_biz_city_code_hasglobal_temp
                                     where biz_guid = '{bizGuid}' and del_flag='0' 
                                       and (id = t.id or all_parent_code like concat('%,', t.id, ',%')))),
                       0)                                                                                   as bizChildrenCount
              , code
              , id
              , parent_code                                                                                 as parentCode
              , all_parent_code                                                                               as allParentCode
              , name
         from sys_city_code_hasglobal t
         where t.parent_code = '{code}' and '{bizCode}' = 'c00022'
     ) t
order by id;

