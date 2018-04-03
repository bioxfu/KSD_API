docker kill ksd_shiny

docker rm ksd_shiny

docker run --name ksd_shiny -d -p 8383:3838 -v $PWD/Shiny/:/srv/shiny-server/ bioxfu/shiny-server

