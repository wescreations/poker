require 'test_helper'

class PokerControllerTest  < ActionDispatch::IntegrationTest
  test "check royal flush" do
    post "/poker/submit_hand", params: { poker_hand: "jd qd kD ad 10d" }
    assert_equal "Hand: Royal Flush. Rank: 1st", flash[:notice]
  end

  test "check straight flush" do
    post "/poker/submit_hand", params: { poker_hand: "ad 2d 3d 4d 5d" }
    assert_equal "Hand: Straight Flush. Rank: 2nd", flash[:notice]
    post "/poker/submit_hand", params: { poker_hand: "kd jd qd kd ad" }
    assert_equal "Hand: Straight Flush. Rank: 2nd", flash[:notice]
  end

  test "check four of a kind" do
    post "/poker/submit_hand", params: { poker_hand: "2d 2C 2H 2s 3s" }
    assert_equal "Hand: Four of a Kind. Rank: 3rd", flash[:notice]
    post "/poker/submit_hand", params: { poker_hand: "2d aD ah ac as" }
    assert_equal "Hand: Four of a Kind. Rank: 3rd", flash[:notice]
  end

  test "check full house" do
    post "/poker/submit_hand", params: { poker_hand: "2H 2c 2d 3d 3C" }
    assert_equal "Hand: Full House. Rank: 4th", flash[:notice]
  end

  test "check flush" do
    post "/poker/submit_hand", params: { poker_hand: "2h 4H 6h 8h 9H" }
    assert_equal "Hand: Flush. Rank: 5th", flash[:notice]
  end

  test "check straight" do
    post "/poker/submit_hand", params: { poker_hand: "6h 3c 4h 5h 7D" }
    assert_equal "Hand: Straight. Rank: 6th", flash[:notice]
    post "/poker/submit_hand", params: { poker_hand: "ah 2c 4h 3h 5D" }
    assert_equal "Hand: Straight. Rank: 6th", flash[:notice]
    post "/poker/submit_hand", params: { poker_hand: "10h jc qh kh aD" }
    assert_equal "Hand: Straight. Rank: 6th", flash[:notice]
  end

  test "check three of a kind" do
    post "/poker/submit_hand", params: { poker_hand: "2h 2c 2d 3d 10c" }
    assert_equal "Hand: Three of a Kind. Rank: 7th", flash[:notice]
  end

  test "check two pair" do
    post "/poker/submit_hand", params: { poker_hand: "2h 2c 3h 3c 5h" }
    assert_equal "Hand: Two Pair. Rank: 8th", flash[:notice]
  end

  test "check pair" do
    post "/poker/submit_hand", params: { poker_hand: "2h 2c 3h 4h 5h" }
    assert_equal "Hand: Pair. Rank: 9th", flash[:notice]
  end

  test "high card" do
    post "/poker/submit_hand", params: { poker_hand: "8h 2C 3h 4H 9h" }
    assert_equal "Hand: None / High Card. Rank: 10th", flash[:notice]
  end

  test "check length" do
    message = "Invalid Format. Remember each card should be two digits separated by one space character. Example: 2H 3H 7D 10C AD."
    post "/poker/submit_hand", params: { poker_hand: "2h 4h 5h 7d 9d 6d 7d 8h" }
    assert_equal message, flash[:alert]
    post "/poker/submit_hand", params: { poker_hand: "2h 4h 5h" }
    assert_equal message, flash[:alert]
    post "/poker/submit_hand", params: { poker_hand: "2h22h3 2kkh 10k au*&**" }
    assert_equal message, flash[:alert]
  end

  test "check duplicates" do
    post "/poker/submit_hand", params: { poker_hand: "2h 4h 5h 7d 2h" }
    assert_equal "Hmm... some cards appear to be duplicates.", flash[:alert]
  end

  test "check valid cards" do
    post "/poker/submit_hand", params: { poker_hand: "2h 4h 5h 7d 9g" }
    assert_equal "Hmm... some cards appear to be invalid.", flash[:alert]
  end
end
