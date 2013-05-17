#
# Attention! This task will cleaning Redis DB and remove all pictures!
#
#
namespace :db do
  desc 'Complete cleaning Redis DB and folders for uploading pictures.'
  task redis_cleaning: :environment do
    Ohm.redis.flushall
    FileUtils.rm_rf(Rails.root.join('app', 'assets', 'images', 'uploads'))
  end
end