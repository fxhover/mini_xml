#encoding: utf-8
class MiniXml
  def initialize(out)
    @out = out
  end

  def self.generate(&block)
    out = []
    MiniXml.new(out).instance_eval(&block)
    out.join("")
  end

  def self.xml_from_data(data = {}, fields = [])
    out = []
    xml_attributes = {}
    xml_attributes[:version] = (data[:xml_version] || '1.0')
    xml_attributes[:encoding] = (data[:encoding] || 'UTF-8')
    rss_version = data[:rss_version] || '2.0'
    title_str = data[:title] || 'RSS'
    description_str = data[:description] || ''
    link_str = data[:link] || ''
    generate do
      xml(xml_attributes)
      rss(version: rss_version) do
        channel do
          title {title_str}
          description {description_str}
          link {link_str}
          data[:data].each do |da|
            item do
              if da.is_a?(Hash)
                da.each do |k, v|
                  next if fields.size > 0 && !fields.include?(k)
                  p = proc {v}
                  send(k, &p)
                end
              else
                raise 'fields argument can\'t empty!' if fields.empty?
                fields.each do |m|
                  p = proc {da.send(m)}
                  send(m.to_s, &p)
                end
              end
              nil
            end
          end
          nil
        end
      end
    end
  end

  def comment(content)
    @out << "<!-- #{content} -->"
    nil
  end

  def xml(tagname, attributes = {version: '1.0', encoding: 'UTF-8'})
    @out << "<?xml#{generate_attributes(attributes)}?>"
    nil
  end

  def generate_attributes(attributes_hash = {})
    attributes_str = ""
    attributes_hash.each {|key, val| attributes_str << " #{key}=\"#{val}\" "}
    attributes_str.rstrip
  end

  def method_missing(tagname, attributes = {})
    @out << "<#{tagname}"
    @out << generate_attributes(attributes)
    @out << ">"
    if block_given?
      content = yield
      @out << content.to_s if content
      @out << "</#{tagname}>"
    end
    nil
  end
end
