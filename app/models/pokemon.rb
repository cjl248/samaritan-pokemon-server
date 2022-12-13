class Pokemon < ApplicationRecord
  has_and_belongs_to_many :types, dependent: :destroy
  has_one_attached :image

  # used for clearing images from the AWS S3 client
  after_destroy :delete_AWS_image

  # validating presence of :image field through database constraint
  validates :name, presence: true, uniqueness: true


  private

  def delete_AWS_image
    self.image.purge
  end

  def image_url
    self.image.attachment.url
  end

end
