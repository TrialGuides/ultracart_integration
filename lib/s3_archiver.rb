module S3Archiver
  def self.data(ultracart_order)
    stage = ultracart_order.current_stage.downcase
    order_number = ultracart_order.order_id.gsub(/^.*CCC-(\d*).*$/i, '\1')
    key = "private/orders/ccc/#{order_number}/#{stage}.xml"

    s3 = AWS::S3.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    bucket = s3.buckets[ENV['AWS_S3_BUCKET']]
    bucket.objects[key].write(ultracart_order.xml.to_s) unless bucket.objects[key].exists?
  end
end
