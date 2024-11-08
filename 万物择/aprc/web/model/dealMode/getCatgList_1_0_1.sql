-- ##Title web-型号专员管理-查询供需需求信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input categoryName string[500] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output dealModeGuid string[50] 配置记录guid;配置记录guid
-- ##output categoryGuid string[50] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output publishTime string[19] 最新发布时间;最新发布时间（格式：0000年00月00日 00:00）
-- ##output publishFlag int[>=0] 0;发布标志（0-未发布，其他数值：已发布）
-- ##output createTime string[19] 创建时间;创建时间（格式：0000-00-00 00:00:00）

select
    tt.categoryGuid
  , tt.categoryName
  , tt.cattypeName
  , tt.publishFlag
  , if(tt.publishFlag = '0','',tt.publishTime) as publishTime
from
        (
select
    t.*
  , case
        when exists(select 1
                    from coz_model_plate
                    where t.categoryGuid = category_guid and biz_type = '1' and publish_flag = '0' and del_flag = '0')
            or exists(select 1
                      from
                          coz_model_plate_field
                      where t.categoryGuid = category_guid and biz_type = '1' and publish_flag = '0' and del_flag = '0')
            or exists(select 1
                      from
                          coz_model_plate_field_content
                      where t.categoryGuid = category_guid and biz_type = '1' and publish_flag = '0' and del_flag = '0')
            then '0'
        else '2' end as publishFlag
from
    (
        select
            t1.guid                   as categoryGuid
          , t1.name                   as categoryName
          , t1.cattype_name           as cattypeName
          , left(t2.publish_time, 19) as publishTime
          , t1.id
        from
            coz_category_info          t1
            inner join
                coz_category_deal_mode t2
                    on t2.category_guid = t1.guid
        where t1.del_flag = '0' {dynamic:categoryName[and t1.name like '%{categoryName}%']/dynamic}
        order by
            t1.id
                desc
Limit {compute:[({page}-1)*{size}]/compute},{size}
    ) t) tt
   order by
            tt.id
                desc


