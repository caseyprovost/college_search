require "test_helper"
require "webmock/minitest"

class CollegesTest< ActionDispatch::IntegrationTest
  test "when colleges are found" do
    school_name = "Harv"

    stub_request(:get, "https://api.data.gov/ed/collegescorecard/v1/schools.json?api_key=FAKE&fields=ope6_id,school.name&school.name=#{school_name}").
      with(
        headers: {
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby',
          'Content-Type' => 'application/json'
        }
      ).
      to_return(
        body: {
          "results" => [
            { "school.name" => "Harvard" },
            { "school.name" => "Harvey Wellington College" }
          ]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    get root_path(search: school_name)

    assert_select "div", text: "Harvard", count: 1
    assert_select "div", text: "Harvey Wellington College", count: 1
  end

  test "when colleges are not found" do
    school_name = "Harv"

    stub_request(:get, "https://api.data.gov/ed/collegescorecard/v1/schools.json?api_key=FAKE&fields=ope6_id,school.name&school.name=#{school_name}").
      with(
        headers: {
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby',
          'Content-Type' => 'application/json'
        }
      ).
      to_return(
        body: {
          "results" => []
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    get root_path(search: school_name)

    assert_select "p", text: "No colleges match the criteria", count: 1
  end

  test "when the API throws an error" do
    school_name = "Harv"

    stub_request(:get, "https://api.data.gov/ed/collegescorecard/v1/schools.json?api_key=FAKE&fields=ope6_id,school.name&school.name=#{school_name}").
      with(
        headers: {
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby',
          'Content-Type' => 'application/json'
        }
      ).
      to_return(status: [500, "Internal Server Error"])

    get root_path(search: school_name)

    assert_select "p", text: "No colleges match the criteria", count: 1
  end
end
