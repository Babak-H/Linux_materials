# Bash Sleep and Delays Tutorial

## What `sleep` Does

The `sleep` command pauses execution for a specified amount of time.

Basic syntax:

```bash
sleep NUMBER
```

Examples:

```bash
sleep 5
sleep 180
sleep 300
```

Common time values:

| Command | Delay |
| --- | --- |
| `sleep 5` | 5 seconds |
| `sleep 180` | 3 minutes |
| `sleep 300` | 5 minutes |

## Add a Delay in a Pipeline

When using piped commands, make sure the delay happens in the correct part of the command sequence.

This command runs a Kubernetes script, waits 3 minutes, and then pipes the combined output to `grep`:

```bash
(kubectl exec v-tools-1 -n v-operators-1 -- ./scripts/posting_failures.sh; sleep 180) | grep '"id":'
```

The parentheses create a command group:

```bash
(command1; command2) | command3
```

In this example:

| Part | Meaning |
| --- | --- |
| `kubectl exec ...` | Runs the script inside the Kubernetes pod |
| `sleep 180` | Waits for 3 minutes |
| `grep '"id":'` | Filters output lines containing `"id":` |

## Use a Temporary File

Another approach is to save command output to a temporary file, wait, and then process the file.

```bash
kubectl exec v-tools-1 -n v-operators-1 -- ./scripts/posting_failures.sh > temp_output.txt
sleep 180
grep '"id":' temp_output.txt
```

This workflow does three things:

1. Saves the script output into `temp_output.txt`
2. Waits for 3 minutes
3. Searches the saved output with `grep`

When you no longer need the temporary file, remove it:

```bash
rm temp_output.txt
```

## Add a Delay Between `curl` Requests with `xargs`

If you are using `xargs` to run one `curl` request per account ID, wrap the `curl` command and `sleep` command inside `bash -c`.

```bash
cat "$EXPORTED_FAILURES" \
  | jq -sr ".[] ${FAILURE_CONDITION} | .account_id" \
  | uniq \
  | xargs -I '{}' -n1 bash -c '
      curl -k "${REPOSTING_URL}:republish" \
        -X POST \
        -H "X-Auth-Token: ${REPOSTING_TOKEN}" \
        -H "Content-Type: Application/Json" \
        --data-binary "{\"account_id\": \"{}\",\"republish_type\": \"REPUBLISH_TYPE_REPUBLISH_FAILURES\"}"
      sleep 300
    '
```

The `sleep 300` command pauses for 5 minutes after each `curl` request.

Why `bash -c` is needed:

| Without `bash -c` | With `bash -c` |
| --- | --- |
| `xargs` runs one command at a time | You can run multiple commands per item |
| Harder to add `sleep` after each request | `curl` and `sleep` run together for each account ID |

## Use a `for` Loop Instead

A loop is often easier to read than a long `xargs` command.

First, extract the account IDs:

```bash
account_ids=$(cat "$EXPORTED_FAILURES" | jq -sr ".[] ${FAILURE_CONDITION} | .account_id" | uniq)
```

Then loop over each account ID:

```bash
for account_id in $account_ids; do
  curl -k "${REPOSTING_URL}:republish" \
    -X POST \
    -H "X-Auth-Token: ${REPOSTING_TOKEN}" \
    -H "Content-Type: Application/Json" \
    --data-binary "{\"account_id\": \"${account_id}\",\"republish_type\": \"REPUBLISH_TYPE_REPUBLISH_FAILURES\"}"

  sleep 300
done
```

This version is easier to modify and debug because each step is visible:

| Step | What Happens |
| --- | --- |
| `account_ids=...` | Collects account IDs from the exported failures file |
| `for account_id in ...` | Runs once for each account ID |
| `curl ...` | Sends the reposting request |
| `sleep 300` | Waits 5 minutes before the next request |

## Quick Reference

| Task | Command |
| --- | --- |
| Sleep for 3 minutes | `sleep 180` |
| Sleep for 5 minutes | `sleep 300` |
| Run two commands before a pipe | `(command1; command2) | command3` |
| Save output to a temp file | `command > temp_output.txt` |
| Search saved output | `grep '"id":' temp_output.txt` |
| Remove temp file | `rm temp_output.txt` |
| Run multiple commands per `xargs` item | `xargs -I '{}' bash -c 'command; sleep 300'` |
| Loop over values | `for item in $items; do command; sleep 300; done` |

