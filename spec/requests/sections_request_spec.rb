# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Section', type: :request do
  let(:admin) { create :user, :admin }
  let(:vlan) { create :vlan }

  let(:valid_attributes) do
    {
      name: 'section 1',
      network: '10.0.0.0/24',
      schedule: 'every 24 hours',
      vlan_id: vlan.id
    }
  end

  let(:invalid_attributes) do
    {
      name: 'section err',
      network: 'exemple.com',
      schedule: 'every 24 hours',
      vlan_id: 54_643_521
    }
  end

  before do
    sign_in admin
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Section.create! valid_attributes
      get sections_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      Section.create! valid_attributes
      get section_url(Section.maximum(:id))
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_section_url
      expect(response).to be_successful
    end
  end

  describe 'POST /scan' do
    it 'renders a successful response' do
      Section.create! valid_attributes
      post section_scan_url(Section.maximum(:id))
      expect(response.code).to eq('302')
    end
  end

  describe 'POST /export' do
    it 'renders a successful response' do
      Section.create! valid_attributes
      post section_export_url(Section.maximum(:id))
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      pepite = Section.create! valid_attributes
      get edit_section_url(pepite)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Section' do
        expect do
          post sections_url, params: { section: valid_attributes }
        end.to change(Section, :count).by(1)
      end

      it 'redirects to the created section' do
        post sections_url, params: { section: valid_attributes }
        expect(response).to redirect_to(section_url(Section.maximum(:id)))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Section' do
        expect do
          post sections_url, params: { section: invalid_attributes }
        end.to change(Section, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post sections_url, params: { section: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'section 42',
          network: '8.8.8.0/24',
          schedule: '',
          vlan_id: vlan.id
        }
      end

      it 'updates the requested section' do
        section = Section.create! valid_attributes
        patch section_url(section), params: { section: new_attributes }
        section.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the section' do
        section = Section.create! valid_attributes
        patch section_url(section), params: { section: new_attributes }
        section.reload
        expect(response).to redirect_to(section_url(section))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested section' do
      section = Section.create! valid_attributes
      expect do
        delete section_url(section)
      end.to change(Section, :count).by(-1)
    end

    it 'redirects to the sections list' do
      section = Section.create! valid_attributes
      delete section_url(section)
      expect(response).to redirect_to(sections_url)
    end
  end
end
