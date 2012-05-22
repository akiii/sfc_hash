class CreateHashtagCandidateTweets < ActiveRecord::Migration
  def change
    create_table :hashtag_candidate_tweets do |t|
      t.string :text

      t.timestamps
    end
  end
end
