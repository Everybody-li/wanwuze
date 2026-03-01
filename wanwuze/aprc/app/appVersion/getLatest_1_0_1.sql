-- ##Title 获取APP最新版本号
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe 获取APP最新版本号
-- ##CallType[QueryData]

select
ReleaseDate
,`Explain`
,OldVersion
,UpdateWeight
,DownloadAddress
,NewVersion  as version
,apkSize
from
(
select left(publish_time,10) as ReleaseDate,size as apkSize,remark as `Explain`,version as OldVersion,weight as UpdateWeight,case when(platform='1') then 'Android' else 'IOS' end as `Sys`,'http://service.xiaofeizzj.com/Enclosure/DOWNLOAD/com.xiaofeizzj.app.apk' as DownloadAddress,version as NewVersion
from
coz_app_version
where
1=2
--     1=2 and -- 临时更改,不查新版本,去掉app显示提示更新版本
-- status='1'
-- order by publish_time desc
-- limit 1
)t
where
`Sys`='Android'
