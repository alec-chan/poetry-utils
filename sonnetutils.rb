require 'ruby_rhymes'
require 'string_to_arpa'
class Poetry_Utils
	def does_rhyme(line1, line2)
		#get the phrases' rhyme keys
		keys1 = line1.to_phrase.rhyme_keys
		keys2 = line2.to_phrase.rhyme_keys

		#check intersections between rhyme key arrays of the two end words
		if (keys1 & keys2).empty?
			return false
		else
			return true
		end
	end



	def check_syllables(line)
		return line.to_phrase.syllables
	end

	def check_iambic_feet(line)

		words = line.split(/\W+/)

		stress=0
		soft=0
		for word in words

			if word.to_arpa.tr("^0-9", '').include? '1' #or word.to_arpa.tr("^0-9", '').include? '2'
				stress+=1
				puts word.to_arpa
			end

		end

		if stress==5
			return true
		else
			puts stress
			for word in words

				if word.to_arpa.tr("^0-9", '').include? '1' #or word.to_arpa.tr("^0-9", '').include? '2'
					puts word.to_arpa
				end

			end
		end
	end

	

end

if __FILE__ == $0

	u = Poetry_Utils.new

	puts u.does_rhyme("When I do count the clock that tells the time", "which alters when it alteration finds")
	
	puts u.check_iambic_feet("Within his bending sickle's compass come")

	

end
