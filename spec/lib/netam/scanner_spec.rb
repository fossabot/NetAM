require 'rails_helper'

RSpec.describe NetAM::Scanner do
  describe 'run' do
    it 'should raise if job not exist' do
      @section = Section.create!(
        {
          name: 'section 1',
          network: '10.0.0.0/24',
          schedule: 'every 24 hours'
        }
      )

      expect { NetAM::Scanner.new('ScanNetworkWithNothingJob').run(@section.id, @section.network) }.to raise_error(NameError)
    end

    it 'should return job_id' do
      @section = Section.create!(
        {
          name: 'section 1',
          network: '10.0.0.0/24',
          schedule: 'every 24 hours'
        }
      )

      expect(NetAM::Scanner.new('ScanNetworkWithPingJob').run(@section.id, @section.network)).to be_a(String)
      expect(NetAM::Scanner.new('ScanNetworkWithPingJob').run(@section.id, @section.network)).to match(/[a-z0-9]/)
    end
  end

  describe 'status' do
    it "should return nil if job_id not exist" do
      expect(NetAM::Scanner.status('')).to be_nil
      expect(NetAM::Scanner.status(42)).to be_nil
      expect(NetAM::Scanner.status('42')).to be_nil
    end
  end
end