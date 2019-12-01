cleanup() {
    pkill -P $$
    exit 0
}
trap cleanup SIGHUP SIGINT SIGTERM

sh crawler.sh & 
sh candlestick.sh

