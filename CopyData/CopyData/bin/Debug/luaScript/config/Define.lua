local Define = {}

Define.FIND_STRING_HOST = "hbz.qrmkt.cn"
Define.DATA_TO_FIND_ARRAY = {"token","cookies","Content-Type"}

Define.REQ_HEAD_STRING = "reqHeader<" .. Define.FIND_STRING_HOST
Define.REQ_BODY_STRING = "reqBody<" .. Define.FIND_STRING_HOST
Define.RES_HEAD_STRING = "resHeader<" .. Define.FIND_STRING_HOST
Define.RES_BODY_STRING = "resBody<" .. Define.FIND_STRING_HOST

Define.FILE_SAVE_NAME = "token" --b保存在本地的文件名字: token.json

return Define