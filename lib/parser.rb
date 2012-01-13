class ResultSet
  def initialize(array, word, last_word)
    @sentences = array
    @last_word = last_word
    @word =      word
  end
  
  def count
    matches.count
  end
  
  def options
    @sentences.map{|s| s.scan(/#{regex('([^ ]*)')}/).to_a}.flatten.uniq.sort
  end
  
  def matches
    @sentences.map{|s| s if s.match(/#{regex}/)}.compact
  end
  
  private
  def regex(option=nil) 
    [option, @word, @last_word].compact.join(" ")
  end
end

class Result
  def initialize(array, word)
    @sentences, @last_word = array, word
  end
  
  def previous(word=nil)
    ResultSet.new @sentences, word, @last_word
  end
  
  def to_hash
    previous().options.map do |option|
      r = {
        :count => previous(option).count,
      }
      
      options = previous(option).options.map do |option2|
        res2 = previous(option2 + ' ' + option)
          {
            :name => "#{option2} #{option}",
            :count => res2.count,
            :mathes => res2.matches
          }
      end.sort_by{|o| o[:count]}.reverse
      r[:options] = options
      r
    end.select{|o| o[:count] > 1}.sort_by{|o| o[:count]}.reverse
  end
end

class Document
  def initialize(string)
    @sentences = string.gsub(/[\(\)\]\[]/, '').split(".").map &:strip
  end
  
  def find(word)
    Result.new(@sentences.select{|s| s.match(word)}, word)
  end
end