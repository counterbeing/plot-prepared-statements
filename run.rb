require 'mysql2'
require 'gruff' # Assuming you're switching to 'gruff' since 'Rubyplot' failed

config = {
  host: ENV.fetch('DB_HOST'),
  username: ENV.fetch('DB_USER'),
  password: ENV.fetch('DB_PASSWORD'),
  database: ENV.fetch('DB_NAME'),
  port: ENV.fetch('DB_PORT').to_i,
}

y_data = []

# Initialize Gruff figure
client = Mysql2::Client.new(config)

begin
  while true
    results = client.query("show global status like '%prepared%'")

    results.each do |row|
      puts "#{row['Variable_name']}: #{row['Value']}"
      y_data.push(row['Value'].to_i)
    end

    # Plot the data using Gruff
    g = Gruff::Line.new
    g.data(:y_data, y_data)
    g.write('line_graph.png')

    sleep(10)
  end
rescue => e
  puts "Error: #{e.message}"
ensure
  client.close
end
