RSpec.describe Jasonette::Jason::Head do

  let(:builder) { build_with(Jasonette::Jason::Head) }

  it "builds" do
    results = builder.encode do
      title "Foobar"
    end
    expect(results.attributes!).to eq({"title" => "Foobar"})
  end

  context "data" do
    let(:expected) do
      {
        "title" => "Beatles",
        "data" => {
          "names" => ["John", "George", "Paul", "Ringo"]
        }
      }
    end

    let(:expected_with_songs) do
      {
        "title" => "Beatles",
        "data" => {
          "names" => ["John", "George", "Paul", "Ringo"],
          "songs" => [
            {"album" => "My Bonnie", "song" => "My Bonnie"},
            {"album" => "My Bonnie", "song" => "Skinny Minnie"},
            {"album" => "Please Please Me", "song" => "I Saw Her Standing There"},
          ]
        }
      }
    end

    it "builds data from block" do
      results = builder.encode do
        title "Beatles"
        data do
          names ["John", "George", "Paul", "Ringo"]
        end
      end

      expect(results.attributes!).to eq expected
    end

    it "builds data from property" do
      results = builder.encode do
        title "Beatles"
        data.names ["John", "George", "Paul", "Ringo"]
      end

      expect(results.attributes!).to eq expected
    end

    it "builds data from property" do
      results = builder.encode do
        title "Beatles"
        data.names ["John", "George", "Paul", "Ringo"]
        data.songs [
            {album: "My Bonnie", song: "My Bonnie"},
            {album: "My Bonnie", song: "Skinny Minnie"},
            {album: "Please Please Me", song: "I Saw Her Standing There"},
          ]
      end

      expect(JSON.parse(results.target!)).to eq expected_with_songs
    end
  end

  context "styles" do
    let(:expected) do
      {
        "title" => "Foobar",
        "styles" => {
          "styled_row" => {
            "font" => "HelveticaNeue",
            "size" => "20",
            "color" => "#FFFFFF",
            "padding" => "10",
          }
        }
      }
    end

    let(:expected_with_col) do
      {
        "title" => "Foobar",
        "styles" => {
          "styled_row" => {
            "font" => "HelveticaNeue",
            "size" => "20",
            "color" => "#FFFFFF",
            "padding" => "10",
          },
          "col" => {
            "font" => "RobotoBold",
            "color" => "#FF0055",
          }
        }
      }
    end

    it "builds foo style from block" do
      results = builder.encode do
        title "Foobar"
        style "styled_row" do
          font "HelveticaNeue"
          size "20"
          color "#FFFFFF"
          padding "10"
        end
      end

      expect(results.attributes!).to eq expected
    end

    it "builds multiple from Hash" do
      results = builder.encode do
        title "Foobar"
        style "styled_row", font: "HelveticaNeue", size: 20, color: "#FFFFFF", padding: 10
        style "col", font: "RobotoBold", color: "#FF0055"
      end

      expect(results.attributes!).to eq expected_with_col
    end

    it "builds multiple from Hash and block" do
      results = builder.encode do
        title "Foobar"
        style "styled_row" do
          font "HelveticaNeue"
          size "20"
          color "#FFFFFF"
          padding "10"
        end
        style "col", font: "RobotoBold", color: "#FF0055"
      end

      expect(results.attributes!).to eq expected_with_col
    end
  end

  context "unhandle property" do
    it "raise error if property name is `method`" do
      expect { builder.encode do
        action "method" do
          type "$network.request"
        end
      end }.to raise_error "unhandled definition! : use different property name then `method`"
    end
  end

  context "actions" do
    let(:expected) do
      {
        "actions" => {
          "submit_item" => {
            "type" => "$network.request",
            "options" => {
              "url" => "https://url/submit",
              "method" => "POST"
            },
            "success" => { "type" => "$render" },
            "error" => {
              "type" => "$util.banner",
              "options" => {
                "title" => "Error",
                "description" => "Something went wrong."
              }
            }
          }
        }
      }
    end

    it "builds an option with action method" do
      results = builder.encode do
        action "submit_item" do
          type "$network.request"
          options do
            url "https://url/submit"
            action_method "POST"
          end
          success do
            type "$render"
          end
          error do
            type "$util.banner"
            options do
              title "Error"
              description "Something went wrong."
            end
          end
        end
      end

      expect(results.attributes!).to eq expected
    end
  end
end
