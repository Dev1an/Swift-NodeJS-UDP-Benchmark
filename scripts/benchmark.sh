set -eu
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🅰️  Measuring node.js execution time"
cd "$here/../NodeJS"
nodeOutput=$(node test | tee /dev/tty)
nodeTimeExtractor="read[[:space:]]and[[:space:]]write[[:space:]]65535[[:space:]]UDP[[:space:]]messages:[[:space:]]([0-9]+(\.[0-9]+)?)ms"

if [[ $nodeOutput =~ $nodeTimeExtractor ]]
then
	nodeTime="${BASH_REMATCH[1]}"
else
	echo "⚠️  Error while parsing node test output" >&2
	exit 1
fi

echo
echo "🅱️  Measuring swift execution time"
cd "$here/../Swift"
swiftOutput=$(swift test -c release 2>&1 | tee /dev/tty)

swiftTimeExtractor="measured[[:space:]]\[Time,[[:space:]]seconds\][[:space:]]average:[[:space:]]([0-9]+(\.[0-9]+)?)"

if [[ $swiftOutput =~ $swiftTimeExtractor ]]
then
swiftTime="${BASH_REMATCH[1]}"
else
echo "⚠️  Error while parsing swift test output" >&2
exit 1
fi

echo
echo "🌎  Publishing results"
swiftTime=$(awk -v Time=$swiftTime 'BEGIN {printf "%.3f",  Time}')
nodeTime=$(awk -v Time=$nodeTime 'BEGIN {printf "%.3f", Time/1000}')
swift run Publisher $swiftTime $nodeTime "$(uname -ms)"

echo
echo "⏱  Measurements"
echo " Swift took $swiftTime seconds"
echo " node.js took $nodeTime seconds"
