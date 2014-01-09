require "sequel"
require "pathname"
require "open-uri"

class	Hashtagram
	@@db = Sequel.sqlite('./db/hashtagram.db')
	def self.config
		@@db.create_table?(:posts) do
			primary_key :id
			string :instagram_id, unique: true
			string :username
			string :comment
			string :image_name
			bignum :created_time
			fixnum :is_acepted, default: 0
		end
	end
	
	def self.get_one()
		row = @@db.fetch("SELECT * FROM posts WHERE is_acepted = 1 ORDER BY RANDOM() LIMIT 1").all
		row
	end
	
	def self.reset_db()
		@@db.create_table!(:posts) do
			primary_key :id
			string :instagram_id, unique: true
			string :username
			string :comment
			string :image_name
			bignum :created_time
			fixnum :is_acepted, default: 0
		end
	end
	
	def self.add(data)
		posts_inserted = []
	  for media_item in data
			
			check = @@db[:posts].where(instagram_id: media_item.id)
			
			
			if check.count() == 0
				image_basename = Pathname.new(media_item.images.standard_resolution.url).basename.to_s
			
				File.open("./public/uploads/" + image_basename, "wb") do |fo|
					fo.write open(media_item.images.standard_resolution.url).read
				end
				
				caption = ""
				caption = media_item.caption.text if !media_item.caption.nil?
				posts_inserted << media_item
				@@db[:posts].insert(instagram_id: media_item.id, username: media_item.user.username, comment: caption, image_name: image_basename, created_time: media_item.created_time)
			end
			
	  end
		posts_inserted
	end
	
	def self.acept(id)
		#@@db.execute("UPDATE posts SET is_acepted = 1 WHERE instagram_id = #{id}")
		@@db[:posts].where({instagram_id: id}).update({is_acepted: 1});
	end
end