class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def draw_card(deck)
    @cards << deck.playable_cards.pop
  end

  def show_card
    @cards.last
  end

  def value
    value = 0
    @cards.each do |card|
      value += card.value[0]
    end
    value
  end
end

class Game
  attr_reader :player_hand, :dealer_hand
  def initialize
    @deck = Deck.new
    @player_hand = Hand.new
    @dealer_hand = Hand.new
    2.times { @player_hand.draw_card(@deck) }
    2.times { @dealer_hand.draw_card(@deck) }
  end

  def hit
    @player_hand.draw_card(@deck)
  end

  def check_value
    @winner = check_winner(@player_hand.value, @dealer_hand.value)
  end

  def check_winner(player_value, dealer_value )
    return :dealer if player_value > 21
    return :player if dealer_value > 21
  end

  def status
    {
      :player_cards => @player_hand.cards,
      :player_value => @player_hand.value,
      :dealer_cards => @dealer_hand.cards,
      :dealer_value => @dealer_hand.value,
      :winner => @winner
    }
  end
end

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end

  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end

  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end

  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert_false(@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class GameTest < Test::Unit::TestCase
  def setup
    @game = Game.new
  end

  def test_player_has_2_cards
    assert_equal @game.player_hand.cards.length, 2
  end

  def test_dealer_has_2_cards
    assert_equal @game.dealer_hand.cards.length, 2
  end

  def test_player_can_see_dealers_card
    assert_equal @game.dealer_hand.show_card, @game.dealer_hand.cards.last
  end

  def test_player_wins_if_dealer_busts
    assert_equal @game.check_winner(19, 22), :player
  end

  def test_dealer_wins_if_player_busts
    assert_equal @game.check_winner(22, 19), :dealer
  end
end
