require 'test_helper'

class PokerControllerTest  < ActionDispatch::IntegrationTest
  test "check royal flush" do
    post "/poker/submit_hand", params: { poker_hand: "jd qd kD ad 10d" }
    assert_includes flash[:notice], "Hand: Royal Flush. Rank: 1st"
  end

  test "check straight flush" do
    post "/poker/submit_hand", params: { poker_hand: "ad 2d 3d 4d 5d" }
    assert_includes flash[:notice], "Hand: Straight Flush. Rank: 2nd"
    post "/poker/submit_hand", params: { poker_hand: "kd jd qd kd ad" }
    assert_includes flash[:notice], "Hand: Straight Flush. Rank: 2nd"
  end

  test "check four of a kind" do
    post "/poker/submit_hand", params: { poker_hand: "2d 2C 2H 2s 3s" }
    assert_includes flash[:notice], "Hand: Four of a Kind. Rank: 3rd"
    post "/poker/submit_hand", params: { poker_hand: "2d aD ah ac as" }
    assert_includes flash[:notice], "Hand: Four of a Kind. Rank: 3rd"
  end

  test "check full house" do
    post "/poker/submit_hand", params: { poker_hand: "2H 2c 2d 3d 3C" }
    assert_includes flash[:notice], "Hand: Full House. Rank: 4th"
  end

  test "check flush" do
    post "/poker/submit_hand", params: { poker_hand: "2h 4H 6h 8h 9H" }
    assert_includes flash[:notice], "Hand: Flush. Rank: 5th"
  end

  test "check straight" do
    post "/poker/submit_hand", params: { poker_hand: "6h 3c 4h 5h 7D" }
    assert_includes flash[:notice], "Hand: Straight. Rank: 6th"
    post "/poker/submit_hand", params: { poker_hand: "ah 2c 4h 3h 5D" }
    assert_includes flash[:notice], "Hand: Straight. Rank: 6th"
    post "/poker/submit_hand", params: { poker_hand: "10h jc qh kh aD" }
    assert_includes flash[:notice], "Hand: Straight. Rank: 6th"
  end

  test "check three of a kind" do
    post "/poker/submit_hand", params: { poker_hand: "2h 2c 2d 3d 10c" }
    assert_includes flash[:notice], "Hand: Three of a Kind. Rank: 7th"
  end

  test "check two pair" do
    post "/poker/submit_hand", params: { poker_hand: "2h 2c 3h 3c 5h" }
    assert_includes flash[:notice], "Hand: Two Pair. Rank: 8th"
  end

  test "check pair" do
    post "/poker/submit_hand", params: { poker_hand: "2h 2c 3h 4h 5h" }
    assert_includes flash[:notice], "Hand: Pair. Rank: 9th"
  end

  test "high card" do
    post "/poker/submit_hand", params: { poker_hand: "8h 2C 3h 4H 9h" }
    assert_includes flash[:notice], "Hand: None / High Card. Rank: 10th"
  end

  test "check length" do
    message = "Invalid Format. Remember each card should be two digits separated by one space character. Example: 2H 3H 7D 10C AD."
    post "/poker/submit_hand", params: { poker_hand: "2h 4h 5h 7d 9d 6d 7d 8h" }
    assert_includes flash[:alert], message
    post "/poker/submit_hand", params: { poker_hand: "2h 4h 5h" }
    assert_includes flash[:alert], message
    post "/poker/submit_hand", params: { poker_hand: "2h22h3 2kkh 10k au*&**" }
    assert_includes flash[:alert], message
  end

  test "check duplicates" do
    post "/poker/submit_hand", params: { poker_hand: "2h 4h 5h 7d 2h" }
    assert_includes flash[:alert], "Hmm... some cards appear to be duplicates."
  end

  test "check valid cards" do
    post "/poker/submit_hand", params: { poker_hand: "2h 4h 5h 7d 9g" }
    assert_includes flash[:alert], "Hmm... some cards appear to be invalid."
  end
end
