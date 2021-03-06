require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to :get_node }

    describe "#get_node" do
      context "with a valid nodes_uri" do
        before { @node = @vcloud.get_node(@mock_node.href) }
        subject { @node }

        it_should_behave_like "all responses"
        it { should have_headers_denoting_a_content_type_of "application/vnd.tmrk.ecloud.nodeService+xml" }

        describe "#body" do
          subject { @node.body }

          it { should have(9).keys }

          its(:Href) { should == @mock_node.href }
          its(:Id) { should == @mock_node.object_id.to_s }
          its(:Name) { should == @mock_node.name }
          its(:Enabled) { should == @mock_node.enabled.to_s }
          its(:Port) { should == @mock_node.port.to_s }
          its(:Description) { should == @mock_node.description }
          its(:IpAddress) { should == @mock_node.ip_address }

        end
      end

      context "with a public_ips_uri that doesn't exist" do
        subject { lambda { @vcloud.get_node(URI.parse('https://www.fakey.c/piv8vc99')) } }

        it_should_behave_like "a request for a resource that doesn't exist"
      end
    end
  end
else
end
