#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
PENDING_MARK="${YELLOW}•${NC}"

declare -A checklist=(
  ["Reviewed all changes"]="false"
  ["Tested the code"]="false"
  ["Updated documentation"]="false"
  ["Removed debug statements"]="false"
  ["Checked for sensitive data"]="false"
)

display_checklist() {
  echo -e "\n=== Pre-Push Checklist ==="
  local index=1
  for item in "${!checklist[@]}"; do
      local mark=$([[ ${checklist[$item]} == "true" ]] && echo "✅" || echo "•")
      echo -e "$index. $mark $item"
      ((index++))
  done
}

toggle_item() {
  local index=$1
  local current_index=1

  for item in "${!checklist[@]}"; do
    if [[ $current_index -eq $index ]]; then
      checklist[$item]=$([[ ${checklist[$item]} == "false" ]] && echo "true" || echo "false")
      break
    fi
    ((current_index++))
  done
}

all_checked() {
  for value in "${checklist[@]}"; do
    if [[ $value == "false" ]]; then
      return 1
    fi
  done
  return 0
}

get_and_display_message() {
  local messages=("${!1}")

  random_index=$((RANDOM % ${#messages[@]}))
  echo "${messages[$random_index]}"
}

get_encouraging_message() {
  messages=(
    "No worries! Better to catch things early! 💪"
    "Taking your time leads to better code! 🌟"
    "Quality over speed - you've got this! 🚀"
    "Good catch! Future you will thank present you! 🎯"
    "That's the spirit! Clean code is happy code! ✨"
    "Smart move! Take the time you need! 🎨"
    "Excellence takes patience - you're doing great! 🌈",
  )
  get_and_display_message messages[@]
}

get_success_message() {
  messages=(
    "Awesome work completing your checklist! 🎉"
    "Look at you, being all professional! 🌟"
    "Your attention to detail is amazing! 💫"
    "Great job following best practices! 🏆"
    "Your future self will thank you! 🙌"
    "Now that's how it's done! 🚀"
    "You're making the codebase better! ⭐"
  )
  get_and_display_message messages[@]
}

get_bypass_message() {
  messages=(
    "No worries, we all have to bypass sometime!"
    "Just make sure you do it next time!"
  )
  get_and_display_message messages[@]
}

while true; do
  clear
  display_checklist
  echo -e "\nCommands:"
  echo "• Enter a number (1-${#checklist[@]}) to toggle an item"
  echo "• Enter 'c' to continue if all items are checked"
  echo "• Enter 'b' to bypass checklist"
  echo "• Enter 'q' to quit and cancel the push"
  echo "Another command"

  read -p $'\nEnter command: ' cmd </dev/tty

  case $cmd in
    [1-9])
      if [[ $cmd -le ${#checklist[@]} ]]; then
          toggle_item $cmd
      fi
      ;;
    "c")
      if all_checked; then
        success_msg=$(get_success_message)
        echo -e "\n✅${GREEN} $success_msg${NC}"
        echo -e "\n${GREEN} Proceeding with push...${NC}"
        exit 0
      else
        encourage_msg=$(get_encouraging_message)
        echo -e "\n${YELLOW}⚠️ Please complete all checklist items before continuing.${NC}"
        read -n 1 -s -r -p "Press any key to continue..."
      fi
      ;;
    "b")
      bypass_msg=$(get_bypass_message)
      echo -e "\n$bypass_msg"
      echo -e "\nProceeding with push..."
      exit 0
      ;;
    "q")
      encourage_msg=$(get_encouraging_message)
      echo -e "\n${YELLOW}⚠️  Push cancelled. $encourage_msg ${NC}"
      exit 1
      ;;
    *)
      echo -e "\n${RED}Invalid command. Please try again.${NC}"
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
  esac
done
