require 'pry'

RANKS = ['A', '2', '3', '4', '5', '6',
         '7', '8', '9', '10', 'J', 'Q', 'K'].freeze
SUITS = ['s', 'c', 'h', 'd'].freeze
deck = []

def prompt(msg)
  puts "=> #{msg}"
end

def separate
  prompt "-------------------------"
end

def build_deck(ranks, suits, deck)
  ranks.map do |rank|
    suits.each do |suit|
      deck.push({ "rank" => rank, "suit" => suit })
    end
  end
end

def shuffle_deck(deck)
  deck.shuffle!
end

def deal_cards(deck)
  dealt_cards = []
  2.times { dealt_cards.push(deck.pop) }
  dealt_cards
end

def total_card_value(hand_array)
  hand_total = 0
  hand_array.each do |card|
    case card[:rank]
    when 'K', 'Q', 'J'
      hand_total += 10
    when 'A'
      hand_total += 11
    else
      hand_total += card[:rank].to_i
    end
  end
  hand_total = check_for_ace(hand_array, hand_total)
  hand_total
end

def deal_extra_cards(hand, deck)
  hand.push(deck.pop)
end

def display_player_hand(hand)
  card_counter = 1
  prompt("Your hand is:")
  hand.each do |card|
    prompt("Card #{card_counter}: #{card[:rank]}#{card[:suit]}")
    card_counter += 1
  end
end

def display_full_dealer_hand(hand)
  card_counter = 1
  prompt("The dealer's hand is:")
  hand.each do |card|
    prompt("Card #{card_counter}: #{card[:rank]}#{card[:suit]}")
    card_counter += 1
  end
end

def display_dealer_hand(hand)
  prompt "The dealer's hand is showing: #{hand[0][:rank]}#{hand[0][:suit]}"
end

def eval_hand(hand, total)
  if hand.length == 2 && total == 21
    prompt("Congratulations, you won with 21!")
  elsif total > 21
    separate
    prompt("Your hand is over 21. You busted! The dealer wins.")
    separate
  else
    prompt(" ")
    prompt("Your current hand total is: #{total}")
  end
  total
end

def eval_dealer_hand(hand, total, deck)
  separate
  if hand.length == 2 && total == 21
    prompt("*** The dealer won with 21! ***")
  elsif total > 21
    prompt("*** The dealer busted! You win! ***")
  elsif total < 17
    prompt "The dealer hits..."
    deal_extra_cards(hand, deck)
  elsif total >= 17 && total <= 21
    prompt "The dealer stands with a total of: #{total}"
  end
  separate
  total
end

def check_for_ace(hand, total)
  hand.each do |card|
    total -= 10 if card[:rank] == 'A' && total > 21
  end
  total
end

def decide_winner(player_total, dealer_total)
  separate
  if player_total > dealer_total
    prompt "*** Congratulations, you win! ***"
  elsif dealer_total == player_total
    prompt "*** It's a tie! ***"
  else
    prompt "*** The dealer wins. ***"
  end
  separate
end

def hit_or_stand?(choice, cards, deck)
  if choice == 's'
    prompt "You decided to stand."
    prompt "Your total is: #{player_total}."
  else
    cards = deal_extra_cards(cards, deck)
  end
  cards
end

system "clear"
prompt "************** Greetings! Welcome to 21! **************"
prompt " "

loop do
  build_deck(RANKS, SUITS, deck)
  prompt "The dealer is shuffling the deck..."
  deck = shuffle_deck(deck)

  play_again = ''
  loop do
    break if deck.empty?
    system "clear"
    player_cards = deal_cards(deck)
    dealer_cards = deal_cards(deck)
    separate
    display_player_hand(player_cards)
    player_total = eval_hand(player_cards, total_card_value(player_cards))
    separate
    break if player_total == 21
    display_dealer_hand(dealer_cards)
    separate

    loop do
      prompt "Do you want to: h) hit or s) stand"
      player_decision = gets.chomp.downcase

      system "clear"
      hit_or_stand(player_decision, player_cards, deck)
      break if player_decision == 's'
      display_player_hand(player_cards)
      player_total = total_card_value(player_cards)
      eval_hand(player_cards, player_total)
      break if player_total > 21
      separate
      display_dealer_hand(dealer_cards)
      separate
    end

    dealer_total = 0
    loop do
      break if player_total > 21
      separate
      display_full_dealer_hand(dealer_cards)
      separate
      dealer_total = eval_dealer_hand(dealer_cards, total_card_value(dealer_cards), deck)
      break if dealer_total >= 17
    end

    if player_total <= 21 && dealer_total <= 21
      separate
      decide_winner(player_total, dealer_total)
      separate
    end

    prompt "Do you want to play again? (y or n)"
    play_again = gets.chomp.downcase

    break if play_again == 'n'
  end
  break if play_again == 'n'
end

prompt "Thank you for playing 21. Good Bye!"
