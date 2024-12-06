-- ##Title web-查询固化内容库信息管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询固化内容库信息管理
-- ##CallType[QueryData]

-- ##input type int[>=0] NOTNULL;类型：1-板块名称，2-字段名称，3-字段内容,必填
-- ##input name string[50] NULL;名称，非必填
-- ##input bizType string[100] NULL;业务类型：1：需求信息，2：报价信息，4：资质信息，非必填


-- ##output fixedDataGuid char[36] 固化库板块名称guid;固化库板块名称guid
-- ##output Name string[50] 名称;名称
-- ##output type int[>=0] 1;数据类型：1：板块名称，2：字段名称，3：字段内容库
-- ##output bizType int[>=0] 1;业务类型：1：需求信息，2：报价信息，4：资质信息


select
guid as fixedDataGuid
,name
,type
,biz_type as bizType
from
coz_model_fixed_data t
where type={type} and (name like '%{name}%' or '{name}'='') and biz_type in ({bizType}) and 
(display_type='1' or display_type='2')
order by t.create_time
;
