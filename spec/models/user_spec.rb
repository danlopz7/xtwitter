require 'rails_helper'
RSpec.describe User, type: :model do
  
  # Creando una instancia de User usando FactoryBot
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet, user: user) }
  let(:another_user) { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should allow_value('valid_Password123').for(:password)}
    it { should validate_length_of(:password).is_at_least(12)}
  end
  describe 'associations' do
    it { should have_many(:tweets) }
    it { should have_many(:retweets) }
    it { should have_many(:followers) }
    it { should have_many(:followees) }
    it { should have_many(:likes) }
    it { should have_many(:bookmarks) }
    it { should have_many(:replies) }
  end

  #Scopes
  describe 'scopes' do
    describe '.user_tweets' do
      it 'returns tweets of a user' do
        expect(User.user_tweets(user.id)).to include(tweet)
        expect(User.user_tweets(another_user.id)).not_to include(tweet)
      end
    end
  end

  # describe '.user_tweets_and_replies' do
  #   it 'returns the tweets and replies of a user' do
  #     tweet = create(:tweet, user: user)
  #     reply = create(:reply, user: user)
  #     expect(User.user_tweets_and_replies(user.id)).to include(tweet, reply)
  #   end
  # end

  describe '.followers_count' do
    before do
      create(:follow, follower: another_user, followee: user)
    end

    it 'returns the number of followers a user has' do
      expect(User.followers_count(user.id)).to eq(1)
    end
  end

  describe '.following_count' do
    before do
      create(:follow, follower: user, followee: another_user)
    end

    it 'returns the number of users a user follows' do
      expect(User.following_count(user.id)).to eq(1)
    end
  end

end

# La función let en RSpec es "lazy-evaluated", lo que significa que el código dentro del bloque 
# let solo se ejecuta cuando el método (en este caso user) se invoca en el test.

# let para crear una instancia del modelo User utilizando la fábrica definida anteriormente. 
# Esta instancia se creará y guardará en la base de datos (por el método create) la primera 
# vez que se llame a user dentro de los ejemplos (los bloques it).

# Por ejemplo, para la validación de unicidad (validate_uniqueness_of), Shoulda Matchers primero 
# creará un registro en la base de datos y luego intentará crear otro registro con el mismo valor
#  en el atributo que se supone que es único. Luego verifica que el modelo arroje un error, 
#  indicando que la validación de unicidad funciona como se espera. El objetivo principal de 
#  Shoulda Matchers es simplificar las pruebas y hacer que el código de prueba sea más legible, 
#  evitando que los desarrolladores escriban pruebas repetitivas y verbosas para funcionalidades 
#  comunes en Rails.