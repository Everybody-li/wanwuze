-- ##Title 根据品类guid及应聘内容查询招聘信息详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据品类guid及应聘内容查询招聘信息详情
-- ##Describe 过滤条件：
-- ##Describe t1的生效状态为生效，t1的category_Guid=入参categoryGuid，
-- ##Describe t2的过滤条件为value1，value2，value5,t3的status=1，
-- ##Describe t3无数据不影响返回结果，t3有数据则t3的type <> 3 且 t3的type <> 5
-- ##Describe t4无数据不影响返回结果，t4有数据则t4的type <> 3 且 t3的type <> 5
-- ##Describe 按t1的Guid去重
-- ##CallType[QueryData]

-- ##input categoryGuid string[36] NOTNULL;品类guid
-- ##input22 value1 string[36] NULL;fd_code=c10001的值,单个,--注释,非必填,不写入入参校验
-- ##input22 value2 string[36] NULL;fd_code=c10002的值,单个,--注释,非必填,不写入入参校验
-- ##input22 value5 string[36] NULL;fd_code=c10005的值,单个,--注释,非必填,不写入入参校验
-- ##input curUserId string[36] NOTNULL;登录用户id

select
    recruitGuid
  , userId
from
    (
        select
            t1.guid    as recruitGuid
          , t1.user_id as userId
          , (
                select
                    rowcount
                from
                    (
                        select
                            t1.guid  as recruitGuid
                          , count(1) as rowcount
                        from
                            coz_chat_recruit            t1
                            left join
                                coz_chat_recruit_detail t2
                                    on t1.guid = t2.recruit_guid
                        where
-- not exists(select 1 from coz_app_user_permission where user_id=t1.user_id and type=3) and
-- not exists(select 1 from coz_app_user_permission_detail where user_id=t1.user_id and type=5 and biz_guid=t1.category_guid) and 
                            t1.category_guid = '{categoryGuid}'
                          and t1.status = '1'
                          and t1.del_flag = '0'
                          and t2.del_flag = '0'
                          and (
                              {dynamic:value1[ (t2.fd_code = 'c10001' and t2.fd_value = '{value1}') and ]/dynamic}
                              {dynamic:value2[ (t2.fd_code = 'c10002' and t2.fd_value = '{value2}') and ]/dynamic}
                              {dynamic:value5[ (t2.fd_code = 'c10005' and t2.fd_value = '{value5}') and ]/dynamic}
                                1=1
                              )
                        group by t1.guid
                    ) a
                where a.recruitGuid = t1.guid
            )          as rowcount
        from
            coz_chat_recruit            t1
            left join
                coz_chat_recruit_detail t2
                    on t1.guid = t2.recruit_guid
        where
-- not exists(select 1 from coz_app_user_permission where user_id=t1.user_id and type=3) and
-- not exists(select 1 from coz_app_user_permission_detail where user_id=t1.user_id and type=5 and biz_guid=t1.category_guid) and 
            t1.category_guid = '{categoryGuid}'
          and t1.status = '1'
          and t1.del_flag = '0'
          and t2.del_flag = '0'
          and (
              {dynamic:value1[ (t2.fd_code = 'c10001' and t2.fd_value = '{value1}') and ]/dynamic}
              {dynamic:value2[ (t2.fd_code = 'c10002' and t2.fd_value = '{value2}') and ]/dynamic}
              {dynamic:value5[ (t2.fd_code = 'c10005' and t2.fd_value = '{value5}') and ]/dynamic}
           1=1
            )
    ) t
-- app需要匹配的字段数量
where rowcount = 3
GROUP BY recruitGuid, userId