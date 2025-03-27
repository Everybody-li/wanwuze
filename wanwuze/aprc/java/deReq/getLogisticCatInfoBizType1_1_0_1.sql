-- ##Title 需求-查询物流服务品类采购需字段配置
-- ##Author lith
-- ##CreateTime 2024-12-16
-- ##Describe
-- ##CallType[QueryData]


-- ##output plateGuid char[36] ;板块guid
-- ##output plateNorder int[>0] ;板块顺序
-- ##output plateAlias string[20] ;板块别名
-- ##output plateFieldGuid char[36] ;板块字段guid
-- ##output plateFieldAlias string[20] ;板块字段别名
-- ##output operation enum[1,2,3,4,5] ;需方操作设置：0-未设置，1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传
-- ##output plateFieldFDCode string[6] ;板块字段code
-- ##output plateFieldNorder int[>0] ;板块字段顺序


select
    t1.guid            as plateGuid
  , t1.norder          as plateNorder
  , t1.fixed_data_code as plateCode
  , t1.alias           as plateAlias
  , t2.guid            as plateFieldGuid
  , t2.alias           as plateFieldAlias
  , t2.operation
  , t2.name            as plateFieldFDCode
  , t2.norder          as plateFieldNorder
from
    coz_model_plate_formal           t1
    inner join
        coz_model_plate_field_formal t2 on t1.guid = t2.plate_formal_guid
where
      t1.category_guid = '528a9e65-9d66-4e2d-a078-84a52096bb4b'
  and t2.cat_tree_code = 'demand'
  and t1.biz_type = '1'
  and t1.del_flag = '0'
;
