-- ##Title 获取APP最新版本号
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe 获取APP最新版本号
-- ##CallType[QueryData]

-- ##input Sys enum[Android,IOS] NOTNULL;所属系统(枚举:Android，IOS)
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
ReleaseDate
,`Explain`
,OldVersion
,UpdateWeight
,DownloadAddress
,NewVersion
,size
from
(
select left(create_time,10) as ReleaseDate,remark as `Explain`,version as OldVersion,weight as UpdateWeight,case when(platform='1') then 'Android' else 'IOS' end as `Sys`,'http://service.xiaofeizzj.com/Enclosure/DOWNLOAD/com.fzqbj.app.apk' as DownloadAddress,version as NewVersion
,size
from
coz_app_version
where
status='1'
order by publish_time desc
)t
where
`Sys`='{Sys}'