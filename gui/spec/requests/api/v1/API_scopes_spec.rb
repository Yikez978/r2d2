require 'rails_helper'

RSpec.describe "API Scopes " do
  describe 'get /api/scopes/:id' do
    let!(:list) { FactoryGirl.create(:list, name:'Unassigned') }
    let!(:scope) { FactoryGirl.create(:scope, lease_count: 0) }
    before(:each) do
      get "http://api.example.com/api/scopes/#{scope.id}"
    end
    describe 'when successful' do
      it 'returns status 200' do
        expect(response).to be_success
      end
      it 'returns one scope' do
        json = JSON.parse(response.body)
        expect(json.count).to eq(8)
      end
      it 'returns the requested scope\'s fields' do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:id]).to eq(scope.id)
        expect(json[:ip]).to eq(scope.ip)
        expect(json[:mask]).to eq(scope.mask)
        expect(json[:leasetime]).to eq(scope.leasetime)
        expect(json[:description]).to eq(scope.description)
        expect(json[:comment]).to eq(scope.comment)
        expect(json[:state]).to eq(scope.state)
        expect(json[:server_id]).to eq(scope.server_id)
      end
      it 'does not return the created_at field' do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:created_at]).to eq(nil)
      end
      it 'does not return the updated_at field' do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:updated_at]).to eq(nil)
      end
    end
  end

  describe 'Update scope leases using PUT /scopes/:id' do
    let!(:list) { FactoryGirl.create(:list, name:'Unassigned') }
    let!(:scope) { FactoryGirl.create(:scope, lease_count: 0) }
    let!(:device) { FactoryGirl.create(:device) }
    describe 'when successful' do
      it 'should return status 204' do
        put "http://api.example.com/api/scopes/#{scope.id}",
          { scope:
            { leases_attributes:
              [{ ip: '1.1.1.1', mask: '255.255.255.0', expiration: '1', kind: '', name: 'fred',
                device_id: device.id 
              }]
            }
          }.to_json,
          { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
        expect(response.status).to eq(204)
      end

      it 'returns an empty body' do
        put "http://api.example.com/api/scopes/#{scope.id}",
          { scope:
            { leases_attributes:
              [{ ip: '1.1.1.1', mask: '255.255.255.0', expiration: '1', kind: '', name: 'fred',
                device_id: device.id 
              }]
            }
          }.to_json,
          { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
        expect(response.body.length).to eq(0)
      end

      describe 'given an id' do
        let!(:lease) { FactoryGirl.create(:lease, scope: scope) }
        let!(:device2) { FactoryGirl.create(:device) }
        it 'updates a lease' do
          lease_count_before = Lease.count
          lease_id = lease.id
          put "http://api.example.com/api/scopes/#{scope.id}",
            { scope:
              { leases_attributes:
                [{ id: lease_id, ip: '2.1.1.0', expiration: '2', kind: 'D', name: 'fred', mask: '255.255.255.2', device_id: device2.id }]
              }
            }.to_json,
            { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
          expect(Lease.count).to eq(lease_count_before)
          lease = Lease.find(lease_id)
          expect(lease.ip).to eq('2.1.1.0')
          expect(lease.expiration).to eq('2')
          expect(lease.kind).to eq('D')
          expect(lease.name).to eq('fred')
          expect(lease.mask).to eq('255.255.255.2')
          expect(lease.device_id).to eq(device2.id)
        end
      end
    
      it 'creates a lease if there is no id' do
        lease_count_before = Lease.count
        put "http://api.example.com/api/scopes/#{scope.id}",
          { scope:
            { leases_attributes:
              [{ ip: '1.1.1.1', mask: '255.255.255.0', expiration: '1', kind: '', name: '', device_id: device.id  }]
            }
          }.to_json,
          { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
        expect(Lease.count).to eq(lease_count_before + 1)
      end
    
      it 'creates multiple leases if there is no id' do
        lease_count_before = Lease.count
        put "http://api.example.com/api/scopes/#{scope.id}",
          { scope:
            { leases_attributes: 
              [{ ip: '1.1.1.1', mask: '255.255.255.0', expiration: '1', kind: '', name: '', device_id: device.id },
               { ip: '1.1.1.2', mask: '255.255.255.0', expiration: '2', kind: '', name: '', device_id: device.id }]
            }
          }.to_json,
          { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
        expect(Lease.count).to eq(lease_count_before + 2)
      end
    end

    describe 'when unsuccessful' do
      it 'should NOT create a scope' do
        lease_count_before = Lease.count
        put "http://api.example.com/api/scopes/#{scope.id}",
          { scope:
            { leases_attributes:
              [{ leasetime: '691200', ip: '', comment: 'The Comment', description: 'The Description', state: '1', mask: '255.255.255.0', device_id: device.id }]
            }
          }.to_json,

          { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
        expect(Lease.count).to eq(lease_count_before)
      end

      it 'returns status 422 for nil mask' do
        put "http://api.example.com/api/scopes/#{scope.id}",
          { scope:
            { leases_attributes:
              [{ leasetime: '691200', ip: '1.1.1.0', comment: 'The Comment', description: 'The Description', state: '1', mask: nil, device_id: device.id }]
            }
          }.to_json,

          { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
        expect(status).to eq(422)
      end

      it 'returns status 422 for nil IP' do
        put "http://api.example.com/api/scopes/#{scope.id}",
          { scope:
            { leases_attributes:
              [{ leasetime: '691200', ip: nil, comment: 'The Comment', description: 'The Description', state: '1', mask: '255.255.255.0', device_id: device.id }]
            }
          }.to_json,
          { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
        expect(status).to eq(422)
      end

      it 'returns status 422 for nil IP and nil mask' do
        put "http://api.example.com/api/scopes/#{scope.id}",
          { scope:
            { leases_attributes:
              [{ leasetime: '691200', ip: nil, comment: 'The Comment', description: 'The Description', state: '1', mask: nil, device_id: device.id }]
            }
          }.to_json,

          { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
        expect(status).to eq(422)
      end
    end
  end
  
  describe 'get /api/scopes/:id/leases' do
    let!(:list) { FactoryGirl.create(:list, name:'Unassigned') }
    let!(:scope) { FactoryGirl.create(:scope, lease_count: 3) }
    before(:each) do
      get "http://api.example.com/api/scopes/#{scope.id}/leases"
    end  
    describe 'when successful' do
      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'returns three leases' do
        json = JSON.parse(response.body)
        expect(json.count).to eq(3)
      end
    end
  end
end