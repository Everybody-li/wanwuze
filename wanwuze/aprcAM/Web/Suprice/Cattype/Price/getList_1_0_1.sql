-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-查询品类类型列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询 查询品类模式为审批模式的品类类型数据
-- ##Describe 出参”发布按钮高亮标志“逻辑：t1的需求信息发布标志是未发布，则高亮，否则置灰
-- ##Describe 表名：coz_cattype_fixed_data t1,coz_category_am_suprice t2,coz_cattype_fixed_data t3
-- ##CallType[QueryData]

-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output bizGuid char[36] 品类型号guid或品类类型guid/品类guid;
-- ##output bizName string[100] 品类型号名称/品类类型名称/品类名称;
-- ##output categoryGuid string[50] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output publishTime string[19] 最新发布时间;最新发布时间（格式：0000年00月00日 00:00）
-- ##output publishBtnHighLightFlag enum[0,1] 1;发布按钮高亮标志：0-置灰，1-高亮
-- ##output createTime string[19] 创建时间;创建时间（格式：0000-00-00 00:00:00）


select
t2.biz_guid as bizGuid
,(select name from coz_category_info where guid=t2.biz_guid) as bizName
,t1.guid as categoryGuid
,t1.name as categoryName
,t1.name as cattypeName
,case when(t2.publish_flag='0') then '1' else '0' end as publishBtnHighLightFlag
,left(t2.publish_time,19) as publishTime
,t2.create_time as createTime
from
coz_cattype_fixed_data t1
inner join
coz_category_am_suprice t2
on t2.category_guid=t1.guid
where
t1.del_flag='0' and t2.del_flag='0'
order by t1.norder

