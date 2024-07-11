# Define Braille mapping
BRAILLE = {
  'a' => 'O.....', 'b' => 'O.O...', 'c' => 'OO....', 'd' => 'OO.O..', 'e' => 'O..O..', 
  'f' => 'OOO...', 'g' => 'OOOO..', 'h' => 'O.OO..', 'i' => '.OO...', 'j' => '.OOO..', 
  'k' => 'O...O.', 'l' => 'O.O.O.', 'm' => 'OO..O.', 'n' => 'OO.OO.', 'o' => 'O..OO.', 
  'p' => 'OOO.O.', 'q' => 'OOOOO.', 'r' => 'O.OOO.', 's' => '.OO.O.', 't' => '.OOOO.', 
  'u' => 'O...OO', 'v' => 'O.O.OO', 'w' => '.OOO.O', 'x' => 'OO..OO', 'y' => 'OO.OOO', 
  'z' => 'O..OOO', ' ' => '......', '#' => '.O.OOO', 'upcase' => '.....O'
}

# Reverse the Braille map for English to Braille translation
ENGLISH = BRAILLE.invert

# Function to translate a Braille number to English
def get_english_number(char)
  ENGLISH.keys.index(char)
end

# Function to translate an English number to Braille
def get_braille_number(char)
  BRAILLE.values[char.to_i]
end

# Function to determine if input is Braille
def is_braille?(input)
  input.delete('.O ').empty?
end

# Function to translate English to Braille
def english_to_braille(input)
  in_number_mode = false
  input.chars.map do |char|
    if char == ' '
      in_number_mode = false
      BRAILLE[char]
    elsif char =~ /\d/
      if !in_number_mode
        in_number_mode = true
        BRAILLE['#'] + get_braille_number(char)
      else
        get_braille_number(char)
      end
    else
      in_number_mode = false
      is_capital = char.upcase == char && char.downcase != char
      char = BRAILLE[char.downcase] || ''
      is_capital ? BRAILLE['upcase'] + char : char
    end
  end.join
end

# Function to translate Braille to English
def braille_to_english(input)
  result = ''
  in_number_mode = false
  i = 0
  while i < input.length
    char = input[i, 6]
    if char == BRAILLE['upcase']
      i += 6
      next_char = input[i, 6]
      result += (ENGLISH[next_char] || '').upcase
    elsif char == BRAILLE['#']
      in_number_mode = true
    elsif char == BRAILLE[' ']
      in_number_mode = false
      result += ' '
    else
      result += in_number_mode ? get_english_number(char).to_s : ENGLISH[char]
    end
    i += 6
  end
  result
end

# Main function to handle the translation
def main
  input = ARGV.join(" ")

  puts is_braille?(input) ? 
    braille_to_english(input) 
    : english_to_braille(input)
end

main