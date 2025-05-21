file=$(basename $kak_buffile)
file_extention="${file##*.}"
file_name=$(basename $file .$file_extention)
file_path=$(dirname "$file")

compile (){
  compiler=$1
  compile_result=$($compiler $2 $3 $4 $5 $6 $7 $8 $9 2>&1)
  if [ $? = 0 ]
  then
      #printf "{+bui@Information}Erfolgreich kompiliert!{Default}\n"
      true
  else
      printf "{+bui@Error}Fehler beim Kompilieren:{red@Default}\n"
      printf "$compile_result" | sed 's/^/{\\}/g'
      false
  fi
}

run (){
  runner=$1
  run_result=$($runner $2 $3 $4 $5 $6 $7 $8 $9 2>&1)
  if [ $? = 0 ]
  then
      #printf "{+bui@Information}Output:{Default}\n"
      printf "{green@Default}"
      printf "$run_result" | sed 's/^/{\\}/g'
      true
  else
      printf "{+bui@Error}Runtime-Fehler:{red@Default}\n"
      printf "$run_result" | sed 's/^/{\\}/g'
      false
  fi
}

if [ $file_extention = "java" ]
then
    compile javac $kak_buffile
    if [ $? -eq 0 ]
    then
        run java $file_name
    fi
fi

if [ $file_extention = "py" ]
then
    run python3 $kak_buffile
fi

if [ $file_extention = "sh" ]
then
    run bash $kak_buffile
fi

if [ $file_extention = "nu" ]
then
    run nu $kak_buffile
fi

if [ $file_extention = "jl" ]
then
    run julia --color=no $kak_buffile
fi

if [ $file_extention = "rs" ]
then
#    compile cargo build --release
#    compile cargo build
#    if [ $? -eq 0 ]
#    then
#        run cargo run --quiet
#    fi
    run cargo run
fi


[[ "$file_extention" == "c" ]] && compile clang $kak_buffile -o $file_name && run ./$file_name
[[ "$file_extention" == "cpp" ]] && compile clang++ $kak_buffile -o $file_name && run ./$file_name

#if [ $file_extention = "c" ]
#then
#    compile clang $kak_buffile -o $file_name
#    if [ $? -eq 0 ]
#    then
#        run ./$file_name
#    fi
#fi
#if [ $file_extention = "cpp" ]
#then
#    compile clang++ $kak_buffile -o $file_name
#    if [ $? -eq 0 ]
#    then
#        run ./$file_name
#    fi
#fi

if [ $file_name = "Dockerfile" ]
then
    compile docker buildx build -q $file_path
    if [ $? -eq 0 ]
    then
        run docker run -t -v /home/cward:/home/cward:rw --rm $compile_result
    fi
fi
