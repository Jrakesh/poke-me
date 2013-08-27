
# Author:: Rakesh Jha
# Purpose:: PokeMe- reminder app using sinatra
# Date:: Aug 27, 2013

require 'rubygems'  
require 'sinatra'  
require 'data_mapper' 
require 'dm-core'
require 'dm-timestamps'
require 'debugger'

# Sets up a new SQLite3 database
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/pokeme.db") 

# Sets up a ‘Notes’ table in the DB
class Note  
  # Sets up the DB schema
  include DataMapper::Resource  
  property :id, Serial  #=> Serial suggests auto-incrementing
  property :content, Text, :required => true  
  property :complete, Boolean, :required => true, :default => false  
  property :created_at, DateTime  
  property :updated_at, DateTime  
end

# Update the DB changes
DataMapper.finalize.auto_upgrade!



get '/' do  
  @notes = Note.all :order => :id.desc  
  @title = 'All Notes'  
  erb :home  
end

post '/' do  
  note = Note.new  
  note.content = params[:content]  
  note.created_at = Time.now  
  note.updated_at = Time.now  
  note.save  
  redirect '/'  
end

get '/:id' do  
  @note = Note.get params[:id]  
  @title = "Edit note ##{params[:id]}"  
  erb :edit  
end

# Updates a note with changes
put '/:id' do  
  n = Note.get params[:id]  
  n.content = params[:content]  
  n.complete = params[:complete] ? 1 : 0  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end 

get '/:id/delete' do  
  @note = Note.get params[:id]  
  @title = "Confirm deletion of note ##{params[:id]}"  
  erb :delete  
end

# Deletes a note
delete '/:id' do  
  n = Note.get params[:id]  
  n.destroy  
  redirect '/'  
end 

# Sets the status as complete
get '/:id/complete' do  
  n = Note.get params[:id]  
  n.complete = n.complete ? 0 : 1 # flip it  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end
