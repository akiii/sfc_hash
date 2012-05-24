class HashtagsCandidateController < ApplicationController
  layout "hashtags"

  def index
    @hashtags_candidate = HashtagCandidate.all
    @hashtags_candidate = @hashtags_candidate.sort_by{ |hashtag_candidate| hashtag_candidate.point }
    @hashtags_candidate = Kaminari.paginate_array(@hashtags_candidate).page(params[:page]).per(100)
  end

end
