git log --reverse --pretty=format:"%s" | awk '!/^Merge (pull|branch) /' | awk '!seen[$0]++' > commit_log.txt
