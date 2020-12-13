local table_test = {
	AA = "",
	BB = "12323",
	CC = false,
	DD = 999,
}

local question = [[
{"code":"200","msg":null,"data":{"timeLimit":50,"answerList":[{"question":{"id":3233,"ctime":"2019-10-10 15:03:20","utime":"2019-10-10 15:03:20","actCode":"ACT-8K38GWT8552W","quesId":"DT_74d63566-d","quesTitle":"被称为成语典故之都的城市是河北省的哪个城市","quesType":1,"status":1},"answer":[{"id":9728,"ctime":"2019-10-10 15:03:20","quesId":"DT_74d63566-d","answName":"邯郸","answFlag":-1,"idx":1,"utime":"2019-10-10 15:03:20"},{"id":9729,"ctime":"2019-10-10 15:03:20","quesId":"DT_74d63566-d","answName":"北京","answFlag":-1,"idx":2,"utime":"2019-10-10 15:03:20"},{"id":9730,"ctime":"2019-10-10 15:03:20","quesId":"DT_74d63566-d","answName":"西安","answFlag":-1,"idx":3,"utime":"2019-10-10 15:03:20"},{"id":9731,"ctime":"2019-10-10 15:03:20","quesId":"DT_74d63566-d","answName":"洛阳","answFlag":-1,"idx":4,"utime":"2019-10-10 15:03:20"}]},{"question":{"id":3339,"ctime":"2020-02-18 16:59:32","utime":"2020-02-18 16:59:32","actCode":"ACT-8K38GWT8552W","quesId":"DT_5c0a02e7-3","quesTitle":"以下那个不是新冠肺炎的症状。","quesType":1,"status":1},"answer":[{"id":10032,"ctime":"2020-02-18 16:59:32","quesId":"DT_5c0a02e7-3","answName":"干咳","answFlag":-1,"idx":1,"utime":"2020-02-18 16:59:32"},{"id":10033,"ctime":"2020-02-18 16:59:32","quesId":"DT_5c0a02e7-3","answName":"耳鸣","answFlag":-1,"idx":2,"utime":"2020-02-18 16:59:32"},{"id":10034,"ctime":"2020-02-18 16:59:32","quesId":"DT_5c0a02e7-3","answName":"发热","answFlag":-1,"idx":3,"utime":"2020-02-18 16:59:32"},{"id":10035,"ctime":"2020-02-18 16:59:32","quesId":"DT_5c0a02e7-3","answName":"乏力","answFlag":-1,"idx":4,"utime":"2020-02-18 16:59:32"}]},{"question":{"id":3235,"ctime":"2019-10-14 10:41:53","utime":"2019-10-14 10:41:53","actCode":"ACT-8K38GWT8552W","quesId":"DT_e6d9110a-c","quesTitle":"新中国建国后下列哪个城市曾经是河北省的省会","quesType":1,"status":1},"answer":[{"id":9736,"ctime":"2019-10-14 10:41:53","quesId":"DT_e6d9110a-c","answName":"天津","answFlag":-1,"idx":1,"utime":"2019-10-14 10:41:53"},{"id":9737,"ctime":"2019-10-14 10:41:53","quesId":"DT_e6d9110a-c","answName":"廊坊","answFlag":-1,"idx":2,"utime":"2019-10-14 10:41:53"},{"id":9738,"ctime":"2019-10-14 10:41:53","quesId":"DT_e6d9110a-c","answName":"邢台","answFlag":-1,"idx":3,"utime":"2019-10-14 10:41:53"},{"id":9739,"ctime":"2019-10-14 10:41:53","quesId":"DT_e6d9110a-c","answName":"邯郸","answFlag":-1,"idx":4,"utime":"2019-10-14 10:41:53"}]},{"question":{"id":3211,"ctime":"2019-10-11 17:24:40","utime":"2019-10-11 17:24:40","actCode":"ACT-8K38GWT8552W","quesId":"DT_0ece*Fc-b","quesTitle":"品牌创立于哪一年","quesType":1,"status":1},"answer":[{"id":9648,"ctime":"2019-10-11 17:24:40","quesId":"DT_0ece*Fc-b","answName":"1999","answFlag":-1,"idx":1,"utime":"2019-10-11 17:24:40"},{"id":9649,"ctime":"2019-10-11 17:24:40","quesId":"DT_0ece*Fc-b","answName":"1959","answFlag":-1,"idx":2,"utime":"2019-10-11 17:24:40"},{"id":9650,"ctime":"2019-10-11 17:24:40","quesId":"DT_0ece*Fc-b","answName":"1979","answFlag":-1,"idx":3,"utime":"2019-10-11 17:24:40"},{"id":9651,"ctime":"2019-10-11 17:24:40","quesId":"DT_0ece*Fc-b","answName":"2001","answFlag":-1,"idx":4,"utime":"2019-10-11 17:24:40"}]},{"question":{"id":3351,"ctime":"2020-02-18 17:05:50","utime":"2020-02-18 17:05:50","actCode":"ACT-8K38GWT8552W","quesId":"DT_17b68fde-7","quesTitle":"佩戴口罩以下说法正确的是？","quesType":1,"status":1},"answer":[{"id":10071,"ctime":"2020-02-18 17:05:50","quesId":"DT_17b68fde-7","answName":"可以多次重复使用","answFlag":-1,"idx":1,"utime":"2020-02-18 17:05:50"},{"id":10072,"ctime":"2020-02-18 17:05:50","quesId":"DT_17b68fde-7","answName":"佩戴前洗手","answFlag":-1,"idx":2,"utime":"2020-02-18 17:05:50"},{"id":10073,"ctime":"2020-02-18 17:05:50","quesId":"DT_17b68fde-7","answName":"可以不分正反面","answFlag":-1,"idx":3,"utime":"2020-02-18 17:05:50"}]}]}}
]]

-- LogOut(question);

local jsonjjj = json.decode(question)
dump(jsonjjj,"hcc>>question",10)