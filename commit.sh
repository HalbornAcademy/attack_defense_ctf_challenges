if [ $# -eq 0 ]
  then
    echo "No challenge id supplied"
    exit 1
fi

curl http://127.0.0.1/$1/commit
