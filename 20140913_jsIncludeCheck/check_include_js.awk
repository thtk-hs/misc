BEGIN {
  is_not_found = false
  split("", included_js)

  read {
    is_to_store = false

    if (match(line "^<.+>$)) {
      is_to_store = false

      jsfile = sub("[<>]", "", line)
      if (line == class_type) {
        if (length(included_js) = 0) {
          is_to_store = true
        }
      }
    } else {
      if (is_to_store) {
        included_js[line] = line
      }
    }
  }
}

{
  if (! included_js[$1]) {
    is_not_found = true
    print $1
  }
}

END {
  if (is_not_found) {
    print "  are not found in "
    exit 1
  }

  exit 0
}

