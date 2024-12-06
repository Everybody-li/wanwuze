-- ##Title app-沟通模式-需方(应聘方)-查看人才信息入库-板块信息
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe
-- ##CallType[QueryData]

-- ##input demandResumeGuid string[500] NOTNULL;需方入库人才信息guid
-- ##input curUserId string[36] NOTNULL;登录用户id


-- ##output status enum[0,1] NOTNULL ;状态:0-失效,1-生效
-- ##output norder int[>0] NOTNULL ;字段顺序
-- ##output alias string[100] NOTNULL ;字段别名
-- ##output value char[36] NOTNULL ;板块guid
-- ##output demandResumePlateGuid char[36] NOTNULL ;字段guid
-- ##output fieldGuid char[36] NOTNULL ;字段guid

-- ##CustomFormatterColumns[{column:[value]/column}{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\app\demand\dReq\plates\codeToPathName_1_0_1&DBC=w_a&{Value}]/url}];


select
    {file[aprc/app/demand/dReq/plates/codeCondition_1_0_1.sql]/file} as value
  , t.guid                                                            as plateGuid
  , t.plate_field_formal_guid                                         as fieldGuid
  , t.plate_field_content_gc                                         as contentFDCode
from
    coz_chat_demand_resume_plate t
where
      t.demand_resume_guid = '{demandResumeGuid}'
  and t.del_flag = '0';