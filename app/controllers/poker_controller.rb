class PokerController < ApplicationController
  def submit_hand
    raw_poker_hand = params[:poker_hand]
    poker_hand = params[:poker_hand].upcase.split.sort
    if correct_length?(poker_hand, raw_poker_hand)
      if duplicate_check?(poker_hand)
        if valid_cards?(poker_hand)

          poker_hand_parsed = poker_hand
          poker_hand_parsed[0] = [poker_hand[0].chop, poker_hand[0][-1, 1]]
          poker_hand_parsed[1] = [poker_hand[1].chop, poker_hand[1][-1, 1]]
          poker_hand_parsed[2] = [poker_hand[2].chop, poker_hand[2][-1, 1]]
          poker_hand_parsed[3] = [poker_hand[3].chop, poker_hand[3][-1, 1]]
          poker_hand_parsed[4] = [poker_hand[4].chop, poker_hand[4][-1, 1]]

          poker_hand_numbers_only = [poker_hand_parsed[0][0],poker_hand_parsed[1][0], poker_hand_parsed[2][0], poker_hand_parsed[3][0], poker_hand_parsed[4][0]]
          poker_hand_suits_only = [poker_hand_parsed[0][1], poker_hand_parsed[1][1], poker_hand_parsed[2][1], poker_hand_parsed[3][1], poker_hand_parsed[4][1]]
          converted_numbers = converted_numbers(poker_hand_numbers_only).sort
          occurences = occurences_check(poker_hand_numbers_only)

          if royal_flush(poker_hand)
          else
            if straight_flush(poker_hand_suits_only, converted_numbers)
            else
              if four_of_a_kind(poker_hand_numbers_only, occurences)
              else
                if full_house(poker_hand_numbers_only, occurences)
                else
                  if flush(poker_hand_suits_only)
                  else
                    if straight(converted_numbers)
                    else
                      if three_of_a_kind(poker_hand_numbers_only, occurences)
                      else
                        if two_pair(poker_hand_numbers_only, occurences)
                        else
                          if one_pair(poker_hand_numbers_only)
                          else
                            flash[:notice] = "Cards: #{params[:poker_hand].upcase}. Hand: None / High Card. Rank: 10th"
                            redirect_to poker_main_path
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        else
          flash[:alert] = "Cards: #{params[:poker_hand].upcase}. Hmm... some cards appear to be invalid."
          redirect_to poker_main_path
        end
      else
        flash[:alert] = "Cards: #{params[:poker_hand].upcase}. Hmm... some cards appear to be duplicates."
        redirect_to poker_main_path
      end
    else
      flash[:alert] = "Cards: #{params[:poker_hand].upcase}. Invalid Format. Remember each card should be two digits separated by one space character. Example: 2H 3H 7D 10C AD."
      redirect_to poker_main_path
    end
  end

  private

  def valid_cards?(x)
    diff = x - valid_cards
    diff.length == 0
  end

  def correct_length?(x, y)
    x.size == 5 && y.length.between?(14,18)
  end

  def duplicate_check?(x)
    x.uniq.length == x.length
  end

  def one_pair(x)
    if x.uniq.length == 4
      flash[:notice] = "Cards: #{params[:poker_hand].upcase}. Hand: Pair. Rank: 9th"
      redirect_to poker_main_path
    end
  end

  def two_pair(x, y)
    if x.uniq.length == 3 && y.include?(2)
      flash[:notice] = "Cards: #{params[:poker_hand].upcase}. Hand: Two Pair. Rank: 8th"
      redirect_to poker_main_path
    end
  end

  def three_of_a_kind(x, y)
    if x.uniq.length == 3 && y.include?(3)
      flash[:notice] = "Cards: #{params[:poker_hand].upcase}. Hand: Three of a Kind. Rank: 7th"
      redirect_to poker_main_path
    end
  end

  def straight(x)
    if x[4] - x[3]  == 1 && x[3] - x[2]  == 1 && x[2] - x[1]  == 1 && x[1] - x[0] == 1
      flash[:notice] = "Cards: #{params[:poker_hand].upcase}. Hand: Straight. Rank: 6th"
      redirect_to poker_main_path
    end
  end

  def flush(x)
    if x.uniq.length == 1
      flash[:notice] = "Cards: #{params[:poker_hand].upcase}. Hand: Flush. Rank: 5th"
      redirect_to poker_main_path
    end
  end

  def full_house(x, y)
    if x.uniq.length == 2 && y.include?(3)
      flash[:notice] = "Cards: #{params[:poker_hand].upcase}. Hand: Full House. Rank: 4th"
      redirect_to poker_main_path
    end
  end

  def four_of_a_kind(x, y)
    if x.uniq.length == 2 && y.include?(4)
      flash[:notice] = "Cards: #{params[:poker_hand].upcase}. Hand: Four of a Kind. Rank: 3rd"
      redirect_to poker_main_path
    end
  end

  def straight_flush(x, y)
    if x.uniq.length == 1 && y[4] - y[3] == 1 && y[3] - y[2]  == 1 && y[2] - y[1] == 1 && y[1] - y[0] == 1
      flash[:notice] = "Cards: #{params[:poker_hand].upcase}. Hand: Straight Flush. Rank: 2nd"
      redirect_to poker_main_path
    end
  end

  def royal_flush(x)
    if x == [["10","C"],["A","C"],["J","C"],["K","C"],["Q","C"]] || x == [["10","D"],["A","D"],["J","D"],["K","D"],["Q","D"]] || x == [["10","H"],["A","H"],["J","H"],["K","H"],["Q","H"]] || x == [["10","S"],["A","S"],["J","S"],["K","S"],["Q","S"]]
      flash[:notice] = "Cards: #{params[:poker_hand].upcase}. Hand: Royal Flush. Rank: 1st"
      redirect_to poker_main_path
    end
  end

  def occurences_check(x)
    occurences = []
    x.uniq.each do |num|
      occurences_count = x.count(num)
      occurences << occurences_count
    end
    return occurences
  end

  def converted_numbers(x)
    x.map! {|num|
      if num == "2" || num == "3" || num == "4" || num == "5" || num == "6" || num == "7" || num == "8" || num == "9" || num == "10"
        num.to_i
      elsif num == "J"
        num = 11
      elsif num == "Q"
        num = 12
      elsif num == "K"
        num = 13
      elsif num == "A"
          x.include?(10) ? num = 14 : num = 1
      end
    }
    return x
  end

  def valid_cards
    valid_cards = ["AC", "AS", "AD", "AH", "JC", "JS", "JD", "JH", "KC", "KS", "KD", "KH", "QC", "QS", "QD", "QH", "2C", "2S", "2D", "2H", "3C", "3S", "3D", "3H", "4C", "4S", "4D", "4H", "5C", "5S", "5D", "5H", "6C", "6S", "6D", "6H", "7C", "7S", "7D", "7H", "8C", "8S", "8D", "8H", "9C", "9S", "9D", "9H", "10C", "10S", "10D", "10H"]
  end
end
