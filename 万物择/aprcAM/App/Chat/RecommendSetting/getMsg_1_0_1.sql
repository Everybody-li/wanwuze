-- ##Title app-我的-人资-招聘/应聘-招聘/应聘进展管理-应聘/受邀信息接收-系统推荐设置-获取操作弹窗提示语
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询
-- ##Describe 应聘,开启:popMsg:开启后，系统将向你推荐招聘方的招聘信息。请确认是否开启。btnMsg:提示：开启后，系统将把招聘同样事项但招聘需求未能满足的招聘信息向你做推荐
-- ##Describe 应聘,关闭:popMsg:关闭后，你将收不到系统推荐的招聘信息。请确认是否关闭。btnMsg:提示：开启后，系统将把招聘同样事项但招聘需求未能满足的招聘信息向你做推荐
-- ##Describe 招聘,开启:popMsg:开启后，系统将向你推荐应聘人员。请确认是否开启。btnMsg:提示：开启后，系统将把应聘同样工作事项但应聘需求未能满足的应聘人员向你做推荐。
-- ##Describe 招聘,关闭:popMsg:关闭后，你将收不到系统推荐的应聘人员。请确认是否关闭。btnMsg:提示：开启后，系统将把应聘同样工作事项但应聘需求未能满足的应聘人员向你做推荐。
-- ##CallType[QueryData]

-- ##input catTreeCode enum[demand,supply] NOTNULL;demand-应聘(需方),supply-招聘(供方)
-- ##input settingOnFlag enum[0,1] NOTNULL;开启或关闭
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output popMsg string[100] 开启后，系统将向你推荐招聘方的招聘信息。请确认是否开启。;弹窗提示语
-- ##output btnMsg string[100]  提示：开启后，系统将把招聘同样事项但招聘需求未能满足的招聘信息向你做推荐。;"系统推荐"按钮下方提示语

select
case when('{catTreeCode}'='demand' and '{settingOnFlag}'='0') then '关闭后，你将收不到系统推荐的招聘信息。请确认是否关闭。' when('{catTreeCode}'='demand' and '{settingOnFlag}'='1') then '开启后，系统将向你推荐招聘方的招聘信息。请确认是否开启。' when('{catTreeCode}'='supply' and '{settingOnFlag}'='0') then '关闭后，你将收不到系统推荐的应聘人员。请确认是否关闭。' when('{catTreeCode}'='supply' and '{settingOnFlag}'='1') then '开启后，系统将向你推荐应聘人员。请确认是否开启。' else '' end as popMsg
,case when('{catTreeCode}'='demand' and '{settingOnFlag}'='0') then '开启后，系统将把招聘同样事项但招聘需求未能满足的招聘信息向你做推荐' when('{catTreeCode}'='demand' and '{settingOnFlag}'='1') then '开启后，系统将把招聘同样事项但招聘需求未能满足的招聘信息向你做推荐' when('{catTreeCode}'='supply' and '{settingOnFlag}'='0') then '开启后，系统将把招聘同样事项但招聘需求未能满足的招聘信息向你做推荐' when('{catTreeCode}'='supply' and '{settingOnFlag}'='1') then '开启后，系统将把招聘同样事项但招聘需求未能满足的招聘信息向你做推荐' else '' end as btnMsg

