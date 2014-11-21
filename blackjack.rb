require "pry"
require "./card_designs.rb"

#create the deck
DECK_OF_CARDS = {
  #spades 
  "2 (S)" => 2, "3 (S)" => 3, "4 (S)" => 4, "5 (S)" => 5, "6 (S)" => 6, "7 (S)" => 7, "8 (S)" => 8, "9 (S)" => 9, "10(S)" => 10, "J (S)" => 10, "Q (S)" => 10, "K (S)" => 10, "A (S)" => [1, 11],
  #clubs
  "2 (C)" => 2, "3 (C)" => 3, "4 (C)" => 4, "5 (C)" => 5, "6 (C)" => 6, "7 (C)" => 7, "8 (C)" => 8, "9 (C)" => 9, "10(C)" => 10, "J (C)" => 10, "Q (C)" => 10, "K (C)" => 10, "A (C)" => [1, 11],
  #hearts
  "2 (H)" => 2, "3 (H)" => 3, "4 (H)" => 4, "5 (H)" => 5, "6 (H)" => 6, "7 (H)" => 7, "8 (H)" => 8, "9 (H)" => 9, "10(H)" => 10, "J (H)" => 10, "Q (H)" => 10, "K (H)" => 10, "A (H)" => [1, 11],
  #diamonds
  "2 (D)" => 2, "3 (D)" => 3, "4 (D)" => 4, "5 (D)" => 5, "6 (D)" => 6, "7 (D)" => 7, "8 (D)" => 8, "9 (D)" => 9, "10(D)" => 10, "J (D)" => 10, "Q (D)" => 10, "K (D)" => 10, "A (D)" => [1, 11]
}

#array to store cards that have already been played to ensure no duplicates
cards_in_play = []

#method to deal a random card, update used cards array, and update player or dealer's hand
def deal_a_card(to_who, deck, already_used)
  begin 
    card = deck.keys.sample
  end while already_used.include?(card)

  already_used.push(card)
  to_who.push(card)
  return card
end

#method to calculate total of a hand including logic for aces
def calculate_total(hand)
  total = 0
  hand.each do |card|
    if DECK_OF_CARDS.fetch(card) == [1, 11]
      total += 11
    else
      total += DECK_OF_CARDS.fetch(card)
    end
  end

  #ace logic: subtract 10 for each ace in the hand when the total is over 21
  if total > 21
    hand.select{|ace| ace == "A (S)" || ace == "A (C)" || ace == "A (H)" || ace == "A (D)"}.count.times do
      total -= 10
    end
  end
  
  return total
end

def determine_winner(dealer_total, player_total)
  if dealer_total > player_total
    puts "#{dealer_total} beats your #{player_total}."
    puts "You lose!"
  elsif player_total > dealer_total
    puts "Your #{player_total} beats #{dealer_total}."
    puts "You win!"
  else
    puts "You both have #{player_total}. Push!" 
  end  
end

#start game loop
play_again = "y"

while play_again == "y" do

  #empty arrays to store the cards in player and dealer hands
  player_hand = []
  dealer_hand = []

  #deal cards
  deal_a_card(player_hand, DECK_OF_CARDS, cards_in_play)
  deal_a_card(dealer_hand, DECK_OF_CARDS, cards_in_play)
  deal_a_card(player_hand, DECK_OF_CARDS, cards_in_play)
  deal_a_card(dealer_hand, DECK_OF_CARDS, cards_in_play)

  #show cards to player
  display_player_hand(dealer_hand, player_hand)

  #add up totals
  player_total = calculate_total(player_hand)
  dealer_total = calculate_total(dealer_hand)

  if player_total == 21
    puts "You've got blackjack! You win!"
  elsif dealer_total == 21
    display_hands(dealer_hand, player_hand)
    puts "Dealer has blackjack! You lose!"
  else
    while player_total < 21 do
      puts "You have #{player_total}."
      puts "Input (H) to Hit or (S) to Stay:"
      choice = gets.chomp.upcase
        
      if choice == "H"
        deal_a_card(player_hand, DECK_OF_CARDS, cards_in_play)
        sleep(1)
        display_player_hand(dealer_hand, player_hand)
        sleep(0.5)
        player_total = calculate_total(player_hand)
        if player_total > 21
          puts "You have #{player_total}. BUST! You lose!"
          player_busted = true
          break
        elsif player_total == 21
          puts "21! Very nice."
          player_busted = false
          break
        end
      elsif choice == "S"
        puts "You have #{player_total}."
        player_busted = false
        break
      end
    end

    if !player_busted
      puts "Dealer's turn."
      display_hands(dealer_hand, player_hand)
      sleep(1)

      if dealer_total >=17
        puts "Dealer has #{dealer_total}."
        dealer_busted = false
        sleep(1)
      else
        while dealer_total < 17 do
          puts "Dealer has #{dealer_total}."
          sleep(1)
          puts "Dealer hits..."
          sleep(1)
          deal_a_card(dealer_hand, DECK_OF_CARDS, cards_in_play)
          display_hands(dealer_hand, player_hand)
          dealer_total = calculate_total(dealer_hand)
        
          if dealer_total > 21
            puts "Dealer has #{dealer_total}. BUST! You win!"
            dealer_busted = true
            break
          elsif dealer_total >=17
            dealer_busted = false
            sleep(1)
            break
          else
            sleep(1)
          end
        end
      end

      determine_winner(dealer_total, player_total) if !player_busted && !dealer_busted

    end 
  end
  puts "Play again? (Y/N)"
  play_again = gets.chomp.downcase
end
 


