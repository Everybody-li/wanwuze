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
    t1.guid    as recruitGuid
  , t1.user_id as userId
from
    coz_chat_recruit            t1
where
      t1.category_guid = '{categoryGuid}'
  and t1.status = '1'
  and t1.sales_on = '1'
  and t1.del_flag = '0'
  and (
      {dynamic:value1[ exists(select 1
            from
                coz_chat_recruit_detail t2
            where t1.guid = t2.recruit_guid and t2.fd_code = 'c10001' and t2.fd_value = '{value1}' and t2.del_flag = '0') and ]/dynamic}
      {dynamic:value2[ exists(select 1
            from
                coz_chat_recruit_detail t2
            where t1.guid = t2.recruit_guid and t2.fd_code = 'c10002' and t2.fd_value = '{value2}' and t2.del_flag = '0') and ]/dynamic}
      {dynamic:value5[ exists(select 1
            from
                coz_chat_recruit_detail t2
            where t1.guid = t2.recruit_guid and t2.fd_code = 'c10005' and t2.fd_value = '{value5}' and t2.del_flag = '0') and ]/dynamic}
       1 = 1
      )