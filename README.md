MiniXml
======

一个简单的生成XML的gem，可以用于RSS订阅

安装
============

    gem install mini_xml

Rails中安装：

    gem "mini_xml"

    bundle install

使用方法：
========
    require 'mini_xml'

    xml = ""
    pagetitle = "Mini XML"
    xml = MiniXml.generate do
      xml(version: '1.0', encoding: 'GBK')
      html do
        head do
          title {pagetitle}
          comment "this is a test"
        end
        body do
          h1(style: "font-family:sans-serif") { pagetitle }
          ul type: "Square" do
            li {Time.now}
            li {RUBY_VERSION}
          end
        end
      end
    end
    puts xml

    输出如下：

    <?xml version="1.0"  encoding="UTF-8"?>
    <html>
        <head><title>Mini XML</title>
            <!-- this is a test -->
        </head>
        <body>
            <h1 style="font-family:sans-serif">Mini XML</h1>
            <ul type="Square"><li>2014-10-15 17:09:52 +0800</li><li>1.9.3</li></ul>
        </body>
    </html>

    传递一个子元素为hash的数组：

    data = {data: [
        {title: '11111111111111', username: 'user1', email: 'user1@qq.com', link: 'https://code.csdn.net/news/2822064'},
        {title: '22222222222222', username: 'user2', email: 'user2@qq.com', link: 'https://code.csdn.net/news/2822064'},
        {title: '33333333333333', username: 'user3', email: 'user3@qq.com', link: 'https://code.csdn.net/news/2822064'},
        {title: '44444444444444', username: 'user4', email: 'user4@qq.com', link: 'https://code.csdn.net/news/2822064'},
        {title: '55555555555555', username: 'user5', email: 'user5@qq.com', link: 'https://code.csdn.net/news/2822064'}
    ]}

    puts MiniXml.xml_from_data(data, [:title, :username, :link])

    输出如下：
    <?xml version="1.0"  encoding="UTF-8"?>
    <rss version="2.0">
        <channel>
            <title>RSS</title>
            <description></description>
            <link></link>
            <item><title>11111111111111</title><username>user1</username><link>https://code.csdn.net/news/2822064</link></item>
            <item><title>22222222222222</title><username>user2</username><link>https://code.csdn.net/news/2822064</link></item>
            <item><title>33333333333333</title><username>user3</username><link>https://code.csdn.net/news/2822064</link></item>
            <item><title>44444444444444</title><username>user4</username><link>https://code.csdn.net/news/2822064</link></item>
            <item><title>55555555555555</title><username>user5</username><link>https://code.csdn.net/news/2822064</link></item>
        </channel>
    </rss>

    传递一个有属性的对象：

    class User
      attr_reader :title, :username, :email, :link

      def initialize(attributes)
        attributes.each do |attr, value|
          eval("@#{attr}=value")
        end
      end
    end
    data1 = {
        title: 'RSS订阅',
        description: '欢迎订阅',
        link: 'http://www.baidu.com',
        data: [
            User.new({title: '11111111111111', username: 'user1', email: 'user1@qq.com', link: 'https://code.csdn.net/news/2822064'}),
            User.new({title: '22222222222222', username: 'user2', email: 'user2@qq.com', link: 'https://code.csdn.net/news/2822064'}),
            User.new({title: '33333333333333', username: 'user3', email: 'user3@qq.com', link: 'https://code.csdn.net/news/2822064'}),
            User.new({title: '44444444444444', username: 'user4', email: 'user4@qq.com', link: 'https://code.csdn.net/news/2822064'}),
            User.new({title: '55555555555555', username: 'user5', email: 'user5@qq.com', link: 'https://code.csdn.net/news/2822064'})
        ]
    }
    puts MiniXml.xml_from_data(data1, [:title, :username, :link])

    输出：
    <?xml version="1.0"  encoding="UTF-8"?>
    <rss version="2.0">
        <channel>
            <title>RSS订阅</title>
            <description>欢迎订阅</description>
            <link>http://www.baidu.com</link>
            <item><title>11111111111111</title><username>user1</username><link>https://code.csdn.net/news/2822064</link></item>
            <item><title>22222222222222</title><username>user2</username><link>https://code.csdn.net/news/2822064</link></item>
            <item><title>33333333333333</title><username>user3</username><link>https://code.csdn.net/news/2822064</link></item>
            <item><title>44444444444444</title><username>user4</username><link>https://code.csdn.net/news/2822064</link></item>
            <item><title>55555555555555</title><username>user5</username><link>https://code.csdn.net/news/2822064</link></item>
        </channel>
    </rss>

Acknowledgements
================
Copyright fxhover, released under the MIT License.

