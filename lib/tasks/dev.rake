desc "Fill the database tables with some sample data"
task sample_data: :environment do
  p "Creating sample data"

  # Clear existing data and start fresh
  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end


  usernames = Array.new { Faker::Name.first_name }

  usernames << "alice"
  usernames << "bob"

   usernames.each do |username|
     User.create(  email: "#{username}@example.com",
     password: "password",
     username: username.downcase,
     private: [true, false].sample,
     )
   end


  users = []  # Array to store created users

  # Create 12 users with unique names and random privacy settings
  12.times do
    name = Faker::Name.first_name
    user = User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name,
      private: [true, false].sample  # Randomly assign privacy setting
    )

    # Add successfully created users to the users array
    users << user if user.persisted?
  end

  p "There are now #{User.count} users."

  # Generate follow requests between users
  users.each do |first_user|
    users.each do |second_user|
      next if first_user == second_user  # Skip if users are the same

      # Randomly create follow requests with a 75% chance
      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample  # Randomly assign status
        )
      end

      # Repeat for the second user to possibly create a mutual follow request
      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.keys.sample
        )
      end
    end
  end

  p "There are now #{FollowRequest.count} follow requests."

  # Generate photos, likes, and comments for each user
  users.each do |user|
    rand(15).times do  # Each user posts between 0 and 15 photos
      photo = user.own_photos.create(
        caption: Faker::Quote.jack_handey,  # Use a random quote for caption
        image: "https://robohash.org/#{rand(9999)}"  # Generate a random image URL
      )

      # For each of the user's followers, randomly decide to like the photo or leave a comment
      user.followers.each do |follower|
        # 50% chance for a follower to like the photo, avoiding duplicates
        if rand < 0.5 && !photo.fans.include?(follower)
          photo.fans << follower
        end

        # 25% chance for a follower to comment on the photo
        if rand < 0.25
          photo.comments.create(
            body: Faker::Quote.jack_handey,  # Use a random quote for comment
            author: follower
          )
        end
      end
    end
  end

  # Print the count of created records for users to verify
  p "There are now #{Photo.count} photos."
  p "There are now #{Like.count} likes."
  p "There are now #{Comment.count} comments."
end
