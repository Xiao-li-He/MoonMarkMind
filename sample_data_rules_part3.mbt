///|
fn rules_test_markdown_part3() -> String {
  (
    #|# 示例3 插入
    #|## 笔记
    #|也就是正文
    #|- 在列表中也可以插入笔记
    #|  与列表一起缩进
    #|
    #|## 链接
    #|在节点中插入[链接节点](https://example.com)
    #|- 在列表中插入链接
    #|  [链接节点](https://example.com)
    #|
    #|## 图片
    #|在节点中插入图片
    #|- 图片都是以url形式
    #|
    #|## 公式
    #|latex公式
    #|
  )
}
