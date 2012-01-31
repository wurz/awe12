#!/usr/bin/env ruby

require 'net/http'

if __FILE__ == $0
  begin
    loop do
      print "fetching random word from the internet: "
      STDOUT.flush
      word = Net::HTTP.get(URI("http://www.randomword.net/")).split(/<\/?h2>/i)[1].strip or die "failed"
      guessed_letters = " "
      bad_guesses = 0
      
      puts "<CHEAT>" + word + "</CHEAT> done."

      until word == word.gsub(/[^#{guessed_letters}]/ , '_')
        puts word.gsub(/[^#{guessed_letters}]/ , '_')
        c = STDIN.gets[0] or die ""
        
        if !guessed_letters.include? c
          guessed_letters += c
          bad_guesses += 1 if !word.include? c
        end
        
        puts "Guesses:" + guessed_letters + " (wrong guesses: " + bad_guesses.to_s + ")"
      end
    end
  end
end