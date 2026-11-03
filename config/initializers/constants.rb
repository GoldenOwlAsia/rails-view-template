module Constants
  ZERO = 0.0

  # Image
  IMAGE_MAX_SIZE = 10.megabytes
  IMAGE_CONTENT_TYPES = /\Aimage\/.*\z/

  # Password
  PASSWORD_REGEX = /\A(?=.*?[A-Z])(?=.*?\d)(?=.*?[#?!@$%^&*\-._()]).{8,}\z/
end
