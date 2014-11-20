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
  
  if card == "A (S)" || card == "A (C)" || card == "A (H)" || card == "A (D)"
    to_who[1].push(card)
  else
    to_who[0].push(card)
  end
  return card
end

#method to calculate total of a hand including logic for aces
def calculate_total(hand)
  no_ace_total = 0
  hand[0].each do |card|
    no_ace_total += DECK_OF_CARDS.fetch(card)
  end
  
  #ace logic
  case
  when hand[1].empty?
    total = no_ace_total
  when hand[1].count == 1
    if no_ace_total <= 10
      total = no_ace_total + 11
    else
      total = no_ace_total + 1
    end
  when hand[1].count == 2
    if no_ace_total <= 9
      total = no_ace_total + 12
    else
      total = no_ace_total + 2
    end
  when hand[1].count == 3
    if no_ace_total <= 8
      total = no_ace_total + 13
    else
      total = no_ace_total + 3
    end
  when hand[1].count == 4
    if no_ace_total <= 7
      total = no_ace_total + 14
    else
      total = no_ace_total + 4
    end
  end
  return total
end

#method to display the initial cards on the table
def display_player_hand(dealer, player)
  player_number_cards = player.flatten.count
  
  case player_number_cards
  when 2
    draw_2(dealer, player)
  when 3
    draw_3(dealer, player)
  when 4
    draw_4(dealer, player)
  when 5
    draw_5(dealer, player)
  when 6
    draw_6(dealer, player)
  else
    exit
  end
end

#method to display dealer and player hands and update for hits (only up to 6 cards each or exit)
def display_hands(dealer, player)
  dealer_number_cards = dealer.flatten.count
  player_number_cards = player.flatten.count
  
  if dealer_number_cards == 2
    case
    when player_number_cards == 2
      draw_2x2(dealer, player)
    when player_number_cards == 3
      draw_2x3(dealer, player)
    when player_number_cards == 4
      draw_2x4(dealer, player)
    when player_number_cards == 5
      draw_2x5(dealer, player)
    when player_number_cards == 6
      draw_2x6(dealer, player)
    else
      exit
    end
  
  elsif dealer_number_cards == 3
    case 
    when player_number_cards == 2
      draw_3x2(dealer, player)
    when player_number_cards == 3
      draw_3x3(dealer, player)
    when player_number_cards == 4
      draw_3x4(dealer, player)
    when player_number_cards == 5
      draw_3x5(dealer, player)
    when player_number_cards == 6
      draw_3x6(dealer, player)
    else
      exit
    end

  elsif dealer_number_cards == 4
    case
    when player_number_cards == 2
      draw_4x2(dealer, player)
    when player_number_cards == 3
      draw_4x3(dealer, player)
    when player_number_cards == 4
      draw_4x4(dealer, player)
    when player_number_cards == 5
      draw_4x5(dealer, player)
    when player_number_cards == 6
      draw_4x6(dealer, player)
    else
      exit
    end

  elsif dealer_number_cards == 5
    case 
    when player_number_cards == 2
      draw_5x2(dealer, player)
    when player_number_cards == 3
      draw_5x3(dealer, player)
    when player_number_cards == 4
      draw_5x4(dealer, player)
    when player_number_cards == 5
      draw_5x5(dealer, player)
    when player_number_cards == 6
      draw_5x6(dealer, player)
    else
      exit
    end

  elsif dealer_number_cards == 6
    case 
    when player_number_cards == 2
      draw_6x2(dealer, player)
    when player_number_cards == 3
      draw_6x3(dealer, player)
    when player_number_cards == 4
      draw_6x4(dealer, player)
    when player_number_cards == 5
      draw_6x5(dealer, player)
    when player_number_cards == 6
      draw_6x6(dealer, player)
    else
      exit
    end
  else
    exit
  end  
end

def determine_winner(dealer_total, player_total)
  if dealer_total > player_total
    puts "#{dealer_total} beats your #{player_total}."
    puts "You lose!"
  elsif player_total > dealer_total
    puts "Your #{player_total} beats #{dealer_total}."
    puts "You win!"
  else
    puts "Push!" 
  end  
end

#start game loop
play_again = "Y"

while play_again == "Y" do

  #empty arrays to store the cards in player and dealer hands - hand[0] for non-aces, hand[1] for aces
  player_hand = [[], []]

  dealer_hand = [[], []]

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

  #binding.pry

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
        else
          next
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
  play_again = gets.chomp.upcase
end
 


