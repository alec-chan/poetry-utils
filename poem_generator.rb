
require 'tactful_tokenizer'
require 'nokogiri'
require 'open-uri'
require 'openssl'
puts 'Enter a Word:'
word = gets.chomp
#word = 'blue'

puts 'Retrieving Rhymes'

doc = Nokogiri::HTML(open('http://wikirhymer.com/words/'+word))

rhymes = doc.css('span.dropdown').to_a
rhymes.collect!{|x| x.xpath('text()').text.strip}
puts rhymes.count

puts 'Retrieving Sentences'

rhyme_sentences = []
(0..10).each do |i|

	begin
		rhyme_word = rhymes.sample
		doc = Nokogiri::HTML(open('https://www.google.com/search?q='+URI::encode(rhyme_word), :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
		puts doc
		results = doc.css('h3.r a').collect{|a| a['href'].scan(/url\?q=(.*?)&/).first}

		doc  = Nokogiri::HTML(open(results.first.first))

		#this has massive encoding issues on windows; need to find an alternative 
		m = TactfulTokenizer::Model.new
		pot_sentences = m.tokenize_text(doc.text)
		pot_sentences.collect!{|s| s.match(/(\w+\s\w+\s\w+\s#{rhyme_word})/i)} 
		pot_sentences.reject!{|s| s==nil || s.length > 50 }
	
		rhyme_sentences = rhyme_sentences.concat pot_sentences.first 3
	
		puts '.'

	rescue => exception

		puts exception.backtrace
  		raise 
	  
		puts 'x'
	end
	
end

#puts rhyme_sentences

puts 'Rhyming ^_^/'

puts ''
puts word.capitalize
puts '--'

(0..5).each do |i|
	poem = []
	(0..4).each{|j| poem << rhyme_sentences.sample}
	
	puts poem
	puts '--'
end