#!/bin/env bash

# The 'set -e' command makes the script exit immediately if any command fails (returns a non-zero exit status)
set -e

releaseJsonPath=${1}
targetPath=${2}

function buildAclsForResourceType() {
    kafka_requirement=${1}
    resourceType=${2}
    principal=${3}

    baseACLCreationCommand="kafka-acls --bootstrap-server \${BOOTSTRAP_SERVER}:9092 --command-config ~/connect.properties"

    if [[ ${resourceType} == "topic" ]]; then
      # Parses the JSON and extracts the resources.topics field
      # jq -c '.[]' : '.[]' iterates over each element in the topics array
      # -c flag means “compact output” , This outputs each element on a single line, no whitespace, no indentation — useful for piping, grep, or feeding into other commands
      resources_configurations=$(echo "${kafka_requirement}" | jq '.resources.topics' | jq -c '.[]');
    elif [[ ${resourceType} == "group" ]]; then
      resources_configurations=$(echo "${kafka_requirement}" | jq '.resources.groups' | jq -c '.[]');
    fi

#{
#  "resources": {
#    "topics": [
#      {"name": "topic1", "partitions": 3},
#      {"name": "topic2", "partitions": 5}
#    ]
#  }
#}

    for resource_configuration in ${resources_configurations};
    do
      # The -e flag in the echo command enables interpretation of escape sequences, allowing special characters like \n(newline), \t(tab), and \e(ANSI escape codes) to be processed.
      echo -e "\nConstructing ${resourceType} related ACLs"
      # The command tr -d '"' is used to delete all double quotes (") from input.
      permission_type=$(echo "${resource_configuration}" | jq '.permission_type' | tr -d '"')
      # The command tr "[:upper:]" "[:lower:]" converts uppercase letters to lowercase.
      permission_type_attribute=$(echo -e "--$permission_type-principal" | tr "[:upper:]" "[:lower:]")
      permissions_command=""
      # jq '.permissions' | jq '.[]' => First jq extracts the permissions array/object , The output of the first jq becomes input to the second jq , The second jq applies .[] to that input, iterating its elements
      # jq '.permissions | .[]' => A single jq program , First selects .permissions, then immediately applies .[] , This is a single process using a jq filter pipeline, which is more efficient
      permissions=$(echo "${resource_configuration}" | jq '.permissions' | jq '.[]')

      for permission in ${permissions}
      do
        # The command tr -d "\"" removes all double quotes (") from the input
        permission_updated=$(echo "${permission}" | tr -d "\"")
        permissions_command+="--operation ${permission_updated}"
      done
      # | jq 'has("prefixes")' => Does this object have a key named "prefixes" , {"name": "foo", "prefixes": ["x", "y"]}
      if [ $(echo "${resource_configuration}" | jq 'has("prefixes")') == "true" ]
      then
        prefixes=$(echo "${resource_configuration}" | jq '.prefixes' | jq '.[]')
        echo "commands to be executed:"
        for prefix in ${prefixes}
        do
          prefix_updated=$(echo "${prefix}" | tr -d "\"")
          # The 'tee' command is used to write output to both the terminal and a file simultaneously. The -a (append) flag ensures that the output is added to the file without overwriting existing content
          echo -e "${baseACLCreationCommand} --add --resource-pattern-type prefixed --allow-host '*' ${permission_type_attribute} User:${principal} --${resourceType} \"${prefix_updated}\" ${permissions_command}" | tee -a "${targetPath}"/acl_commands_full.txt
          # same command as above, but for vault-operator user
          echo -e "${baseACLCreationCommand} --add --resource-pattern-type prefixed --allow-host '*' ${permission_type_attribute} User:vault-operator --${resourceType} \"${prefix_updated}\" ${permissions_command}" | tee -a "${targetPath}"/acl_commands_vault_operator.txt
        done
      # if the resource_configuration json contains a key called 'name' then:
      elif [ $(echo "${resource_configuration}" | jq 'has("name")')  == "true" ]
      then
        topics=$(echo "${resource_configuration}" | jq '.name' | jq '.[]')
        echo "Commands to be executed:"
        for topic in ${topics}
        do
          topic_updated=$(echo "${topic}" | tr -d "\"")
          echo -e "${baseACLCreationCommand} --add --resource-pattern-type literal --allow-host '*' ${permission_type_attribute} User:${principal} --${resourceType} \"${topic_updated}\" ${permissions_command}" | tee -a "${targetPath}/"acl_commands_full.txt
          echo -e "${baseACLCreationCommand} --add --resource-pattern-type literal --allow-host '*' ${permission_type_attribute} User:vault-operator --${resourceType} \"${topic_updated}\" ${permissions_command}" | tee -a "${targetPath}"/acl_commands_vault_operator.txt
        done
      fi

    done
}

# From the top-level list, keep only those items whose value.components array contains at least one element containing any of these strings: observability, istio, vault-core, webhook-operator
kafka_requirements_list=$(cat "${releaseJsonPath}" | jq '.metadata.kafka_principals | to_entries | .[] | select(.value.components[] | contains("observability") or contains("istio") or contains("vault-core") or contains("webhook-operator"))' | jq -c '.value')

#
#.[]                                       .[] iterates over each element of the top-level array or object values
#| select(                                 select(expr) keeps only items for which expr evaluates to true
#    .value.components[]                   For the current item coming from .[]: Access its field .value.components, So now the pipeline inside select is working on each individual component string
#    | contains("observability")           These are string-contains checks: Each returns true if the current component string contains the given substring.
#      or contains("istio")
#      or contains("vault-core")
#      or contains("webhook-operator")
#  )

echo "Commands to be executed when creating full set of ACLs:" > "${targetPath}"/acl_commands_full.txt
echo "" > "${targetPath}"/acl_commands_vault_operator.txt

for kafka_requirement_json in ${kafka_requirements_list}
do
  principal=$(echo "${kafka_requirement_json}" | jq '.principal' | tr -d "\"")
  echo "Discovered principal : ${principal}"

  component=$(echo "${kafka_requirement_json}" | jq '.components')
  echo "Discovered components : ${component}"

  # calling the function defined above with required variables
  buildAclsForResourceType "${kafka_requirement_json}" "topic" "${principal}"
  buildAclsForResourceType "${kafka_requirement_json}" "group" "${principal}"

  echo -e "\n---------------------------------------------------------------------\n"
done

# | sort -u  => sort: Sorts the lines in alphabetical order , -u (unique): Removes duplicate lines.
cat "${targetPath}"/acl_commands_vault_operator.txt | sort -u | tee "${targetPath}"/acl_commands_vault_operator_without_duplicates.txt
