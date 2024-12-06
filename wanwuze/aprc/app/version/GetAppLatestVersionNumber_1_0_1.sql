-- ##Title 获取APP最新版本号
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe 获取APP最新版本号
-- ##CallType[QueryData]

-- ##input Sys enum[Android,IOS] NOTNULL;所属系统(枚举:Android，IOS)

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
select left(publish_time,10) as ReleaseDate,remark as `Explain`,version as OldVersion,weight as UpdateWeight
,case when(platform='1') then 'Android' else 'IOS' end as `Sys`
,case when(platform='1') then 'http://service.xiaofeizzj.com/Enclosure/DOWNLOAD/com.fzqbj.app.apk' else 'https://apps.apple.com/cn/app/全品荐/id1635922963' end  as DownloadAddress,version as NewVersion
,publish_time
,size
from
coz_app_version
where
status='1'
)t
where
`Sys`='{Sys}'
order by publish_time desc
limit 1
