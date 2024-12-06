-- ##Title web后台-审批模式-通用配置-供需需求信息管理-发布(品类类型调用)
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 发布品类的供需需求信息数据
-- ##Describe
-- ##Describe 1、调用接口：aprcAM\PluginServe\ApromMode\Cattype\Mode\isCanPublish_1_0_1 判断是否可以发布，如果不可以，则将接口提示语返回给前端，停止逻辑处理;若返回可以，则继续
-- ##Describe 2、调用接口：aprcAM\PluginServe\ApromMode\Cattype\Mode\publish_1_0_1 进行发布。若接口返回失败，则将发布接口的提示语返回给前端，停止逻辑处理;若返回成功，则返回成功的提示语
-- ##CallType[Plugin_Text]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果：0-发布失败，1-发布成功
-- ##output msg string[100] 操作提示语;操作提示语
