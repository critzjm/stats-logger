StatsLogger::Application.routes.draw do |map|
  match '/log' => 'logger#log'
end
