#!/bin/bash

# Color codes
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

PAGE_SIZE=10

print_header() {
  clear
  echo "------------------------------------------"
  echo "📦 Storage Usage Viewer"
  echo "Current path: $1"
  echo "------------------------------------------"
}

show_usage() {
  local dir="$1"
  local page="$2"
  local entries=()

  while IFS= read -r line; do
    size=$(echo "$line" | awk '{print $1}')
    path=$(echo "$line" | cut -f2- -d' ')
    entries+=("$size"$'\t'"$path")
  done < <(du -sh "$dir"/* 2>/dev/null | sort -rh)

  local count="${#entries[@]}"
  local start=$((page * PAGE_SIZE))
  local end=$((start + PAGE_SIZE))
  [[ $end -gt $count ]] && end=$count

  local max_bytes=0
  for entry in "${entries[@]}"; do
    size=${entry%%$'\t'*}
    size_bytes=$(numfmt --from=iec 2>/dev/null <<< "$size")
    [[ -z "$size_bytes" ]] && size_bytes=0
    (( size_bytes > max_bytes )) && max_bytes=$size_bytes
  done

  top10_thresh=$((max_bytes * 9 / 10))
  top30_thresh=$((max_bytes * 7 / 10))

  print_header "$dir"

  for ((i=start; i<end; i++)); do
    entry="${entries[i]}"
    size=${entry%%$'\t'*}
    path=${entry#*$'\t'}
    base=$(basename "$path")

    size_bytes=$(numfmt --from=iec 2>/dev/null <<< "$size")
    [[ -z "$size_bytes" ]] && size_bytes=0

    color=$GREEN
    if (( size_bytes >= top10_thresh )); then
      color=$RED
    elif (( size_bytes >= top30_thresh )); then
      color=$YELLOW
    fi

    printf "%s📁 %s%s (%s)\n" "$color" "$base" "$RESET" "$size"
  done

  echo ""
  echo "Page $((page + 1)) of $(((count + PAGE_SIZE - 1) / PAGE_SIZE))"
}

browse_directory() {
  local current_dir="$1"
  local page=0

  while true; do
    show_usage "$current_dir" "$page"

    echo ""
    echo "n) Next page   p) Previous page"
    echo "cd <folder>    u) Up a level"
    echo "q) Quit"
    echo -n "> "
    read -r choice

    case "$choice" in
      n)
        ((page++))
        ;;
      p)
        ((page > 0)) && ((page--))
        ;;
      cd\ *)
        subdir="${choice#cd }"
        if [[ -d "$current_dir/$subdir" ]]; then
          current_dir="$current_dir/$subdir"
          page=0
        else
          echo "❌ Folder not found."
          read -p "Press enter to continue..."
        fi
        ;;
      u)
        current_dir=$(dirname "$current_dir")
        page=0
        ;;
      q)
        break
        ;;
      *)
        echo "❌ Invalid option."
        read -p "Press enter to continue..."
        ;;
    esac
  done
}

# Main entry point
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: $0 [start_path]"
  echo "If no path is given, defaults to current directory."
  exit 0
fi

if [[ -n "$1" ]]; then
  if [[ -d "$1" ]]; then
    start_dir=$(realpath "$1")
  else
    echo "❌ Error: '$1' is not a valid directory."
    exit 1
  fi
else
  start_dir=$(realpath ".")
fi

browse_directory "$start_dir"
