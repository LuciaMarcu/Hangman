require 'yaml'

class Game  

    attr_accessor :secret_word, :guessed_letters, :wrong_letters, :wrong_guesses

    def initialize
        @secret_word = ""
        @guessed_letters = ""
        @wrong_guesses = 0
        @wrong_letters = []
    end

    def pick_word

        words_file = File.read("5desk.txt").split    
        words = []

        words_file.map do |word|
            words.push(word) if word.length.between?(5, 12)          
        end   
        
        words.delete_if{|word| word =~ /[A-Z]/}

        word = words[rand(words.size)]

    end
        
    def draw_first_line
        str = ""
        nr = @secret_word.length
        puts "The word has #{nr} letters."  
        @guessed_letters = str.ljust(nr, "*") 
    end    

    def count_fault(word, letter, wrong_let)    
        fault = 0
        if word.include?(letter)            
            fault
        else wrong_let.push(letter)
            puts "This letter is not in the secret word."        
            fault = 1        
        end
        
        return fault
    end

    def find_letter_index(letter)
        i = -1
        all_indexes = []
        while i = @secret_word.index(letter, i+1)
            all_indexes << i
        end
        all_indexes
    end

    def display_letters(letter, index)        
        index.each do |i|             
            @guessed_letters[i] = letter
        end        
        puts @guessed_letters
        @guessed_letters
    end

    def win?
        true if @guessed_letters == @secret_word
        if @guessed_letters == @secret_word
            puts "You won! The secret word is #{@secret_word}."
        end       
    end 
    
    

    def play
        if @secret_word.empty?
            @secret_word = pick_word
            @guessed_letters = draw_first_line
            puts "You have the right to six wrong guesses."
        end
        
        puts @guessed_letters        

        until wrong_guesses >= 6 || @guessed_letters == @secret_word do     
            
            if wrong_guesses == 0
                puts "Enter a letter or number 1 if you want to save the game."            
            else             
                puts "Wrong letters: #{wrong_letters}"
                puts "You have #{6- wrong_guesses} wrong guesses left. Enter a letter or 1 for saving the game."             
            end  

            letter = gets.chomp

            if letter == "1" 
                save_game 
                return
            end

            if @secret_word.include?(letter)
                index = find_letter_index(letter)
                display_letters(letter, index)
            end 

            fault = count_fault(@secret_word, letter, @wrong_letters)                          
            @wrong_guesses += fault        

            return if win?
        end

        if wrong_guesses == 6
            puts "You have exhausted all attempts. The secret word is #{secret_word}. Game over!"
        end
    end 
    
    def get_input
        puts "If you want to start playing press p. If you want to save the game press 1. For loading a saved game press 2."
        input = gets.chomp        
        if input == "1"
            save_game 
            return 
        elsif input == "2"   
            load_game 
            play      
        elsif input == "p" 
            play        
        end
        
    end

    def save_game
        File.open('saved_game.yml', 'w'){ |f| YAML.dump([] << self, f) }        
        puts "Game saved!"
    end

    def load_game
        yaml = YAML.load_file('./saved_game.yml')        
        @secret_word = yaml[0].secret_word
        @guessed_letters = yaml[0].guessed_letters
        @wrong_guesses = yaml[0].wrong_guesses
        @wrong_letters = yaml[0].wrong_letters
        puts "Game loaded!"
    end

    
end

game_one = Game.new
game_one.get_input