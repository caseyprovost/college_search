class CollegesController < ApplicationController
  def index
    if params[:search].present?
      @colleges = find_colleges
    else
      @colleges = []
    end
  end

  private

  def find_colleges
    api_key = ENV["API_KEY"]
    school_name = CGI.escape(params[:search])

    response = Rails.cache.fetch("college_search_#{school_name}", expires_in: 1.day) do
      fetch_remote_colleges(api_key, school_name)
    end

    response.parsed_response["results"].map do |data|
      { name: data["school.name"] }
    end
  end

  def fetch_remote_colleges(api_key, school_name)
    begin
      response = HTTParty.get("https://api.data.gov/ed/collegescorecard/v1/schools.json?api_key=#{api_key}&school.name=#{school_name}&fields=ope6_id,school.name", headers: { 'Content-Type' => 'application/json' })
      raise "College API down" if response.code.to_i != 200
      response
    rescue StandardError => e
      # in the future we would probably alert around data availability
      OpenStruct.new(parsed_response: { "results" => [] })
    end
  end
end
