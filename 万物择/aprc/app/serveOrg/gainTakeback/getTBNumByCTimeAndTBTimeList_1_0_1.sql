-- ##Title ﻿﻿﻿app-根据领取日期和收回日期查询收回详情列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe ﻿app-根据领取日期和收回日期查询收回详情列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input createTime char[10] NOTNULL;领取日期(格式：0000-00-00)，必填
-- ##input takebackTime char[10] NOTNULL;领取日期(格式：0000-00-00)，必填
-- ##input phonenumber string[11] NULL;用户姓名或联系电话(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t1.guid as userGainLogGuid
,t3.name as cattypeName
,concat(''(+86)'',t2.object_phonenumber) as phonenumber
,t2.object_name as userName
from
coz_serve_user_gain_log t1
inner join
coz_serve_org_gain_log t2
on t2.guid=t1.seorg_glog_guid
inner join
coz_cattype_fixed_data t3
on t2.cattype_guid=t3.guid
where
t1.user_id=''{curUserId}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and left(t1.create_time,10)=''{createTime}'' and t1.takeback_flag=''1'' and left(t1.takeback_time,10)=''{takebackTime}''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;