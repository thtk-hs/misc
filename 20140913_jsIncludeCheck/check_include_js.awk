#
#
#  ls -1F ./ grep -v / | gawk -f check_include_js.awk -v include_txt=include.txt class_type=controller
#

BEGIN {
  is_not_found = 0
  split("", included_js)

  
  is_to_store = 0
  while ((getline line < include_txt) >0) {

    if (match(line, "^<.+>$")) {
      type = line
      gsub("[<>]", "", type)
      if (type == class_type) {
        if (length(included_js) == 0) {
          is_to_store = 1
        }
      } else {
        is_to_store = 0
      }
    } else {
      if (is_to_store) {
        included_js[line] = line
      }
    }
  }

  close(include_txt)
}

{
  if (! included_js[$1]) {
    is_not_found = 1
    print $1
  }
}

END {
  if (is_not_found) {
    print "  is(are) not found in part of '" class_type "' of '" include_txt "'"
    exit 1
  }

  exit 0
}

